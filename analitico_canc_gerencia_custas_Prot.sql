use SISPROT

DECLARE @Cartao as bit,
		@DataInicial as Date,
		@DataFinal as Date

SET @DataInicial = '2024-03-25'
SET @DataFinal = '2024-03-25'
SET @Cartao = 1

DECLARE @Distribuidor Real;
SELECT TOP (1) @Distribuidor = Distribuidor
FROM tblApontamento

 SELECT 
 --tblFinanceiro.Protocolo,
 --tblfinanceiro.Tipo_Ocorrencia,
 --tblFinanceiro.Cartao
  --      'Cancelados' as tipo,
  --      COUNT(*) as Qtd,
		Custas - FRJ - FRC as Custas,
        tblFinanceiro.Valor_Selo as Selo,
        tblFinanceiro.Valor_Distrib as Distrib,
        Custas - FRJ - FRC + tblFinanceiro.Valor_Selo + tblFinanceiro.Valor_Distrib AS SubTotal,
        ISS as ISS,
        FRJ as FRJ,
        FRC as FRC,
        ISS + FRJ + FRC as Tot_Taxas,
		tblFinanceiro.Protocolo,
		N_Guia,
        Custas - FRJ - FRC + tblFinanceiro.Valor_Selo + tblFinanceiro.Valor_Distrib + ISS + FRJ + FRC + TaxaCartao as Total,
		@Cartao as Cartao
    FROM 
        tblTitulo 
    INNER JOIN tblFinanceiro ON tblFinanceiro.Protocolo = tblTitulo.Protocolo_Cartorio
	inner join tblGuias on tblFinanceiro.Protocolo = tblGuias.Protocolo

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
		) 
		OR
		(
			(
			tblTitulo.Data_Pagamento BETWEEN @DataInicial AND @DataFinal
			and tblFinanceiro.Tipo_Ocorrencia = '1'
			AND tblTitulo.CustasProtesto = '1'
			AND tblTitulo.Anulado = '0'
			AND tblTitulo.Aguardando = '0'
			AND tblTitulo.CancelaBanco = '0'
			AND tblFinanceiro.Data_Pagamento BETWEEN @DataInicial AND @DataFinal
			AND (tblFinanceiro.Baixa_Lote IS NULL or tblFinanceiro.Baixa_Lote = 0)
			AND tblFinanceiro.Custas != 0
		)
		OR
		(
			tblFinanceiro.Rec_Data BETWEEN @DataInicial AND @DataFinal 
			and tblFinanceiro.Tipo_Ocorrencia = '1'
			AND tblTitulo.CustasProtesto = 1
			AND tblTitulo.CancelaBanco = 1
			and tblFinanceiro.Rec_Canc = 1
			AND Baixa_Lote = 1
			AND tblFinanceiro.Custas != 0
		)
		)
	) AND (@Cartao IS NULL OR ISNULL(Cartao, 0) = @Cartao)
	order by N_Guia