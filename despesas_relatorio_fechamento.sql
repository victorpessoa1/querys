SELECT 
    Descricao,
    Conta,
    Valor AS tot_despesas,
	TipoDoc,
CAST(0 AS BIT) AS Cartao
FROM cpHistorico
where DataLiquidacao between '2024-08-01' and '2024-08-05' and TipoDoc <> 'DINHEIRO' and CD = 'D' and Banco = 'Conta Receita';

SELECT 
    Descricao,
    Conta,
    Valor AS tot_despesas,
	TipoDoc,
CAST(0 AS BIT) AS Cartao
FROM cpHistorico
where DataLiquidacao between '2024-08-01' and '2024-08-05' and TipoDoc = 'DINHEIRO' and CD = 'D' and Banco = 'Conta Receita';
