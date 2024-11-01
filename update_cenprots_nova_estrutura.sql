use SISPROT2 

UPDATE fin
SET fin.Rec_Data = fin.Data_Certidao,
    fin.Cenprot = 1
FROM tblFinanceiro fin
INNER JOIN tblReqCertidao req ON fin.Codigo = req.Codigo
WHERE req.Data_Req <> fin.Data_Certidao;


UPDATE positivas
SET positivas.Cenprot = req.Cenprot,
    positivas.Rec_Data = req.Rec_Data,
	positivas.Cartao = req.Cartao
FROM tblFinanceiro AS positivas
INNER JOIN (
    SELECT codigo, Cenprot, Rec_Data,Cartao
    FROM tblFinanceiro
    WHERE TipoCertidao = 'REQUISIÇÃO'
) AS req ON positivas.codigo = req.codigo
WHERE positivas.TipoCertidao = 'POSITIVA'
AND req.Cenprot = 1;

UPDATE fin
SET fin.Data_Certidao = req.Data_Req
FROM tblFinanceiro fin
INNER JOIN tblReqCertidao req ON fin.Codigo = req.Codigo
WHERE fin.Cenprot = 1;

