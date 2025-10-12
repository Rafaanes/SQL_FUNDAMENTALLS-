USE master;
GO

DROP DATABASE IF EXISTS Murder_rate_2015;
CREATE DATABASE Murder_rate_2015;
GO

USE Murder_rate_2015;
GO


DROP TABLE IF EXISTS Murder2015_raw;
CREATE TABLE Murder2015_raw (
	city NVARCHAR (50),
	state NVARCHAR (50),
	murders_2014 INT,
	murders_2015 INT,
	change INT
	);


BULK INSERT Murder2015_raw
FROM 'C:\Users\Rafaa\Downloads\murder_2015_final.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '0x0a',
	CODEPAGE = '65001', 
	TABLOCK
	);


SELECT TOP (5) 
	city,
	state,
	change
	FROM Murder2015_raw
ORDER BY change DESC;

SELECT TOP (10)
	name,
	city,
	state,
	urate
	FROM police_killings
ORDER BY urate DESC;

SELECT * FROM Murder2015_raw
	WHERE murders_2015 < 50;

SELECT
	name,
	age
	FROM police_killings
WHERE age BETWEEN 20 AND 30 AND armed='Firearm';

SELECT
	name,
	city
	FROM police_killings
WHERE lawenforcementagency LIKE '%Sheriff%';

SELECT 
	raceethnicity,
	COUNT (raceethnicity) AS Total
	FROM police_killings
GROUP BY raceethnicity
ORDER BY Total DESC;

SELECT
	cause,
	AVG (age) AS Media_age
	FROM police_killings
GROUP BY cause
ORDER BY Media_age DESC;

SELECT
	state,
	COUNT (murders_2014) AS Total_2014,
	COUNT (murders_2015) AS Total_2015
FROM Murder2015_raw
GROUP BY state;

SELECT
	raceethnicity,
	COUNT (name) AS Total
	FROM police_killings
GROUP BY raceethnicity
HAVING COUNT (name) > 10
ORDER BY Total DESC;

SELECT
CASE
	WHEN p_income <=18000 THEN 'Baixa'
	WHEN p_income >=30000 THEN 'Alta'
	ELSE 'Media'
END AS Situacao_renda,
COUNT (*) AS 'Quantidade'
FROM police_killings
GROUP BY
	CASE
	WHEN p_income <=18000 THEN 'Baixa'
	WHEN p_income >=30000 THEN 'Alta'
	ELSE 'Media'
END
ORDER BY 'Quantidade' DESC;

SELECT
	name AS nome,
	raceethnicity AS raça,
CASE
	WHEN armed LIKE '%Firearm%' THEN 'Arma de fogo/Faca'
	WHEN armed LIKE '%Knife%' THEN 'Arma de fogo/Faca'	
	ELSE 'Outros/Não armado'
END AS Armamento	
	FROM police_killings;

SELECT
	city,
	state,
	murders_2015,
	RANK () OVER (ORDER BY murders_2015 DESC) AS Ranking
	FROM Murder2015_raw;

SELECT *
FROM police_killings
	WHERE h_income > (
		SELECT AVG (h_income)
		FROM police_killings
		);



	







	





