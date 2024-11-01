use SISPROT2
select 
	'Certidões' as tipo,
	COUNT(*) as Qtd,
	sum(VlrCertidao) - sum(FRJ) - sum(FRC) + SUM(TaxaCartao) - SUM(Valor_Selo) as Custas,
	Sum(Valor_Selo) as Selo,
	SUM(Distrib) as Distrib,
	sum(VlrCertidao) - sum(FRJ) - sum(FRC) + SUM(TaxaCartao) - SUM(Valor_Selo) + Sum(Valor_Selo) + SUM(Distrib) as SubTotal,
	sum(ISS) as ISS,
	sum(FRJ) as FRJ,
	sum(FRC) as FRC,
	sum(TaxaCartao) as TaxaBanco,
	sum(ISS) + sum(FRJ) + sum(FRC) as Tot_Taxas,
	sum(VlrCertidao) + SUM(TaxaCartao) + SUM(Distrib) + sum(ISS) as Total
from(
 SELECT 
        NomeCertidao,
        DocCertidao,
        COALESCE(SUM(VlrCertidao), 0) AS VlrCertidao,
        COALESCE(SUM(Valor_Selo), 0) AS Valor_Selo,
        COALESCE(SUM(TaxaCartao), 0) AS TaxaCartao,
        COALESCE(SUM(FRJ), 0) AS FRJ,
        COALESCE(SUM(FRC), 0) AS FRC,
		COALESCE(SUM(tblFinanceiro.Valor_Distrib),0) as Distrib,
        MAX(CAST(COALESCE(Cartao, 0) AS INT)) AS Cartao,
        Codigo,
        COALESCE(SUM(ISS), 0) AS ISS,
        CASE
            WHEN EXISTS (
                SELECT 1
                FROM tblFinanceiro AS f2
                WHERE f2.NomeCertidao = tblFinanceiro.NomeCertidao
                  AND f2.DocCertidao = tblFinanceiro.DocCertidao
                  AND f2.TipoCertidao = 'POSITIVA'
                  AND COALESCE(f2.VlrCertidao, 0) > 0
            ) THEN 'POSITIVA'
            ELSE 'NEGATIVA'
        END AS TipoCertidao
    FROM 
        tblFinanceiro
    WHERE 
        Data_Certidao BETWEEN '2024-03-19' AND '2024-03-19'
        AND Codigo <> 'DIGITAL'
        AND VlrCertidao != 0
    GROUP BY 
        NomeCertidao,
        DocCertidao,
        Codigo
)as consultao

union all

--cancelados
	Select
		'Cancelados' as tipo,
		COUNT(*) as Qtd,
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

union all

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

