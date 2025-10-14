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
	nome NVARCHAR (200),
	proprietario NVARCHAR (100),
	bairro NVARCHAR (50),
	valor INT,
	avaliacoes INT,
	ultima_avaliacao DATE,
	cidade NVARCHAR (50),
	noites_minimas INT,
	tipo_locacao NVARCHAR (20)	
);

IF OBJECT_ID ('dbo.rj_stage') IS NOT NULL
DROP TABLE dbo.rj_stage;
CREATE TABLE dbo.rj_stage (
	[name]				NVARCHAR (200) NULL,
	[host_name]			NVARCHAR (100) NULL,
	[neighbourhood]		NVARCHAR (50) NULL,
	[price]				NVARCHAR (10) NULL,
	[number_of_reviews] NVARCHAR (10) NULL,
	[last_review]		NVARCHAR (50) NULL,
	[minimum_nights]	NVARCHAR (10) NULL,
	[room_type]			NVARCHAR (20) NULL
);

BULK INSERT dbo.rj_stage
FROM 'C:\Users\noturno\Desktop\SQL\rj.csv'
WITH (
	FIRSTROW =2,
	FIELDQUOTE = '"',
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '0x0a',
	CODEPAGE = '65001',
	TABLOCK,
	MAXERRORS = 0
);

INSERT INTO riodejaneiro_raw
(nome, proprietario, bairro, valor, avaliacoes, ultima_avaliacao,cidade,noites_minimas,tipo_locacao)
SELECT
	s.[name],	
	s.[host_name],	
	s.[neighbourhood],
	TRY_CONVERT (INT, s.[price]),		
	TRY_CONVERT (INT, s.[number_of_reviews]),
	TRY_CONVERT (DATE, s.[last_review], 103),
	N'Rio de Janeiro',
	TRY_CONVERT (INT, s.[minimum_nights]),
	s.[room_type]
FROM dbo.rj_stage AS s;

