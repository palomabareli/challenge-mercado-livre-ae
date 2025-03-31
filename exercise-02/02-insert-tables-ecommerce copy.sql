USE `ecommerce-challenge-ml`;

-- Inserindo dados nas tabelas do banco de dados `ecommerce`

-- Inserindo dados na tabela `pais`
INSERT INTO `pais` (`nome_pais`) VALUES
('Brasil');

-- Inserindo dados na tabela `sexo`
INSERT INTO `sexo` (`nome_sexo`, `descricao`, `abreviatura_sexo`) VALUES
('Masculino', 'Sexo masculino', 'M'),
('Feminino', 'Sexo feminino', 'F'),
('Outro', 'Outro gênero', 'O'),
('Não informado', 'Prefere não informar', 'N'),
('Indefinido', 'Indefinido', 'I');

-- Inserindo dados na tabela `categoria`
INSERT INTO `categoria` (`nome_categoria`, `categoria_pai`) VALUES
('Eletrônicos', 0),
('Celulares', 1),
('Computadores', 1),
('Eletrodomésticos', 0),
('Móveis', 0),
('Roupas', 0),
('Calçados', 0),
('Livros', 0),
('Esportes', 0),
('Beleza', 0);

-- Inserindo dados na tabela `estado`
INSERT INTO `estado` (`nome_estado`, `id_pais`) VALUES
('São Paulo', 1),
('Rio de Janeiro', 1),
('Minas Gerais', 1),
('Bahia', 1),
('Paraná', 1),
('Santa Catarina', 1),
('Rio Grande do Sul', 1),
('Pernambuco', 1),
('Ceará', 1),
('Distrito Federal', 1);

-- Inserindo dados na tabela `cidade`
INSERT INTO `cidade` (`nome_cidade`, `id_estado`) VALUES
('São Paulo', 1),
('Rio de Janeiro', 2),
('Belo Horizonte', 3),
('Salvador', 4),
('Curitiba', 5),
('Florianópolis', 6),
('Porto Alegre', 7),
('Recife', 8),
('Fortaleza', 9),
('Brasília', 10);

-- Inserindo dados na tabela `pessoa_fisica`
INSERT INTO `pessoa_fisica` (`nome_pessoa_fisica`, `id_sexo`, `dt_nascimento`, `cpf`,`id_tipo_pessoa`) VALUES
('João Silva', 1, '1990-01-01', '12345678901', 1),
('Maria Oliveira', 2, '1985-05-29', '23456789012', 1),
('Carlos Souza', 1, '1992-07-20', '34567890123', 1),
('Ana Santos', 2, '1995-03-10', '45678901234', 1),
('Pedro Lima', 1, '1988-11-25', '56789012345', 1),
('Julia Costa', 2, '1993-09-30', '67890123456', 1),
('Lucas Almeida', 1, '1991-06-18', '78901234567', 1),
('Fernanda Rocha', 2, '1987-12-05', '89012345678', 1),
('Rafael Mendes', 1, '1994-04-22', '90123456789', 1),
('Beatriz Nunes', 2, '1996-05-29', '01234567890', 1);


  `id_pessoa_juridica` bigint NOT NULL AUTO_INCREMENT,
  `nome_pessoa_juridica` varchar(100) NOT NULL,
  `cnpj` varchar(100) NOT NULL,
  `id_tipo_pessoa` bigint NOT NULL,

-- Inserindo dados na tabela `pessoa_fisica`
INSERT INTO `pessoa_juridica` (`nome_pessoa_juridica`, `cnpj`, `id_tipo_pessoa`) VALUES
('Empresa A', '12345678000195', 1),
('Empresa B', '23456789000196', 2),
('Empresa C', '34567890000197', 3),
('Empresa D', '45678901000198', 4),
('Empresa E', '56789012000199', 5),
('Empresa F', '67890123000200', 6),
('Empresa G', '78901234000301', 7),
('Empresa H', '89012345000402', 8),
('Empresa I', '90123456000503', 9),
('Empresa J', '01234567000604', 10);

-- Inserindo dados na tabela `tipo_pessoa`
INSERT INTO `tipo_pessoa` (`nome_tipo_pessoa`, `descricao_tipo_pessoa`, `id_tipo_cliente`) VALUES
('PF', 'Pessoa Física'),
('PJ', 'Pessoa Jurídica');

-- Inserindo dados na tabela `endereco`
INSERT INTO `endereco` (`id_pais`, `cep`, `numero_logradouro`, `complemento`) VALUES
(1, '01001000', 100, 'Apto 1'),
(1, '02002000', 200, NULL),
(1, '03003000', 300, 'Apto 3'),
(1, '04004000', 400, 'Apto 4 - Bloco 12'),
(1, '05005000', 500, NULL),
(1, '06006000', 600, NULL),
(1, '07007000', 700, 'Apto 7'),
(1, '08008000', 800, 'Bloco 1 - ap 2'),
(1, '09009000', 900, NULL),
(1, '10010000', 1000, NULL);

-- Inserindo dados na tabela `cliente`
INSERT INTO `cliente` (`email_cliente`, `apelido_cliente`, `id_endereco`, `ddd`, `telefone`, `id_tipo_pessoa`) VALUES
('joao@email.com', 'joao123', 1, '11', '999999999', 1),
('maria@email.com', 'maria456', 2, '21', '988888888', 1),
('carlos@email.com', 'carlos789', 3, '31', '977777777', 2),
('ana@email.com', 'ana101', 4, '71', '966666666', 2),
('pedro@email.com', 'pedro202', 5, '41', '955555555', 2),
('julia@email.com', 'julia303', 6, '48', '944444444', 1),
('empresa123@email.com', 'empresa123', 7, '51', '933333333', 1),
('empresa456@email.com', 'empresa456', 8, '81', '922222222', 2),
('empresa789@email.com', 'empresa789', 9, '85', '911111111', 2),
('empresa010@email.com', 'empresa010', 10, '61', '900000000', 1);


-- Inserindo dados na tabela `produto`
INSERT INTO `produto` (`nome_produto`, `status_produto`, `id_categoria`) VALUES
('Celular Samsung', 1, 2),
('Notebook Dell', 1, 3),
('Geladeira Brastemp', 1, 4),
('Sofá 3 Lugares', 1, 5),
('Camiseta Nike', 1, 6),
('Tênis Adidas', 0, 7),
('Livro de Ficção', 1, 8),
('Bola de Futebol', 1, 9),
('Perfume Chanel', 0, 10),
('Tablet Apple', 1, 2);

INSERT INTO `produto` (`nome_produto`, `status_produto`, `id_categoria`) VALUES
('Celular Apple', 1, 2);

-- Inserindo dados na tabela `estoque`
INSERT INTO `estoque` (`id_produto`, `preco`, `status`, `data`) VALUES
(1, 1500.00, 1, '2025-03-01'),
(2, 3500.00, 1, '2025-03-02'),
(3, 2500.00, 1, '2025-03-03'),
(4, 1200.00, 1, '2025-03-04'),
(5, 100.00, 1, '2025-03-05'),
(6, 300.00, 1, '2025-03-06'),
(7, 50.00, 1, '2025-03-07'),
(8, 80.00, 1, '2025-03-08'),
(9, 500.00, 1, '2025-03-09'),
(10, 2000.00, 1, '2025-03-10');

-- Inserindo dados na tabela `venda`
-- Registros em janeiro de 2020
INSERT INTO `venda` (`data`, `id_produto`, `qtde_produto`, `id_comprador`, `id_vendedor`) VALUES
('2020-01-01', 1, 1, 1, 2),
('2020-01-02', 2, 2, 2, 3),
('2020-01-03', 3, 1, 3, 4),
('2020-01-04', 4, 1, 4, 5),
('2020-01-05', 5, 3, 5, 6),
('2020-01-06', 6, 1, 6, 7),
('2020-01-07', 7, 2, 7, 8),
('2020-01-08', 8, 1, 8, 9),
('2020-01-09', 9, 1, 9, 10),
('2020-01-10', 10, 1, 10, 1),
('2020-01-11', 1, 1, 2, 3),
('2020-01-12', 2, 1, 3, 4),
('2020-01-13', 3, 1, 4, 5),
('2020-01-14', 4, 1, 5, 6),
('2020-01-15', 5, 1, 6, 7),
('2020-01-16', 6, 1, 7, 8),
('2020-01-17', 7, 1, 8, 9),
('2020-01-18', 8, 1, 9, 10),
('2020-01-19', 9, 1, 10, 1),
('2020-01-20', 10, 1, 1, 2),
('2020-01-21', 1, 1, 2, 3),
('2020-01-22', 2, 1, 3, 4),
('2020-01-23', 3, 1, 4, 5),
('2020-01-24', 4, 1, 5, 6),
('2020-01-25', 5, 1, 6, 7),
('2020-01-26', 6, 1, 7, 8),
('2020-01-27', 7, 1, 8, 9),
('2020-01-28', 8, 1, 9, 10),
('2020-01-29', 9, 1, 10, 1),
('2020-01-30', 10, 1, 1, 2),
('2020-01-01', 1, 10, 1, 2);

-- Registros para outros meses de 2020
INSERT INTO `venda` (`data`, `id_produto`, `qtde_produto`, `id_comprador`, `id_vendedor`) VALUES
('2020-02-15', 1, 11, 4, 2),
('2020-02-15', 1, 11, 4, 2),
('2020-02-20', 1, 11, 4, 2),
('2020-02-21', 1, 11, 4, 2),
('2020-02-28', 1, 11, 3, 3),
('2020-06-15', 1, 11, 3, 3),
('2020-06-15', 1, 11, 3, 3),
('2020-06-20', 1, 11, 3, 3),
('2020-06-21', 1, 11, 3, 3),
('2020-06-28', 1, 11, 3, 3);


-- Registros de outras datas
INSERT INTO `venda` (`data`, `id_produto`, `qtde_produto`, `id_comprador`, `id_vendedor`) VALUES
('2025-03-01', 1, 1, 1, 2),
('2025-03-02', 2, 1, 2, 3),
('2025-03-03', 3, 1, 3, 4),
('2025-03-04', 4, 1, 4, 5),
('2025-03-05', 5, 1, 5, 6),
('2025-03-06', 6, 1, 6, 7),
('2025-03-07', 7, 1, 7, 8),
('2025-03-08', 8, 1, 8, 9),
('2025-03-09', 9, 1, 9, 10),
('2025-03-10', 10, 1, 10, 1),
('2025-03-11', 1, 1, 1, 2),
('2025-03-12', 2, 1, 2, 3),
('2025-03-13', 3, 1, 3, 4),
('2025-03-14', 4, 1, 4, 5),
('2025-03-15', 5, 1, 5, 6),
('2025-03-16', 6, 1, 6, 7),
('2025-03-17', 7, 1, 7, 8),
('2025-03-18', 8, 1, 8, 9),
('2025-03-19', 9, 1, 9, 10),
('2025-03-20', 10, 1, 10, 1),
('2025-03-21', 1, 1, 1, 2),
('2025-03-22', 2, 1, 2, 3),
('2025-03-23', 3, 1, 3, 4),
('2025-03-24', 4, 1, 4, 5),
('2025-03-25', 5, 1, 5, 6),
('2025-03-26', 6, 1, 6, 7),
('2025-03-27', 7, 1, 7, 8),
('2025-03-28', 8, 1, 8, 9),
('2025-03-29', 9, 1, 9, 10),
('2025-03-30', 10, 1, 10, 1),
('2025-03-31', 1, 1, 1, 2),
('2025-04-01', 2, 1, 2, 3),
('2025-04-02', 3, 1, 3, 4),
('2025-04-03', 4, 1, 4, 5),
('2025-04-04', 5, 1, 5, 6),
('2025-04-05', 6, 1, 6, 7),
('2025-04-06', 7, 1, 7, 8),
('2025-04-07', 8, 1, 8, 9),
('2025-04-08', 9, 1, 9, 10),
('2025-04-09', 10, 1, 10, 1),
('2025-04-10', 1, 1, 1, 2),
('2025-04-11', 2, 1, 2, 3),
('2025-04-12', 3, 1, 3, 4),
('2025-04-13', 4, 1, 4, 5),
('2025-04-14', 5, 1, 5, 6),
('2025-04-15', 6, 1, 6, 7),
('2025-04-16', 7, 1, 7, 8),
('2025-04-17', 8, 1, 8, 9),
('2025-04-18', 9, 1, 9, 10),
('2025-04-19', 10, 1, 10, 1),
('2025-04-20', 1, 1, 1, 2),
('2025-04-21', 2, 1, 2, 3),
('2025-04-22', 3, 1, 3, 4),
('2025-04-23', 4, 1, 4, 5),
('2025-04-24', 5, 1, 5, 6),
('2025-04-25', 6, 1, 6, 7),
('2025-04-26', 7, 1, 7, 8),
('2025-04-27', 8, 1, 8, 9),
('2025-04-28', 9, 1, 9, 10),
('2025-04-29', 10, 1, 10, 1),
('2025-04-30', 1, 1, 1, 2),
('2025-05-01', 2, 1, 2, 3),
('2025-05-02', 3, 1, 3, 4),
('2025-05-03', 4, 1, 4, 5),
('2025-05-04', 5, 1, 5, 6),
('2025-05-05', 6, 1, 6, 7),
('2025-05-06', 7, 1, 7, 8),
('2025-05-07', 8, 1, 8, 9),
('2025-05-08', 9, 1, 9, 10),
('2025-05-09', 10, 1, 10, 1);