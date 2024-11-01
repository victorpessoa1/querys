DECLARE @Cartao as bit,
		@DataInicial as Date,
		@DataFinal as Date

SET @DataInicial = '2024-06-13'
SET @DataFinal = '2024-06-13'
SET @Cartao = null

DECLARE @Distribuidor Real;
SELECT TOP (1) @Distribuidor = Distribuidor
FROM tblApontamento

SELECT 
			*
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