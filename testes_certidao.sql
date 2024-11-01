use SISPROT2
SELECT
	NomeCertidao,
	DocCertidao,
	TipoCertidao,
	Cartao,
	VlrCertidao,
	tblFinanceiro.Codigo,
	Data_Req,
	Data_Certidao,
	tblFinanceiro.Cenprot,
	tblReqCertidao.Cenprot
FROM 
	tblFinanceiro inner join tblReqCertidao on tblReqCertidao.Codigo = tblFinanceiro.Codigo
WHERE
	(
		Data_Certidao 
			Between '2024-04-16' AND '2024-04-16' 
		AND Data_Req Between '2024-04-16' AND '2024-04-16' 
		AND VlrCertidao != 0
		and (tblFinanceiro.Cenprot is null or tblFinanceiro.Cenprot = 0)
	)
	OR
	(
		Rec_Data
			Between '2024-04-16' AND '2024-04-16' 
		AND VlrCertidao != 0
		and tblFinanceiro.Cenprot = 1
	)
order by Codigo

--select * from tblFinanceiro where Codigo = '3191'