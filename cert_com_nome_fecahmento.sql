SELECT 
        --'Certidões' as tipo,
        --COUNT(*) as Qtd,
        VlrCertidao - FRJ - FRC + TaxaCartao - Valor_Selo as Custas,
        Valor_Selo as Selo,
        Distrib as Distrib,
        VlrCertidao - FRJ - FRC + TaxaCartao - Valor_Selo + Valor_Selo + Distrib as SubTotal,
        ISS as ISS,
        FRJ as FRJ,
        FRC as FRC,
        TaxaCartao as TaxaBanco,
        ISS + FRJ + FRC as Tot_Taxas,
        VlrCertidao + TaxaCartao + Distrib + ISS as Total
    FROM (
        -- Subconsulta para 'Certidões'
 SELECT 
        NomeCertidao,
        DocCertidao,
        COALESCE(SUM(VlrCertidao), 0) AS VlrCertidao,
        COALESCE(SUM(Valor_Selo), 0) AS Valor_Selo,
        COALESCE(SUM(TaxaCartao), 0) AS TaxaCartao,
        COALESCE(SUM(FRJ), 0) AS FRJ,
        COALESCE(SUM(FRC), 0) AS FRC,
		COALESCE(SUM(tblFinanceiro.Valor_Distrib),0) as Distrib,
        MAX(CAST(COALESCE(Cartao, 0) AS INT)) AS Cartao,
        Codigo,
        COALESCE(SUM(ISS), 0) AS ISS,
        CASE
            WHEN EXISTS (
                SELECT 1
                FROM tblFinanceiro AS f2
                WHERE f2.NomeCertidao = tblFinanceiro.NomeCertidao
                  AND f2.DocCertidao = tblFinanceiro.DocCertidao
                  AND f2.TipoCertidao = 'POSITIVA'
                  AND COALESCE(f2.VlrCertidao, 0) > 0
            ) THEN 'POSITIVA'
            ELSE 'NEGATIVA'
        END AS TipoCertidao
    FROM 
        tblFinanceiro
    WHERE 
        Data_Certidao BETWEEN '2024-04-16' AND '2024-04-16'
        AND Codigo <> 'DIGITAL'
        AND VlrCertidao != 0
    GROUP BY 
        NomeCertidao,
        DocCertidao,
        Codigo
    ) as consultao