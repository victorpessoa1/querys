use SISPROT

DECLARE @DataInicial as DATE
DECLARE @DataFinal as DATE

set @DataInicial = '2024-03-25'
set @DataFinal = '2024-03-25'

SELECT
	NomeCertidao,
	Codigo,
	TipoCertidao,
	Cartao,
	VlrCertidao,
	tblFinanceiro.Cenprot,
	Data_Certidao,
	Rec_Data,
	Usuario,
	DocCertidao,
	Hora
FROM 
	tblFinanceiro 
WHERE
(
	(
		Data_Certidao 
			Between @DataInicial AND @DataFinal
		AND VlrCertidao != 0
		and (Cenprot is null or Cenprot = 0)
		
	)
	OR
	(
		Rec_Data
			Between @DataInicial AND @DataFinal 
		AND VlrCertidao != 0
		and Cenprot = 1

	)
) 
order by Codigo asc

