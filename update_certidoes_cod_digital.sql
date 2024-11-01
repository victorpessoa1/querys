use SISPROT
--select req.Codigo,req.Nome,req.Num_Doc,req.Data_Req,fin.Codigo ,fin.NomeCertidao,fin.DocCertidao,fin.Data_Certidao from tblReqCertidao as req inner join tblFinanceiro as fin on Data_Certidao = Data_Req and Num_Doc = DocCertidao and fin.Codigo ='DIGITAL'

UPDATE fin
SET fin.Codigo = req.Codigo
FROM tblFinanceiro fin
INNER JOIN tblReqCertidao req ON fin.Data_Certidao = req.Data_Req AND fin.DocCertidao = req.Num_Doc
WHERE fin.Codigo = 'DIGITAL';

--select * from tblFinanceiro where Codigo = 'DIGITAL'
