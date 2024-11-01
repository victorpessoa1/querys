use SISPROT2 
--select req.Codigo,req.Nome,req.Num_Doc,req.Data_Req,fin.Codigo ,fin.NomeCertidao,fin.DocCertidao,fin.Data_Certidao from tblReqCertidao as req inner join tblFinanceiro as fin on Data_Certidao = Data_Req+1 and Num_Doc = DocCertidao and Req.Cenprot =1

UPDATE fin
SET fin.Codigo = req.Codigo
FROM tblFinanceiro fin
INNER JOIN tblReqCertidao req ON fin.Data_Certidao = req.Data_Req AND fin.DocCertidao = req.Num_Doc AND fin.Codigo = 'DIGITAL';

select DocCertidao,TipoCertidao,Codigo from tblFinanceiro where codigo = 'DIGITAL'

--select * from tblFinanceiro where DocCertidao = '29243111000100'


