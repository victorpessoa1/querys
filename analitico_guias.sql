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
        --'Cancelados' as tipo,
        --COUNT(*) as Qtd,
        --SUM(Custas) - SUM(FRJ) - SUM(FRC) as Custas,
        --SUM(tblFinanceiro.Valor_Selo) as Selo,
        --SUM(tblFinanceiro.Valor_Distrib) as Distrib,
        --SUM(Custas) - SUM(FRJ) - SUM(FRC) + SUM(tblFinanceiro.Valor_Selo) + SUM(tblFinanceiro.Valor_Distrib) AS SubTotal,
        --SUM(ISS) as ISS,
        --SUM(FRJ) as FRJ,
        --SUM(FRC) as FRC,
        --SUM(TaxaCartao) as TaxaBanco,
        --SUM(ISS) + SUM(FRJ) + SUM(FRC) as Tot_Taxas,
		--N_guia,
		--tblFinanceiro.Protocolo,
		Valor_Tit,
		N_Guia,
		tblFinanceiro.Protocolo,
        SUM(Custas) - SUM(FRJ) - SUM(FRC) + SUM(tblFinanceiro.Valor_Selo) + SUM(tblFinanceiro.Valor_Distrib) + SUM(ISS) + SUM(FRJ) + SUM(FRC) + SUM(TaxaCartao) as Total,
	    tblGuias.Pagar as TotalGuia,
		cartao
		--tblFinanceiro.Tipo_Ocorrencia,
		--tblFinanceiro.Protocolo,
		--tblFinanceiro.Custas,
		--tblFinanceiro.Pagar,
		--tblGuias.N_Guia
		--@Cartao as Cartao
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
		)OR
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
	group by N_Guia,tblFinanceiro.protocolo, Valor_Tit , tblGuias.Pagar, Cartao

	