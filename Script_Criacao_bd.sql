
CREATE DATABASE DB_COMERCIO;


USE DB_COMERCIO;

IF OBJECT_ID ('produto') IS NULL 
BEGIN
	CREATE TABLE produto(
		produtoId int IDENTITY(1,1) not null,
		descricao_produto varchar(255) not null,
		situacao_produto char(1)not null default ('A'),
		data_fabricacao datetime,
		data_validade_produto datetime,
		codigo_fornecedor int  null,
		descricao_fornecedor varchar(100) null,
		cnpj_fornecedor varchar(14) null,
		PRIMARY KEY (produtoId),
	)
END
