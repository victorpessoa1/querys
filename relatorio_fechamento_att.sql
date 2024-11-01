use SISPROT2
DECLARE @Distribuidor Real;

SELECT TOP (1) @Distribuidor = Distribuidor
FROM tblApontamento;
SELECT CASE WHEN tipo IS NULL THEN 'Total' ELSE tipo END as tipo,
       SUM(Qtd) as Qtd,
       SUM(Custas) as TotalCustas,
       SUM(Selo) as TotalSelo,
       SUM(Distrib) as TotalDistrib,
       SUM(SubTotal) as TotalSubTotal,
       SUM(ISS) as TotalISS,
       SUM(FRJ) as TotalFRJ,
       SUM(FRC) as TotalFRC,
       SUM(TaxaBanco) as TotalTaxaBanco,
       SUM(Tot_Taxas) as TotalTot_Taxas,
       SUM(Total) as TotalTotal
FROM (
    SELECT 
        'Certidões' as tipo,
        COUNT(*) as Qtd,
        SUM(VlrCertidao) - SUM(FRJ) - SUM(FRC) + SUM(TaxaCartao) - SUM(Valor_Selo) as Custas,
        SUM(Valor_Selo) as Selo,
        SUM(Distrib) as Distrib,
        SUM(VlrCertidao) - SUM(FRJ) - SUM(FRC) + SUM(TaxaCartao) - SUM(Valor_Selo) + SUM(Valor_Selo) + SUM(Distrib) as SubTotal,
        SUM(ISS) as ISS,
        SUM(FRJ) as FRJ,
        SUM(FRC) as FRC,
        SUM(TaxaCartao) as TaxaBanco,
        SUM(ISS) + SUM(FRJ) + SUM(FRC) as Tot_Taxas,
        SUM(VlrCertidao) + SUM(TaxaCartao) + SUM(Distrib) + SUM(ISS) as Total
    FROM (
        -- Subconsulta para 'Certidões'
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
        tblFinanceiro inner join tblReqCertidao on tblFinanceiro.DocCertidao = tblReqCertidao.Num_Doc
    WHERE 
        Data_Certidao BETWEEN '2024-04-16' AND '2024-04-16'
        --AND Codigo <> 'DIGITAL'
        AND VlrCertidao != 0
		and tblReqCertidao.Pago = 1
    GROUP BY 
        DocCertidao,
        tblFinanceiro.Codigo
    ) as consultao
    UNION ALL
    
    SELECT 
        'Cancelados' as tipo,
        COUNT(*) as Qtd,
        SUM(Custas) - SUM(FRJ) - SUM(FRC) as Custas,
        SUM(tblFinanceiro.Valor_Selo) as Selo,
        SUM(tblFinanceiro.Valor_Distrib) as Distrib,
        SUM(Custas) - SUM(FRJ) - SUM(FRC) + SUM(tblFinanceiro.Valor_Selo) + SUM(tblFinanceiro.Valor_Distrib) AS SubTotal,
        SUM(ISS) as ISS,
        SUM(FRJ) as FRJ,
        SUM(FRC) as FRC,
        SUM(TaxaCartao) as TaxaBanco,
        SUM(ISS) + SUM(FRJ) + SUM(FRC) as Tot_Taxas,
        SUM(Custas) - SUM(FRJ) - SUM(FRC) + SUM(tblFinanceiro.Valor_Selo) + SUM(tblFinanceiro.Valor_Distrib) + SUM(ISS) + SUM(FRJ) + SUM(FRC) + SUM(TaxaCartao) as Total
    FROM 
        tblTitulo 
    INNER JOIN tblFinanceiro ON tblFinanceiro.Protocolo = tblTitulo.Protocolo_Cartorio 
    WHERE 
        tblTitulo.Data_Cancelado BETWEEN '2024-04-16' AND '2024-04-16'
        AND tblTitulo.Tipo_Ocorrencia = 'A'
        AND tblTitulo.Anulado = '0'
        AND tblTitulo.CancelaBanco = '0'
        AND tblFinanceiro.Data_Cancelado BETWEEN '2024-04-16' AND '2024-04-16'
        AND tblFinanceiro.Custas != 0
    
    UNION ALL
    
    SELECT 
        'Custas Prot' as tipo,
        COUNT(*) as Qtd,
        SUM(Custas) - SUM(FRJ) - SUM(FRC) + ((ROUND((@Distribuidor*0.025),2)+ROUND((@Distribuidor*0.15),2)) * COUNT(*))  as Custas,
        SUM(f.Valor_Selo) as Selo,
        SUM(f.Valor_Distrib) - ((ROUND((@Distribuidor*0.025),2)+ROUND((@Distribuidor*0.15),2)) * COUNT(*)) as Distrib,
        SUM(Custas) - SUM(FRJ) - SUM(FRC) + SUM(f.Valor_Selo) + SUM(f.Valor_Distrib) as SubTotal,
        SUM(ISS) as ISS,
        SUM(FRJ) as FRJ,
        SUM(FRC) as FRC,
        SUM(TaxaCartao) as TaxaBanco,
        SUM(ISS) + SUM(FRJ) + SUM(FRC) as Tot_Taxas,
        SUM(Custas) + SUM(ISS) + SUM(TaxaCartao) + SUM(f.Valor_Selo) + SUM(f.Valor_Distrib) as Total
    FROM 
        tblTitulo t
    INNER JOIN tblFinanceiro f ON t.Protocolo_Cartorio = f.Protocolo
    WHERE 
        t.Data_Pagamento BETWEEN '2024-04-16' AND '2024-04-16'
        AND t.CustasProtesto = '1'
        AND t.Anulado = '0'
        AND t.Aguardando = '0'
        AND t.CancelaBanco = '0'
        AND f.Data_Pagamento BETWEEN '2024-04-16' AND '2024-04-16'
        AND f.Baixa_Lote IS NULL
        AND f.Custas != 0

	UNION ALL
	--pagamentos
	Select 
		'Custas Pag' as tipo,
		COUNT(*) as Qtd,
		SUM(Custas) - SUM(FRJ) - SUM(FRC) + ((ROUND((@Distribuidor*0.025),2)+ROUND((@Distribuidor*0.15),2)) * COUNT(*)) as Custas,
		SUM(tblFinanceiro.Valor_Selo) as Selo,
		SUM(tblFinanceiro.Valor_Distrib) - ((ROUND((@Distribuidor*0.025),2)+ROUND((@Distribuidor*0.15),2)) * COUNT(*)) as Distrib,
		SUM(Custas) - SUM(FRJ) - SUM(FRC) + ((ROUND((@Distribuidor*0.025),2)+ROUND((@Distribuidor*0.15),2)) * COUNT(*)) + SUM(tblFinanceiro.Valor_Selo) + SUM(tblFinanceiro.Valor_Distrib) - ((ROUND((@Distribuidor*0.025),2)+ROUND((@Distribuidor*0.15),2)) * COUNT(*)) as SubTotal,
		SUM(ISS) AS ISS,
		SUM(FRJ) as FRJ,
		SUM(FRC) as FRC,
		SUM(tblFinanceiro.TED) AS TaxaBanco,
		SUM(ISS) +  SUM(FRJ) + SUM(FRC) as Tot_Taxas,
		(SUM(Custas) + ((ROUND((@Distribuidor*0.025),2)+ROUND((@Distribuidor*0.15),2)) * COUNT(*))) + SUM(ISS) + SUM(tblFinanceiro.Valor_Selo) + SUM(tblFinanceiro.Valor_Distrib) - ((ROUND((@Distribuidor*0.025),2)+ROUND((@Distribuidor*0.15),2)) * COUNT(*)) + SUM(TED) as Total
	From
		tblTitulo
	INNER JOIN tblFinanceiro ON tblFinanceiro.Protocolo = tblTitulo.Protocolo_Cartorio 
	WHERE
		(tblFinanceiro.Estorno is null or
		tblFinanceiro.Estorno = 0) and
		tblFinanceiro.Data_Pagamento
		BETWEEN 
			'2024-04-16' AND '2024-04-16' 
		AND CustasProtesto Is Null
		AND Baixado='1' 
		AND Anulado='0'
		AND Aguardando='0'
		AND tblTitulo.CancelaBanco='0'
		--and tblFinanceiro.Protocolo = '1811075'
) as combined_data
GROUP BY tipo
WITH ROLLUP;