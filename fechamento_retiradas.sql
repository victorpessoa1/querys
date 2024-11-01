USE SISPROT
DECLARE @DataInicial as DATE;
DECLARE @DataFinal as DATE
DECLARE @Cartao as BIT;

SET @DataInicial = '2024-05-03'
SET @DataFinal = '2024-05-03'
SET @Cartao = 0

DECLARE @Distribuidor Real;
SELECT TOP (1) @Distribuidor = Distribuidor
FROM tblApontamento

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
		tblTitulo.Data_Retirada BETWEEN @DataInicial AND @DataFinal 
		AND Anulado='0' 
		AND Aguardando='0' 
		AND tblFinanceiro.Data_Retirada BETWEEN @DataInicial AND @DataFinal
		AND Baixa_Lote = 0
	)
	OR
	(
		tblFinanceiro.Rec_Data BETWEEN @DataInicial AND @DataFinal 
		AND Anulado='0' 
		AND Aguardando='0' 
		AND Baixa_Lote = 1
	)
	AND (@Cartao IS NULL OR ISNULL(Cartao, 0) = @Cartao)