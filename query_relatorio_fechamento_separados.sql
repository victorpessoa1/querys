USE SISPROT2
--pagamentos
Select 
	*
From
	tblTitulo
INNER JOIN tblFinanceiro ON tblFinanceiro.Protocolo = tblTitulo.Protocolo_Cartorio 
WHERE
	tblFinanceiro.Estorno is null or
	tblFinanceiro.Estorno = 0 and
	tblFinanceiro.Data_Pagamento
	BETWEEN 
		'2024-03-01' AND '2024-03-01' 
	AND CustasProtesto Is Null
	AND Baixado='1' 
	AND Anulado='0'
	AND Aguardando='0'
	AND tblTitulo.CancelaBanco='0'

--cancelados
Select 
	* 
From 
	tblTitulo 
INNER JOIN tblFinanceiro ON tblFinanceiro.Protocolo = tblTitulo.Protocolo_Cartorio 
	Where 
tblTitulo.Data_Cancelado 
	BETWEEN '2024-03-15' AND '2024-03-15'
	AND tblTitulo.Tipo_Ocorrencia='A'
	AND Anulado='0'
	AND tblTitulo.CancelaBanco='0'
	AND tblFinanceiro.Data_Cancelado
	BETWEEN '2024-03-15' AND'2024-03-15'

--retirados
Select 
	* 
From
	tblTitulo 
INNER JOIN tblFinanceiro ON tblFinanceiro.Protocolo = tblTitulo.Protocolo_Cartorio 
Where 
	tblTitulo.Data_Retirada BETWEEN''AND''
	AND Tit_Particular='1'
	AND Anulado='0' 
	AND Aguardando='0'
	AND tblFinanceiro.Data_Retirada BETWEEN''AND''

