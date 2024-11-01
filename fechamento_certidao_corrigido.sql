DECLARE @DataInicial as DATE;
DECLARE @DataFinal as DATE
DECLARE @Cartao as BIT;

SET @DataInicial = '2024-05-06'
SET @DataFinal = '2024-05-06'
SET @Cartao = null

SELECT 
        'Certidões' as tipo,
        COALESCE(COUNT(*),0) as Qtd,
        COALESCE(SUM(VlrCertidao) - SUM(FRJ) - SUM(FRC) + SUM(TaxaCartao) - SUM(Valor_Selo),0) as Custas,
        COALESCE(SUM(Valor_Selo),0) as Selo,
        COALESCE(SUM(Distrib),0) as Distrib,
        COALESCE(SUM(VlrCertidao) - SUM(FRJ) - SUM(FRC) + SUM(TaxaCartao) - SUM(Valor_Selo) + SUM(Valor_Selo) + SUM(Distrib),0) as SubTotal,
        COALESCE(SUM(ISS),0) as ISS,
        COALESCE(SUM(FRJ),0) as FRJ,
        COALESCE(SUM(FRC),0) as FRC,
        COALESCE(SUM(TaxaCartao),0) as TaxaBanco,
        COALESCE(SUM(ISS) + SUM(FRJ) + SUM(FRC),0) as Tot_Taxas,
        COALESCE(SUM(VlrCertidao) + SUM(TaxaCartao) + SUM(Distrib) + SUM(ISS),0) as Total,
		@Cartao as Cartao
    FROM (
        -- Subconsulta para 'Certidões'
    select 
	COALESCE(SUM(VlrCertidao), 0) AS VlrCertidao,
	DocCertidao,
    COALESCE(SUM(Valor_Selo), 0) as Valor_Selo,
    COALESCE(SUM(TaxaCartao), 0) as TaxaBanco,
    COALESCE(SUM(FRJ), 0) as FRJ, 
    COALESCE(SUM(FRC), 0) as FRC,
	COALESCE(SUM(Distrib),0) as Distrib,
	COALESCE(SUM(TaxaCartao), 0) AS TaxaCartao,
	Cartao,
	COALESCE(SUM(ISS), 0) AS ISS,
	TipoCertidao
from(
  SELECT 
        DocCertidao,
        COALESCE(SUM(VlrCertidao), 0) AS VlrCertidao,
        COALESCE(SUM(Valor_Selo), 0) AS Valor_Selo,
        COALESCE(SUM(TaxaCartao), 0) AS TaxaCartao,
        COALESCE(SUM(tblFinanceiro.FRJ), 0) AS FRJ,
        COALESCE(SUM(tblFinanceiro.FRC), 0) AS FRC,
		COALESCE(SUM(tblFinanceiro.Valor_Distrib),0) as Distrib,
		COALESCE(MAX(CAST(Cartao AS INT)), (
        SELECT TOP 1 tf2.Cartao
        FROM tblFinanceiro AS tf2
        WHERE 
            tf2.Codigo = tblFinanceiro.Codigo
            AND tf2.Cartao IS NOT NULL
    )) AS Cartao,
        tblFinanceiro.Codigo,
        COALESCE(SUM(ISS), 0) AS ISS,
        CASE
            WHEN EXISTS (
                SELECT 1
                FROM tblFinanceiro AS f2
                WHERE 
                  f2.DocCertidao = tblFinanceiro.DocCertidao
                  AND f2.TipoCertidao = 'POSITIVA'
                  AND COALESCE(f2.VlrCertidao, 0) > 0
            ) THEN 'POSITIVA'
            ELSE 'NEGATIVA'
        END AS TipoCertidao
    FROM 
        tblFinanceiro inner join tblReqCertidao on tblFinanceiro.Codigo = tblReqCertidao.Codigo
    WHERE 
        Data_Certidao BETWEEN @DataInicial AND @DataFinal
        AND VlrCertidao != 0
		and tblReqCertidao.Pago = 1
    GROUP BY 
        DocCertidao,
        tblFinanceiro.Codigo,
		Cartao
) as teste where Cartao = 1
GROUP BY 
        DocCertidao,
        Codigo,
		Cartao,
		TipoCertidao
    ) as consultao