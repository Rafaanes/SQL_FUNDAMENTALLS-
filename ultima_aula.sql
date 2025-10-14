---[01]Gerando o banco de dados---

USE master;
GO

DROP DATABASE IF EXISTS airBnb;
GO

CREATE DATABASE airBnb;
GO

USE airBnb;
GO

---[02]Tabelas Raw---

DROP TABLE IF EXISTS riodejaneiro_raw;
CREATE TABLE riodejaneiro_raw (
	id INT IDENTITY(1,1) PRIMARY KEY,
	nome NVARCHAR (200) NOT NULL,
	proprietario NVARCHAR (100) NOT NULL,
	bairro NVARCHAR (50) NOT NULL,
	valor INT,
	avaliacoes INT,
	ultima_avaliacao DATE,
	cidade NVARCHAR (50) NOT NULL,
	noites_minimas INT,
	tipo_locacao NVARCHAR (20) NOT NULL	
);

DROP TABLE IF EXISTS newyork_raw;
CREATE TABLE newyork_raw (
	id INT IDENTITY(1,1) PRIMARY KEY,
	nome NVARCHAR (200) NOT NULL,
	proprietario NVARCHAR (100) NOT NULL,
	bairro NVARCHAR (50) NOT NULL,
	valor INT,
	avaliacoes INT,
	ultima_avaliacao DATE,
	cidade NVARCHAR (50) NOT NULL,
	noites_minimas INT,
	tipo_locacao NVARCHAR (20) NOT NULL	
);

INSERT INTO riodejaneiro_raw
(nome, proprietario, bairro, valor, avaliacoes, ultima_avaliacao,cidade,noites_minimas,tipo_locacao)
SELECT
	[name]				AS nome,
	[host_name]			AS proprietario,
	[neighbourhood]		AS bairro,
	TRY_CONVERT (INT, [price])				AS valor,
	TRY_CONVERT (INT, [number_of_reviews]) AS avaliacoes,
	TRY_CONVERT (DATE, [last_review])		AS ultima_avaliacao,
	'Rio de Janeiro',
	TRY_CONVERT (INT, [minimum_nights])	AS noites_minimas,
	[room_type]			AS tipo_locacao
FROM OPENROWSET (
	BULK 'C:\Users\noturno\Desktop\SQL\rj.csv',
	FORMAT = 'CSV',
	PARSER_VERSION = '2.0',
	FIRST ROW = 2
	) WITH (
	[name]				NVARCHAR (200),
	[host_name]			NVARCHAR (100),
	[neighbourhood]		NVARCHAR (50),
	[price]				NVARCHAR (10),
	[number_of_reviews] NVARCHAR (10),
	[last_review]		NVARCHAR (50),
	[minimum_nights]	NVARCHAR (10),
	[room_type]			NVARCHAR (20)
)AS rj;	



INSERT INTO newyork_raw
FROM 'C:\Users\noturno\Desktop\SQL\ny.csv'