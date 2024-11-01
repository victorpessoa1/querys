USE SISPROT
SELECT 
	tipo,
	Custas,
	Selo,
	Distrib,
	Custas + Selo + Distrib as SubTotal,
	ISS,
	FRJ,
	FRC,
	TaxaBanco,
	ISS + FRC + FRJ as Tot_Taxas,
	Custas + Selo + Distrib + ISS + FRC + FRJ + TaxaBanco as Total
FROM(
	SELECT
		sum(VlrCertidao) - sum(FRJ) - sum(FRC) + SUM(TaxaCartao) - SUM(Valor_Selo) as Custas,
		Sum(Valor_Selo) as Selo,
		0 as Distrib,
		--Custas + Selo + Distrib as Subtotal
		SUM(ISS) AS ISS,
		SUM(FRJ) AS FRJ,
		SUM(FRC) AS FRC,
		SUM(TaxaCartao) AS TaxaBanco,
		'Certidões' as tipo
		--tot taxas
		--total
	FROM (
		SELECT 
        NomeCertidao,
        DocCertidao,
        COALESCE(SUM(VlrCertidao), 0) AS VlrCertidao, --somar frc e frj da positiva
        COALESCE(SUM(Valor_Selo), 0) AS Valor_Selo,
        COALESCE(SUM(TaxaCartao), 0) AS TaxaCartao,
        COALESCE(SUM(FRJ), 0) AS FRJ,
        COALESCE(SUM(FRC), 0) AS FRC,
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
        Data_Certidao BETWEEN '2024-02-19' AND '2024-02-19'
        AND Codigo <> 'DIGITAL'
        AND VlrCertidao != 0
    GROUP BY 
        NomeCertidao,
        DocCertidao,
        Codigo
	) as certidaoSubQuery

	UNION ALL
	--cancelados
	Select
		'Cancelados' as tipo,
		Sum(Custas) - Sum(FRJ) - SUM(FRC) as Custas,
		SUM(tblFinanceiro.Valor_Selo) as Selo,
		SUM(tblFinanceiro.Valor_Distrib) as Distrib,
		Sum(Custas) - Sum(FRJ) - SUM(FRC) + SUM(tblFinanceiro.Valor_Selo) + SUM(tblFinanceiro.Valor_Distrib) AS SubTotal,
		Sum(ISS) as ISS,
		Sum(FRJ) as FRJ,
		SUM(FRC) as FRC,
		SUM(TaxaCartao) as TaxaBanco,
		Sum(ISS) + Sum(FRJ) + SUM(FRC) as Tot_Taxas,
		Sum(Custas) - Sum(FRJ) - SUM(FRC) + SUM(tblFinanceiro.Valor_Selo) + SUM(tblFinanceiro.Valor_Distrib) + Sum(ISS) + Sum(FRJ) + SUM(FRC) + SUM(TaxaCartao)  as Total
	From 
		tblTitulo 
	INNER JOIN tblFinanceiro ON tblFinanceiro.Protocolo = tblTitulo.Protocolo_Cartorio 
		Where 
	tblTitulo.Data_Cancelado 
		BETWEEN '2024-03-19' AND '2024-03-19'
		AND tblTitulo.Tipo_Ocorrencia='A'
		AND Anulado='0'
		AND tblTitulo.CancelaBanco='0'
		AND tblFinanceiro.Data_Cancelado
		BETWEEN '2024-03-19' AND'2024-03-19'
		AND Custas != 0
) as totalReport