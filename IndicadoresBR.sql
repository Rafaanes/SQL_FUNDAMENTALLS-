--[01] Banco de dados Novo--

USE master;
GO

DROP DATABASE IF EXISTS IndicadoresBR;
GO

CREATE DATABASE IndicadoresBR;
GO

USE IndicadoresBR;
GO

/*           [02]Tabelas Raw (texo)
Motivo: Evitar dor de cabeça com virgula vs ponto*/

DROP TABLE IF EXISTS Inadimplencia_raw;
CREATE TABLE Inadimplencia_raw (
	data_str VARCHAR (20), --"dd/mm/aaaa"--
	valor_str VARCHAR (50) -- numero como texto--
	);

DROP TABLE IF EXISTS Selic_raw;
CREATE TABLE Selic_raw (
	data_str VARCHAR (20),
	valor_str VARCHAR (50)
	);

/*[03]Importar CSVs (Bulk Insert)*/

BULK INSERT Inadimplencia_raw
FROM 'C:\Users\noturno\Desktop\SQL\inadimplencia.csv'
WITH (
	FIRSTROW = 2, -- cabeçalho na primeira linha--
	FIELDTERMINATOR = ';', -- separador--
	ROWTERMINATOR = '0x0d0a', --\r\n (terminador do windows)
	CODEPAGE = '65001', --utf-8 (permite caracteres especiais)--
	TABLOCK --impede a concorrencia dessa tabela enquanto importa (nao editavel até finalizar a atualização)--
	);

BULK INSERT Selic_raw
FROM 'C:\Users\noturno\Desktop\SQL\taxa_selic.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ';',
	ROWTERMINATOR = '0x0d0a',
	CODEPAGE = '65001',
	TABLOCK 
	);

--Conferencia rapida se os dados forma importados--

SELECT TOP (5) * FROM Inadimplencia_raw;
SELECT TOP (5) * FROM Selic_raw;

---[04]Tabelas finais (tipadas)---

DROP TABLE IF EXISTS Inadimplencia;
SELECT
	TRY_CONVERT (date, data_str, 103) AS Data,
	TRY_CONVERT (decimal (18,4), REPLACE (valor_str, ',','.')) AS Valor
INTO Inadimplencia
FROM Inadimplencia_raw;

DROP TABLE IF EXISTS Selic;
SELECT
	TRY_CONVERT (date, data_str, 103) AS Data,
	TRY_CONVERT (decimal (18,4), REPLACE (valor_str, ',','.')) AS Valor
INTO Selic
FROM Selic_raw;

---[05] Selic mensal - Media do mês e ultimo valor do mes---
--ultimo valor do mes--

DROP TABLE IF EXISTS Selic_mensal_ultimo;
;WITH s AS (
	SELECT
		data,
		EOMONTH(data) AS mes,
		valor,
		ROW_NUMBER () OVER (PARTITION BY EOMONTH(data) ORDER BY data DESC
		) AS rn
	FROM Selic
)
SELECT 
	mes AS data,
	valor
INTO Selic_mensal_ultimo
FROM s
WHERE rn = 1;

--visualizar os dados de amostra da Selic_mensal_ultimo--

SELECT TOP (10) * FROM Selic_mensal_ultimo ORDER BY data;

--Selic media de cada mes--

DROP TABLE IF EXISTS Selic_mensal_media;
SELECT
	EOMONTH(data) AS data,
	AVG (valor) AS valor
INTO Selic_mensal_media
FROM Selic
GROUP BY EOMONTH(data);

--visualizar os dados de amostra da Selic_mensal_media--

SELECT TOP (10) * FROM Selic_mensal_media;

--[06] ultimos 12 meses de inadimplencia--

SELECT TOP (12) * FROM Inadimplencia
ORDER BY data DESC;

--[07] variaçaõ mes a mes da inadimplencia(MoM)--

;WITH b AS (
	SELECT 
		data,
		valor,
		LAG(valor) OVER (ORDER BY data) AS prev_valor
	FROM Inadimplencia
	)
SELECT
	data,
	valor,
	CASE
		WHEN prev_valor IS NULL OR prev_valor=0 THEN NULL
		ELSE (valor-prev_valor)/prev_valor
	END AS variacao_mm
FROM b;

--[08] Inadimplencia x Selic (média) nos ultimos 24 meses--

--SET LANGUAGE Portuguese (Garante que os nomes dos meses saiam em portugues)--
SELECT TOP (24)
	--i.data--
	DATENAME(MONTH, i.data) AS 'Mes por extenso',
	i.valor AS Inadimplencia,
	s.valor AS Selic
FROM Inadimplencia i
LEFT JOIN Selic_mensal_media s ON s.data=EOMONTH(i.data)

ORDER BY i.data DESC;


	


