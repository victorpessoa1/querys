USE SISPROT2
DECLARE @Distribuidor Real;

SELECT TOP (1) @Distribuidor = Distribuidor
FROM tblApontamento;
--pagamentos
Select 
	'Custas Pag' as tipo,
	COUNT(*) as Qtd,
	SUM(Custas) - SUM(FRJ) - SUM(FRC) + ((ROUND((@Distribuidor*0.025),2)+ROUND((@Distribuidor*0.15),2)) * COUNT(*)) as Custas,
	SUM(tblFinanceiro.Valor_Selo) as Selo,
	SUM(tblFinanceiro.Valor_Distrib) - ((ROUND((@Distribuidor*0.025),2)+ROUND((@Distribuidor*0.15),2)) * COUNT(*)) as Distrib,
	SUM(Custas) - SUM(FRJ) - SUM(FRC) + ((ROUND((@Distribuidor*0.025),2)+ROUND((@Distribuidor*0.15),2)) * COUNT(*)) + SUM(tblFinanceiro.Valor_Selo) + SUM(tblFinanceiro.Valor_Distrib) - ((ROUND((@Distribuidor*0.025),2)+ROUND((@Distribuidor*0.15),2)) * COUNT(*)) as SubTotal,
	SUM(ISS) AS ISS,
	SUM(FRJ) as FRJ,
	SUM(FRC) as FRC,
	COALESCE(SUM(tblFinanceiro.TED),0) AS TaxaBanco,
	SUM(ISS) +  SUM(FRJ) + SUM(FRC) as Tot_Taxas,
	(SUM(Custas) + ((ROUND((@Distribuidor*0.025),2)+ROUND((@Distribuidor*0.15),2)) * COUNT(*))) + SUM(ISS) + SUM(tblFinanceiro.Valor_Selo) + SUM(tblFinanceiro.Valor_Distrib) - ((ROUND((@Distribuidor*0.025),2)+ROUND((@Distribuidor*0.15),2)) * COUNT(*)) + COALESCE(SUM(TED),0) as Total
From
	tblTitulo
INNER JOIN tblFinanceiro ON tblFinanceiro.Protocolo = tblTitulo.Protocolo_Cartorio 
WHERE
	(tblFinanceiro.Estorno is null or
	tblFinanceiro.Estorno = 0) and
	tblFinanceiro.Data_Pagamento
	BETWEEN 
		'2024-04-19' AND '2024-04-19' 
	AND CustasProtesto Is Null
	AND Baixado='1' 
	AND Anulado='0'
	AND Aguardando='0'
	AND tblTitulo.CancelaBanco='0'
	and (Cartao is null or Cartao = 0)
	--and tblFinanceiro.Protocolo = '1811075'