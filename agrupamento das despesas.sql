USE SISPROT2
--select Conta,sum(Valor) as tot_despesas,TipoDoc from cpHistorico where DataLiquidacao between '2024-02-19' and '2024-02-19' and TipoDoc<>'DINHEIRO'   group by Conta,TipoDoc
--where DataLiquidacao between '' and ''

--select Conta,sum(Valor) as tot_despesas from cpHistorico where DataLiquidacao between '2024-03-01' and '2024-04-22'  group by Conta

SELECT 
    Conta,
    SUM(Valor) AS tot_despesas,
	TipoDoc,
    CAST(CASE 
            WHEN TipoDoc <> 'DINHEIRO' THEN 1
            ELSE 0
     END AS BIT) AS Cartao
FROM cpHistorico
where DataLiquidacao between '2024-02-19' and '2024-02-19' group by Conta,TipoDoc;


SELECT 
	sum(tot_despesas) as totdespesasGeral,
	Cartao
FROM(
	SELECT 
	Conta,
	SUM(Valor) AS tot_despesas,
	TipoDoc,
	CAST(CASE 
			WHEN TipoDoc <> 'DINHEIRO' THEN 1
			ELSE 0
		END AS BIT) AS Cartao
	FROM cpHistorico
	where DataLiquidacao between '2024-02-19' and '2024-02-19' group by Conta,TipoDoc
) as subconsulta group by Cartao


	SELECT 
		SUM(Valor) AS tot_despesas
	FROM SISPROT2.dbo.cpHistorico
	where DataLiquidacao between '2024-02-19' and '2024-02-19'

	--cartao
	SELECT 
		SUM(Valor) AS tot_despesas
	FROM SISPROT2.dbo.cpHistorico
	where DataLiquidacao between '2024-02-19' and '2024-02-19' and TipoDoc <> 'DINHEIRO'

	--dinheiro
	SELECT 
		SUM(Valor) AS tot_despesas
	FROM SISPROT2.dbo.cpHistorico
	where DataLiquidacao between '2024-02-19' and '2024-02-19' and TipoDoc = 'DINHEIRO'

