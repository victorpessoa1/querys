SELECT 
	'Custas Prot' as tipo,
	COUNT(*) as Qtd,
	SUM(Custas) - SUM(FRJ) - SUM(FRC) as Custas,
	SUM(f.Valor_Selo) as Selo,
	SUM(f.Valor_Distrib) as Distrib,
	SUM(Custas) - SUM(FRJ) - SUM(FRC) + SUM(f.Valor_Selo) + SUM(f.Valor_Distrib) as SubTotal,
	SUM(ISS) as ISS,
	SUM(FRJ) as FRJ,
	SUM (FRC) as FRC,
	SUM(TaxaCartao) as TaxaBanco,
	SUM(ISS) + SUM(FRJ) + SUM (FRC) as Tot_Taxas,
	SUM(Custas) + SUM(ISS) + SUM(TaxaCartao) + SUM(f.Valor_Selo) + SUM(f.Valor_Distrib) as Total
FROM tblTitulo t
INNER JOIN tblFinanceiro f ON t.Protocolo_Cartorio = f.Protocolo
WHERE t.Data_Pagamento BETWEEN '2024-03-19' AND '2024-03-19'
    AND t.CustasProtesto = '1'
    AND t.Anulado = '0'
    AND t.Aguardando = '0'
    AND t.CancelaBanco = '0'
    AND f.Data_Pagamento BETWEEN '2024-03-19' AND '2024-03-19'
    AND f.Baixa_Lote IS NULL
	AND Custas != 0;
