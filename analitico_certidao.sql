
use SISPROT
DECLARE @Cartao as bit,
		@DataInicial as Date,
		@DataFinal as Date

SET @DataInicial = '2024-03-25'
SET @DataFinal = '2024-03-25'
SET @Cartao = null

DECLARE @Distribuidor Real;
SELECT TOP (1) @Distribuidor = Distribuidor
FROM tblApontamento

SELECT 
			--'Certidões' as tipo,
			--COALESCE(COUNT(*),0) as Qtd,
			VlrCertidao - FRJ - FRC + TaxaCartao - Valor_Selo as Custas,
			Valor_Selo as Selo,
			Distrib as Distrib,
			VlrCertidao - FRJ - FRC + TaxaCartao - Valor_Selo + Valor_Selo + Distrib as SubTotal,
			ISS as ISS,
			FRJ as FRJ,
			FRC as FRC,
			ISS + FRJ + FRC as Tot_Taxas,
			codigo,
			VlrCertidao + Distrib + ISS as Total,
			Cartao
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
		codigo,
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
			tblFinanceiro.Codigo as codigo,
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
			tblFinanceiro
		WHERE
		(
			(
				Data_Certidao BETWEEN @DataInicial AND @DataFinal
				AND VlrCertidao != 0
				and (Cenprot is null or Cenprot = 0)
			)
			OR
			(
				Rec_Data BETWEEN @DataInicial AND @DataFinal
				AND VlrCertidao != 0
				and Cenprot = 1
			)
		) and Estorno is null
		GROUP BY 
			DocCertidao,
			tblFinanceiro.Codigo,
			Cartao
	) as teste where (@Cartao IS NULL OR ISNULL(Cartao, 0) = @Cartao)
	GROUP BY 
			DocCertidao,
			Codigo,
			Cartao,
			TipoCertidao
	) as consultao order by codigo