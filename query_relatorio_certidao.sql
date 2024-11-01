use SISPROT

  SELECT 
        DocCertidao,
        COALESCE(SUM(VlrCertidao), 0) AS VlrCertidao,
        COALESCE(SUM(Valor_Selo), 0) AS Valor_Selo,
        COALESCE(SUM(TaxaCartao), 0) AS TaxaCartao,
        COALESCE(SUM(tblFinanceiro.FRJ), 0) AS FRJ,
        COALESCE(SUM(tblFinanceiro.FRC), 0) AS FRC,
		COALESCE(SUM(tblFinanceiro.Valor_Distrib),0) as Distrib,
        MAX(CAST(COALESCE(Cartao, 0) AS INT)) AS Cartao,
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
        Data_Certidao BETWEEN '2024-04-30' AND '2024-04-30'
        --AND Codigo <> 'DIGITAL'
        AND VlrCertidao != 0
		and tblReqCertidao.Pago = 1
    GROUP BY 
        DocCertidao,
        tblFinanceiro.Codigo

--select * from tblFinanceiro where Data_Certidao BETWEEN '2024-04-19' AND '2024-04-19' and DocCertidao = '78809118200';

--select * from tblReqCertidao where Num_Doc = '78809118200';
