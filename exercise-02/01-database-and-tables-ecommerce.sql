-- Criação do banco de dados
CREATE DATABASE `ecommerce-challenge-ml` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `ecommerce-challenge-ml`;

-- 1. Tabelas sem dependências
CREATE TABLE `pais` (
  `id_pais` bigint NOT NULL AUTO_INCREMENT,
  `nome_pais` varchar(100) NOT NULL,
  PRIMARY KEY (`id_pais`),
  UNIQUE KEY `pais_unique` (`nome_pais`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `sexo` (
  `id_sexo` bigint NOT NULL AUTO_INCREMENT,
  `nome_sexo` varchar(100) NOT NULL,
  `descricao` varchar(100) DEFAULT NULL,
  `abreviatura_sexo` char(1) NOT NULL,
  PRIMARY KEY (`id_sexo`),
  UNIQUE KEY `sexo_unique` (`nome_sexo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `categoria` (
  `id_categoria` bigint NOT NULL AUTO_INCREMENT,
  `nome_categoria` varchar(100) NOT NULL,
  `categoria_pai` bigint NOT NULL,
  PRIMARY KEY (`id_categoria`),
  UNIQUE KEY `categoria_unique` (`nome_categoria`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- 2. Tabelas que dependem de `pais`
CREATE TABLE `estado` (
  `id_estado` bigint NOT NULL AUTO_INCREMENT,
  `nome_estado` varchar(100) NOT NULL,
  `id_pais` bigint NOT NULL,
  PRIMARY KEY (`id_estado`),
  UNIQUE KEY `estado_unique` (`nome_estado`),
  KEY `estado_pais_FK` (`id_pais`),
  CONSTRAINT `estado_pais_FK` FOREIGN KEY (`id_pais`) REFERENCES `pais` (`id_pais`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `cidade` (
  `id_cidade` bigint NOT NULL AUTO_INCREMENT,
  `nome_cidade` varchar(100) NOT NULL,
  `id_estado` bigint NOT NULL,
  PRIMARY KEY (`id_cidade`),
  UNIQUE KEY `cidade_unique` (`nome_cidade`),
  KEY `cidade_estado_FK` (`id_estado`),
  CONSTRAINT `cidade_estado_FK` FOREIGN KEY (`id_estado`) REFERENCES `estado` (`id_estado`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- 3. Tabelas que dependem de `sexo`
CREATE TABLE `pessoa_fisica` (
  `id_pessoa_fisica` bigint NOT NULL AUTO_INCREMENT,
  `nome_pessoa_fisica` varchar(100) NOT NULL,
  `id_sexo` bigint NOT NULL,
  `dt_nascimento` date NOT NULL,
  `cpf` varchar(11) NOT NULL,
  `id_cliente_tipo_pessoa` bigint NOT NULL,
  PRIMARY KEY (`id_pessoa_fisica`),
  UNIQUE KEY `pessoa_fisica_unique` (`cpf`),
  KEY `pessoa_fisica_sexo_FK` (`id_sexo`),
  KEY `pessoa_fisica_cliente_tipo_pessoa_FK_1` (`id_cliente_tipo_pessoa`),
  CONSTRAINT `pessoa_fisica_cliente_tipo_pessoa_FK` FOREIGN KEY (`id_cliente_tipo_pessoa`) REFERENCES `cliente_tipo_pessoa` (`id_cliente_tipo_pessoa`),
  CONSTRAINT `pessoa_fisica_sexo_FK` FOREIGN KEY (`id_sexo`) REFERENCES `sexo` (`id_sexo`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- 4. Tabelas que dependem de `pessoa_fisica`
CREATE TABLE `tipo_pessoa` (
  `id_tipo_pessoa` bigint NOT NULL AUTO_INCREMENT,
  `nome_tipo_pessoa` char(2) NOT NULL,
  `descricao_tipo_pessoa` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id_tipo_pessoa`),
  UNIQUE KEY `tipo_pessoa_unique` (`nome_tipo_pessoa`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- 5. Tabelas que dependem de `pessoa_juridicas`
CREATE TABLE `pessoa_juridica` (
  `id_pessoa_juridica` bigint NOT NULL AUTO_INCREMENT,
  `nome_pessoa_juridica` varchar(100) NOT NULL,
  `cnpj` varchar(100) NOT NULL,
  `id_cliente_tipo_pessoa` bigint NOT NULL,
  PRIMARY KEY (`id_pessoa_juridica`),
  UNIQUE KEY `pessoa_juridica_unique` (`nome_pessoa_juridica`),
  UNIQUE KEY `pessoa_juridica_unique_1` (`cnpj`),
  KEY `pessoa_juridica_cliente_tipo_pessoa_FK` (`id_cliente_tipo_pessoa`),
  CONSTRAINT `pessoa_juridica_cliente_tipo_pessoa_FK` FOREIGN KEY (`id_cliente_tipo_pessoa`) REFERENCES `cliente_tipo_pessoa` (`id_cliente_tipo_pessoa`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- 5. Tabelas que dependem de `tipo_pessoa` e `cidade`
CREATE TABLE `tipo_pessoa` (
  `id_tipo_pessoa` bigint NOT NULL AUTO_INCREMENT,
  `nome_tipo_pessoa` char(2) NOT NULL,
  `descricao_tipo_pessoa` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id_tipo_pessoa`),
  UNIQUE KEY `tipo_pessoa_unique` (`nome_tipo_pessoa`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `cliente_tipo_pessoa` (
  `id_cliente_tipo_pessoa` bigint NOT NULL AUTO_INCREMENT,
  `id_cliente` bigint NOT NULL,
  `id_tipo_pessoa` bigint NOT NULL,
  PRIMARY KEY (`id_cliente_tipo_pessoa`),
  KEY `cliente_tipo_pessoa_cliente_FK` (`id_cliente`),
  KEY `cliente_tipo_pessoa_tipo_pessoa_FK` (`id_tipo_pessoa`),
  CONSTRAINT `cliente_tipo_pessoa_tipo_pessoa_FK` FOREIGN KEY (`id_tipo_pessoa`) REFERENCES `tipo_pessoa` (`id_tipo_pessoa`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `endereco` (
  `id_endereco` bigint NOT NULL AUTO_INCREMENT,
  `id_pais` bigint NOT NULL,
  `cep` char(8) NOT NULL,
  `numero_logradouro` bigint NOT NULL,
  `complemento` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id_endereco`),
  KEY `endereco_pais_FK` (`id_pais`),
  CONSTRAINT `endereco_pais_FK` FOREIGN KEY (`id_pais`) REFERENCES `pais` (`id_pais`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- 6. Tabelas que dependem de `categoria`
CREATE TABLE `produto` (
  `id_produto` bigint NOT NULL AUTO_INCREMENT,
  `nome_produto` varchar(100) NOT NULL,
  `status_produto` tinyint(1) NOT NULL DEFAULT '0',
  `id_categoria` bigint NOT NULL,
  PRIMARY KEY (`id_produto`),
  UNIQUE KEY `produto_unique` (`nome_produto`),
  KEY `produto_categoria_FK` (`id_categoria`),
  CONSTRAINT `produto_categoria_FK` FOREIGN KEY (`id_categoria`) REFERENCES `categoria` (`id_categoria`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- 7. Tabelas que dependem de `produto`
CREATE TABLE `estoque` (
  `id_produto` bigint NOT NULL,
  `preco` double NOT NULL,
  `id_estoque` bigint NOT NULL AUTO_INCREMENT,
  `status` tinyint(1) NOT NULL DEFAULT '0',
  `data` date NOT NULL,
  PRIMARY KEY (`id_estoque`),
  KEY `estoque_produto_FK` (`id_produto`),
  CONSTRAINT `estoque_produto_FK` FOREIGN KEY (`id_produto`) REFERENCES `produto` (`id_produto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- 8. Tabelas que dependem de `cliente` e `produto`
CREATE TABLE `cliente` (
  `id_cliente` bigint NOT NULL AUTO_INCREMENT,
  `email_cliente` varchar(100) NOT NULL,
  `apelido_cliente` varchar(100) NOT NULL,
  `id_endereco` bigint NOT NULL,
  `ddd` varchar(3) NOT NULL,
  `telefone` varchar(100) NOT NULL,
  `id_cliente_tipo_pessoa` bigint NOT NULL,
  PRIMARY KEY (`id_cliente`),
  UNIQUE KEY `cliente_unique_1` (`email_cliente`),
  UNIQUE KEY `cliente_unique_2` (`apelido_cliente`),
  KEY `cliente_endereco_FK` (`id_endereco`),
  KEY `cliente_cliente_tipo_pessoa_FK` (`id_cliente_tipo_pessoa`),
  CONSTRAINT `cliente_cliente_tipo_pessoa_FK` FOREIGN KEY (`id_cliente_tipo_pessoa`) REFERENCES `cliente_tipo_pessoa` (`id_cliente_tipo_pessoa`),
  CONSTRAINT `cliente_endereco_FK` FOREIGN KEY (`id_endereco`) REFERENCES `endereco` (`id_endereco`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `venda` (
  `id_venda` bigint NOT NULL AUTO_INCREMENT,
  `data` date NOT NULL,
  `id_produto` bigint NOT NULL,
  `qtde_produto` bigint NOT NULL,
  `id_comprador` bigint NOT NULL,
  `id_vendedor` bigint NOT NULL,
  UNIQUE KEY `venda_unique` (`id_venda`),
  KEY `venda_produto_FK` (`id_produto`),
  KEY `venda_cliente_FK` (`id_comprador`),
  KEY `venda_cliente_FK_1` (`id_vendedor`),
  CONSTRAINT `venda_cliente_FK` FOREIGN KEY (`id_comprador`) REFERENCES `cliente` (`id_cliente`),
  CONSTRAINT `venda_cliente_FK_1` FOREIGN KEY (`id_vendedor`) REFERENCES `cliente` (`id_cliente`),
  CONSTRAINT `venda_produto_FK` FOREIGN KEY (`id_produto`) REFERENCES `produto` (`id_produto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

C
CREATE TABLE `historico_produto` (
  `id_historico_produto` bigint NOT NULL AUTO_INCREMENT,
  `id_produto` bigint NOT NULL,
  `status` tinyint(1) NOT NULL,
  `data` date NOT NULL,
  `preco` double NULL,
  `id_categoria` bigint NOT NULL,
  PRIMARY KEY (`id_historico_produto`),
  KEY `historico_produto_produto_FK` (`id_produto`),
  KEY `historico_produto_categoria_FK` (`id_categoria`),
  CONSTRAINT `historico_produto_categoria_FK` FOREIGN KEY (`id_categoria`) REFERENCES `categoria` (`id_categoria`),
  CONSTRAINT `historico_produto_produto_FK` FOREIGN KEY (`id_produto`) REFERENCES `produto` (`id_produto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;