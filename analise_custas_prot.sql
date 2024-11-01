

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