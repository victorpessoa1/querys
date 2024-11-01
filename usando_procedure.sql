use SISPROT
EXECUTE dbo.spRelatorioFechamento 
    @DataInicial = '2024-02-19',    
	@DataFinal = '2024-02-19',
    @Cartao = 1;

--DECLARE @Result TABLE (
--    Tipo NVARCHAR(50),
--    Qtd INT,
--    TotalCustas DECIMAL(18, 2),
--    TotalSelo DECIMAL(18, 2),
--    TotalDistrib DECIMAL(18, 2),
--    TotalSubTotal DECIMAL(18, 2),
--    TotalISS DECIMAL(18, 2),
--    TotalFRJ DECIMAL(18, 2),
--    TotalFRC DECIMAL(18, 2),
--    TotalTaxaBanco DECIMAL(18, 2),
--    TotalTot_Taxas DECIMAL(18, 2),
--    TotalTotal DECIMAL(18, 2),
--	Cartao Bit
--);
--INSERT INTO @Result (Tipo,Qtd, TotalCustas, TotalSelo, TotalDistrib, TotalSubTotal, TotalISS, TotalFRJ, TotalFRC, TotalTaxaBanco, TotalTot_Taxas, TotalTotal,Cartao)
--EXEC dbo.spRelatorioFechamento 
--    @DataInicial = '2024-08-20',
--    @DataFinal = '2024-08-20',
--    @Cartao = null;

--INSERT INTO @Result (Tipo,Qtd, TotalCustas, TotalSelo, TotalDistrib, TotalSubTotal, TotalISS, TotalFRJ, TotalFRC, TotalTaxaBanco, TotalTot_Taxas, TotalTotal,Cartao)
--EXEC dbo.spRelatorioFechamento 
--    @DataInicial = '2024-08-20',
--    @DataFinal = '2024-08-20',
--    @Cartao = 0;

--INSERT INTO @Result (Tipo, Qtd, TotalCustas, TotalSelo, TotalDistrib, TotalSubTotal, TotalISS, TotalFRJ, TotalFRC, TotalTaxaBanco, TotalTot_Taxas, TotalTotal,Cartao)

--EXEC dbo.spRelatorioFechamento 
--    @DataInicial = '2024-08-20',
--    @DataFinal = '2024-08-20',
--    @Cartao = 1;

--SELECT * FROM @Result;