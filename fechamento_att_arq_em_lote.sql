CREATE OR ALTER PROCEDURE spRelatorioFechamento
    @DataInicial DATE,
    @DataFinal DATE,
    @Cartao BIT
AS
BEGIN

DECLARE @Distribuidor Real;
SELECT TOP (1) @Distribuidor = Distribuidor
FROM tblApontamento

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
       SUM(Total) as TotalTotal,
	   @Cartao as Cartao
FROM (
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
			COALESCE(SUM(TaxaBanco),0) as TaxaBanco,
			COALESCE(SUM(ISS) + SUM(FRJ) + SUM(FRC),0) as Tot_Taxas,
			COALESCE(SUM(VlrCertidao) + SUM(Distrib) + SUM(ISS),0) as Total,
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
			tblFinanceiro
		WHERE 
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
        SUM(Custas) - SUM(FRJ) - SUM(FRC) + SUM(tblFinanceiro.Valor_Selo) + SUM(tblFinanceiro.Valor_Distrib) + SUM(ISS) + SUM(FRJ) + SUM(FRC) + SUM(TaxaCartao) as Total,
		@Cartao as Cartao
    FROM 
        tblTitulo 
    INNER JOIN tblFinanceiro ON tblFinanceiro.Protocolo = tblTitulo.Protocolo_Cartorio 
    WHERE 
	--original
  --      tblTitulo.Data_Cancelado BETWEEN @DataInicial AND @DataFinal
  --      AND tblTitulo.Tipo_Ocorrencia = 'A'
  --      AND tblTitulo.Anulado = '0'
  --      AND tblTitulo.CancelaBanco = '0'
		--AND tblFinanceiro.Data_Cancelado BETWEEN @DataInicial AND @DataFinal
  --      AND tblFinanceiro.Custas != 0
		--AND (@Cartao IS NULL OR ISNULL(Cartao, 0) = @Cartao)
	(
		(
			tblFinanceiro.Data_Cancelado BETWEEN @DataInicial AND @DataFinal 
			AND tblFinanceiro.Tipo_Ocorrencia = 'A'
			AND tblTitulo.Anulado = '0'
			AND tblTitulo.CancelaBanco = '0'
			AND tblFinanceiro.Custas != 0
			AND (Baixa_Lote = 0 or Baixa_Lote is null)
		)
		OR
		(
			tblFinanceiro.Rec_Data BETWEEN @DataInicial AND @DataFinal 
			AND tblFinanceiro.Tipo_Ocorrencia = 'A'
			AND tblTitulo.CancelaBanco = 1
			and tblFinanceiro.Rec_Canc = 1
			AND Baixa_Lote = 1
			AND tblFinanceiro.Custas != 0
		)
	) AND (@Cartao IS NULL OR ISNULL(Cartao, 0) = @Cartao)
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
        SUM(Custas) + SUM(ISS) + SUM(TaxaCartao) + SUM(f.Valor_Selo) + SUM(f.Valor_Distrib) as Total,
		@Cartao as Cartao
    FROM 
        tblTitulo t
    INNER JOIN tblFinanceiro f ON t.Protocolo_Cartorio = f.Protocolo
    WHERE 
	--original
	--t.Data_Pagamento BETWEEN @DataInicial AND @DataFinal
	--		AND t.CustasProtesto = '1'
	--		AND t.Anulado = '0'
	--		AND t.Aguardando = '0'
	--		AND t.CancelaBanco = '0'
	--		AND f.Data_Pagamento BETWEEN @DataInicial AND @DataFinal
	--		AND f.Baixa_Lote IS NULL
	--		AND f.Custas != 0
	(
		(
			t.Data_Pagamento BETWEEN @DataInicial AND @DataFinal
			and f.Tipo_Ocorrencia = '1'
			AND t.CustasProtesto = '1'
			AND t.Anulado = '0'
			AND t.Aguardando = '0'
			AND t.CancelaBanco = '0'
			AND f.Data_Pagamento BETWEEN @DataInicial AND @DataFinal
			AND (f.Baixa_Lote IS NULL or f.Baixa_Lote = 0)
			AND f.Custas != 0
		)
		OR
		(
			f.Rec_Data BETWEEN @DataInicial AND @DataFinal 
			and f.Tipo_Ocorrencia = '1'
			AND t.CustasProtesto = 1
			AND t.CancelaBanco = 1
			and f.Rec_Canc = 1
			AND Baixa_Lote = 1
			AND f.Custas != 0
		)
	) AND (@Cartao IS NULL OR ISNULL(Cartao, 0) = @Cartao)

	UNION ALL
	--pagamentos
	Select 
		'Custas Pag' as tipo,
		COALESCE(COUNT(*),0) as Qtd,
		COALESCE(SUM(Custas) - SUM(FRJ) - SUM(FRC) + ((ROUND((@Distribuidor*0.025),2)+ROUND((@Distribuidor*0.15),2)) * COUNT(*)),0) as Custas,
		COALESCE(SUM(tblFinanceiro.Valor_Selo),0) as Selo,
		COALESCE(SUM(tblFinanceiro.Valor_Distrib) - ((ROUND((@Distribuidor*0.025),2)+ROUND((@Distribuidor*0.15),2)) * COUNT(*)),0) as Distrib,
		COALESCE(SUM(Custas) - SUM(FRJ) - SUM(FRC) + ((ROUND((@Distribuidor*0.025),2)+ROUND((@Distribuidor*0.15),2)) * COUNT(*)) + SUM(tblFinanceiro.Valor_Selo) + SUM(tblFinanceiro.Valor_Distrib) - ((ROUND((@Distribuidor*0.025),2)+ROUND((@Distribuidor*0.15),2)) * COUNT(*)),0) as SubTotal,
		COALESCE(SUM(ISS),0) AS ISS,
		COALESCE(SUM(FRJ),0) as FRJ,
		COALESCE(SUM(FRC),0) as FRC,
		COALESCE(SUM(tblFinanceiro.TED),0) AS TaxaBanco,
		COALESCE(SUM(ISS) +  SUM(FRJ) + SUM(FRC),0) as Tot_Taxas,
		COALESCE((SUM(Custas) + ((ROUND((@Distribuidor*0.025),2)+ROUND((@Distribuidor*0.15),2)) * COUNT(*))) + SUM(ISS) + SUM(tblFinanceiro.Valor_Selo) + SUM(tblFinanceiro.Valor_Distrib) - ((ROUND((@Distribuidor*0.025),2)+ROUND((@Distribuidor*0.15),2)) * COUNT(*)) + COALESCE(SUM(TED),0),0) as Total,
		@Cartao as Cartao
	From
		tblTitulo
	INNER JOIN tblFinanceiro ON tblFinanceiro.Protocolo = tblTitulo.Protocolo_Cartorio 
	WHERE
		(tblFinanceiro.Estorno is null or
		tblFinanceiro.Estorno = 0) and
		tblFinanceiro.Data_Pagamento
		BETWEEN 
			@DataInicial AND @DataFinal
		AND CustasProtesto Is Null
		AND Baixado='1' 
		AND Anulado='0'
		AND Aguardando='0'
		AND tblTitulo.CancelaBanco='0'
		AND (@Cartao IS NULL OR ISNULL(Cartao, 0) = @Cartao)
		--and tblFinanceiro.Protocolo = '1811075'

	UNION ALL

		SELECT 
			'Retirados' as tipo,
			COUNT(*) as Qtd,
			COALESCE(SUM(Custas) - SUM(FRJ) - SUM(FRC) + ((ROUND((@Distribuidor*0.025),2)+ROUND((@Distribuidor*0.15),2)) * COUNT(*)),0)  as Custas,
			COALESCE(SUM(tblFinanceiro.Valor_Selo),0) as Selo,
			COALESCE(SUM(tblFinanceiro.Valor_Distrib) - ((ROUND((@Distribuidor*0.025),2)+ROUND((@Distribuidor*0.15),2)) * COUNT(*)),0) as Distrib,
			COALESCE(SUM(Custas) - SUM(FRJ) - SUM(FRC) + SUM(tblFinanceiro.Valor_Selo) + SUM(tblFinanceiro.Valor_Distrib),0) as SubTotal,
			COALESCE(SUM(ISS),0) as ISS,
			COALESCE(SUM(FRJ),0) as FRJ,
			COALESCE(SUM(FRC),0) as FRC,
			COALESCE(SUM(TaxaCartao),0) as TaxaBanco,
			COALESCE(SUM(ISS) + SUM(FRJ) + SUM(FRC),0) as Tot_Taxas,
			COALESCE(SUM(Custas) + SUM(ISS) + COALESCE(SUM(TaxaCartao),0) + SUM(tblFinanceiro.Valor_Selo) + SUM(tblFinanceiro.Valor_Distrib),0) as Total,
			@Cartao as Cartao
		FROM 
		tblTitulo inner join tblFinanceiro on tblTitulo.Protocolo_Cartorio = tblFinanceiro.Protocolo 
		Where 
		(
			(
				tblTitulo.Data_Retirada BETWEEN @DataInicial AND @DataFinal 
				AND Anulado='0' 
				AND Aguardando='0' 
				AND tblFinanceiro.Data_Retirada BETWEEN @DataInicial AND @DataFinal
				AND (Baixa_Lote = 0 or Baixa_Lote is null)
			)
			OR
			(
				tblFinanceiro.Rec_Data BETWEEN @DataInicial AND @DataFinal
				and tblFinanceiro.Data_Retirada > 0 --adicionado
				AND Anulado='0' 
				AND Aguardando='0' 
				AND Baixa_Lote = 1
			)
		)
			AND (@Cartao IS NULL OR ISNULL(Cartao, 0) = @Cartao)

) as combined_data
GROUP BY tipo
WITH ROLLUP;
End;