create database oficina;
use oficina;

-- criar tabela cliente
create table cliente (
	idCliente int auto_increment primary key,
    Nome varchar(45),
    Numero varchar(15),
    Endereco varchar(45)
);

-- criar tabela veiculo
create table veiculo (
	idVeiculo int auto_increment primary key,
    clienteId int,
    Placa varchar(45),
    Modelo varchar(45),
    constraint veiculo_cliente foreign key (clienteId) references cliente(idCliente)
);

-- criar tabela servico
create table servico (
	idServico int auto_increment primary key,
    clienteIdS int,
    tipoServico enum('Manutenção', 'Revisão'),
    nomeServico varchar(45),
    constraint servico_cliente foreign key (clienteIdS) references cliente(idCliente)
);

-- criar tabela mecânico
create table mecanico (
	idMecanico int auto_increment primary key,
    codigo int,
    nome varchar(45),
    endereco varchar(45),
    especialidade varchar(45)
);

-- criar tabela ordem_servico
create table ordem_servico (
	idOrdem int auto_increment primary key,
    numero int,
    idMecanico int,
    dataEmissão date,
    valor varchar(10),
    ordemStatus varchar(15),
    dataConclusao date,
    constraint ordem_mecanico foreign key (idMecanico) references mecanico(idMecanico)
);

-- criar tabela manutencao
create table manutencao (
	idManutencao int auto_increment primary key,
    idServico int,
    valorTotal float,
    pecas varchar(255),
    constraint manutencao_servico foreign key (idServico) references servico(idServico)
);

-- criar tabela revisao
create table revisao (
	idRevisao int auto_increment primary key,
    idServico int,
    valorTotalRevisao float,
    constraint revisao_servico foreign key(idServico) references servico(idServico)
);

-- criar tabela servicos_veiculos
create table servicos_veiculos (
	idServico int,
    idVeiculo int,
    primary key(idServico, idVeiculo),
    constraint sv_servico foreign key (idServico) references servico(idServico),
    constraint sv_veiculo foreign key (idVeiculo) references veiculo(idVeiculo)
);

-- criar tabela servicos_ordensSe
create table servicos_ordensSe (
	idOrdemServico int,
    idServico int,
    primary key(idOrdemServico, idServico),
    constraint so_ordem_servico foreign key (idOrdemServico) references ordem_servico(idOrdem),
    constraint so_servico foreign key (idServico) references servico (idServico)
);

-- Inserir dados na tabela cliente
INSERT INTO cliente (Nome, Numero, Endereco) VALUES
('João Silva', '1234-5678', 'Rua das Flores, 123'),
('Maria Oliveira', '9876-5432', 'Avenida Principal, 456'),
('Carlos Pereira', '5555-1111', 'Travessa da Saudade, 789');

select * from cliente;

-- Inserir dados na tabela veiculo
INSERT INTO veiculo (clienteId, Placa, Modelo) VALUES
(1, 'ABC-1234', 'Fiat Uno'),
(2, 'DEF-5678', 'Volkswagen Gol'),
(1, 'GHI-9012', 'Chevrolet Onix');

select * from veiculo;

-- Inserir dados na tabela servico
INSERT INTO servico (clienteIdS, tipoServico, nomeServico) VALUES
(1, 'Manutenção', 'Troca de óleo e filtro'),
(2, 'Revisão', 'Revisão de 30.000 km'),
(3, 'Manutenção', 'Troca de pneus');

-- Inserir dados na tabela mecanico
INSERT INTO mecanico (codigo, nome, endereco, especialidade) VALUES
(101, 'Pedro Alves', 'Rua dos Mecânicos, 50', 'Motor e Transmissão'),
(102, 'Ana Souza', 'Avenida Getúlio Vargas, 1000', 'Suspensão e Freios'),
(103, 'Lucas Costa', 'Travessa da Oficina, 25', 'Elétrica Automotiva');

select * from mecanico;

-- Inserir dados na tabela ordem_servico
INSERT INTO ordem_servico (numero, idMecanico, dataEmissão, valor, ordemStatus, dataConclusao) VALUES
(2023001, 1, '2023-04-05', '250.00', 'Concluída', '2023-04-06'),
(2023002, 2, '2023-04-06', '800.00', 'Em andamento', NULL),
(2023003, 3, '2023-04-07', '120.00', 'Pendente', NULL);

select * from ordem_servico;

-- Inserir dados na tabela manutencao
INSERT INTO manutencao (idServico, valorTotal, pecas) VALUES
(1, 150.00, 'Óleo 5W30, Filtro de óleo'),
(3, 600.00, 'Pneu aro 14 (2 unidades)'),
(1, 180.00, 'Filtro de ar');

-- Inserir dados na tabela revisao
INSERT INTO revisao (idServico, valorTotalRevisao) VALUES
(2, 550.00),
(2, 600.00),
(2, 580.00);

-- Inserir dados na tabela servicos_veiculos
INSERT INTO servicos_veiculos (idServico, idVeiculo) VALUES
(1, 1),
(2, 2),
(3, 3);

-- Inserir dados na tabela servicos_ordensSe
INSERT INTO servicos_ordensSe (idOrdemServico, idServico) VALUES
(4, 1),
(5, 2),
(6, 3);

-- Selecionar apenas o nome e o número de telefone dos mecânicos
SELECT nome, numero FROM cliente;

-- Selecionar os veículos com modelo 'Volkswagen Gol'
SELECT * FROM veiculo WHERE Modelo = 'Volkswagen Gol';

-- Exibir o nome do mecânico e seu código formatado (atributo derivado)
SELECT nome, CONCAT('MEC-', LPAD(codigo, 4, '0')) AS CodigoFormatado
FROM mecanico;

-- Listar as ordens de serviço pela data de emissão, da mais antiga para a mais recente
SELECT * FROM ordem_servico ORDER BY dataEmissão ASC;

-- Calcular o valor médio das ordens de serviço por mecânico, mostrando apenas os mecânicos com média superior a 200
SELECT m.nome AS NomeMecanico, AVG(CAST(os.valor AS DECIMAL(10))) AS MediaValorOS
FROM mecanico m
JOIN ordem_servico os ON m.idMecanico = os.idMecanico
GROUP BY m.nome
HAVING AVG(CAST(os.valor AS DECIMAL(10, 2))) > 200;

-- Listar o nome do cliente, a placa do veículo e o nome do serviço solicitado
SELECT c.Nome AS NomeCliente, v.Placa AS PlacaVeiculo, s.nomeServico AS ServicoSolicitado
FROM cliente c
JOIN veiculo v ON c.idCliente = v.clienteId
JOIN servicos_veiculos sv ON v.idVeiculo = sv.idVeiculo
JOIN servico s ON sv.idServico = s.idServico;