USE airBnb;
GO

SELECT * FROM base

SELECT 
	COUNT(*) AS n_linhas,
	AVG (TRY_CONVERT (FLOAT,TV)) AS [Média TV],
	MIN (TRY_CONVERT (FLOAT,TV)) AS [Minimo TV],
	MAX (TRY_CONVERT (FLOAT,TV)) AS [Maximo TV]
FROM base;
GO

WITH conv AS (
	SELECT
		TRY_CONVERT(FLOAT, tv) AS tv_f,
		TRY_CONVERT(FLOAT, vendas) AS vendas_f
	FROM base
)
SELECT
	CASE
		WHEN tv_f < 50 THEN 'Baixo investimento'
		WHEN tv_f BETWEEN 50 AND 150 THEN 'Médio investimento'
		ELSE 'Alto investimento'
END AS [Faixa TV],
	AVG (vendas_f) AS [Média de Vendas]
FROM conv
GROUP BY 
	CASE
		WHEN tv_f < 50 THEN 'Baixo investimento'
		WHEN tv_f BETWEEN 50 AND 150 THEN 'Médio investimento'
		ELSE 'Alto investimento'
END;
GO

SELECT TOP (10)
	tv, radio, jornal, vendas,
	ROUND(
		TRY_CONVERT (FLOAT, vendas)
		/ NULLIF (
			TRY_CONVERT (FLOAT, tv)
			+TRY_CONVERT (FLOAT, jornal)
			+TRY_CONVERT (FLOAT, radio),
			0),
			3) AS [Eficiencia]
FROM base
ORDER BY [Eficiencia] DESC;

--Total de investimentos por canal e proporçao geral no total--

SELECT
	SUM (TRY_CONVERT (FLOAT, tv)) AS [Total TV],
	SUM (TRY_CONVERT (FLOAT, radio)) AS [Total Radio],
	SUM (TRY_CONVERT (FLOAT, jornal)) AS [Total Jornal],
	ROUND (--Percentual da TV--
		100.0 * SUM (TRY_CONVERT (FLOAT, tv)) /
		NULLIF(SUM(
			TRY_CONVERT (FLOAT, tv)+
			TRY_CONVERT (FLOAT, radio)+
			TRY_CONVERT (FLOAT, jornal)
			),0 
		), 2
	) AS [Percentual TV],

	ROUND (--Percentual do Radio--
		100.0 * SUM (TRY_CONVERT (FLOAT, radio)) /
		NULLIF(SUM(
			TRY_CONVERT (FLOAT, tv)+
			TRY_CONVERT (FLOAT, radio)+
			TRY_CONVERT (FLOAT, jornal)
			),0 
		), 2
	) AS [Percentual Radio],

	ROUND (--Percentual do Jornal--
		100.0 * SUM (TRY_CONVERT (FLOAT, jornal)) /
		NULLIF(SUM(
			TRY_CONVERT (FLOAT, tv)+
			TRY_CONVERT (FLOAT, radio)+
			TRY_CONVERT (FLOAT, jornal)
			),0 
		), 2
	) AS [Percentual Jornal]

FROM base;
GO

---Dados do ROI (Return of Investiments)--- 

SELECT 
	--ROI TV--
		ROUND (
			SUM(TRY_CONVERT(FLOAT,vendas))
			/
			NULLIF(SUM(
			TRY_CONVERT (FLOAT, tv)
			),0
		),3) AS [ROI TV],
	--ROI RADIO--
		ROUND (
			SUM(TRY_CONVERT(FLOAT,vendas))
			/
			NULLIF(SUM(
			TRY_CONVERT (FLOAT, radio)
			),0
		),3) AS [ROI Radio],
	--ROI JORNAL--
		ROUND (
			SUM(TRY_CONVERT(FLOAT, vendas))
			/
			NULLIF(SUM(
			TRY_CONVERT (FLOAT, jornal)
			),0
		),3) AS [ROI Jornal]
FROM base;
GO

