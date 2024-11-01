use SISPROT2
SELECT 
	tblTitulo.Especie_Tit,
	Protocolo_Cartorio,
	Num_Titulo,
	Vencimento,
	Data_Apresenta,
	Origem,
	Saldo,
	Custas,
	tblFinanceiro.Valor_Selo as Valor_Selo,
	Estorno,
	TaxaCartao,
	Codigo,
	FRJ,
	FRC,
	ISS,
	Cartao,
	tblTitulo.CancelaBanco as CancelaBanco,
	tblTitulo.Devedor as Devedor,
	Sacador,
	tblTitulo.Valor_Juros as Valor_Juros,
	Valor_Mora,
	tblFinanceiro.V_Multa as V_Multa,
	tblFinanceiro.Valor_CPMF as Valor_CPMF,
	tblFinanceiro.Valor_Distrib as Valor_Distrib,
	Hora,
	Usuario,
	Nosso_Num,
	tblTitulo.Livro as Livro,
	tblTitulo.Pagina,
	Data_Protestado
FROM 
	tblTitulo 
	INNER JOIN 
		tblFinanceiro ON tblFinanceiro.Protocolo = tblTitulo.Protocolo_Cartorio 
WHERE 
		tblTitulo.Data_Cancelado 
		BETWEEN 
			'2024-04-26' AND '2024-04-26' 
		AND 
			tblTitulo.Tipo_Ocorrencia = 'A' 
		AND 
			Anulado = '0' 
		AND 
			Aguardando = '0'
		AND 
			tblFinanceiro.Data_Cancelado 
				BETWEEN '2024-04-26' AND '2024-04-26'
		