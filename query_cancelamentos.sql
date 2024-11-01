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

--tblFinanceiro.Devedor,
--Sacador,
--Nosso_Num,
--tblFinanceiro.Valor_Juros,
--Valor_Mora,
--tblFinanceiro.V_Multa,
--tblFinanceiro.Valor_CPMF,
--Usuario,
--Num_Titulo,
--tblFinanceiro.Especie_Tit,
--Vencimento,
--Data_Apresenta,
--Origem,
--Saldo,
--Hora,
--Cartao,
--TaxaCartao