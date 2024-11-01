use Protesto21PA

--UPDATE SISPROT2.dbo.tblTitulo
--set SISPROT2.dbo.tblTitulo.Doc_Sacador = p.PesDocumento
--from PesPessoa p 
--inner join 
--	TenTituloEnvolvido titenv on p.PesId = titenv.Ten_TitId  
--inner join TitTitulo on titenv.Ten_PesId = TitTitulo.TitId 
--where SISPROT2.dbo.tblTitulo.Sacador = p.PesNome and SISPROT2.dbo.tblTitulo.Doc_Sacador is null;

UPDATE SISPROT.dbo.tblTitulo
set SISPROT.dbo.tblTitulo.Doc_Sacador = p.PesDocumento
from PesPessoa p 
right outer join  
	TenTituloEnvolvido titenv on p.PesId = titenv.Ten_PesId
right outer join  
	TitTitulo on titenv.Ten_TitId = TitTitulo.TitId
where 
	p.PesDocumento is not null and titenv.Ten_EnvId = '4' 
	and SISPROT.dbo.tblTitulo.Protocolo_Cartorio = TRY_CONVERT(INT,TitTitulo.TitProtocolo)
	and SISPROT.dbo.tblTitulo.Doc_Sacador is null;


--SELECT * from PesPessoa p 
--right outer join  
--	TenTituloEnvolvido titenv on p.PesId = titenv.Ten_PesId
--right outer join  
--	TitTitulo on titenv.Ten_TitId = TitTitulo.TitId
--where p.PesDocumento is not null and titenv.Ten_EnvId = '4'

--select * from PesPessoa p 
--right outer join  
--	TenTituloEnvolvido titenv on p.PesId = titenv.Ten_PesId
--right outer join  
--	TitTitulo on titenv.Ten_TitId = TitTitulo.TitId
--where 
--	p.PesDocumento is not null and titenv.Ten_EnvId = '4' 
--	and SISPROT2.dbo.tblTitulo.Protocolo_Cartorio = TRY_CONVERT(INT,TitTitulo.TitProtocolo)
--	and SISPROT2.dbo.tblTitulo.Doc_Sacador is null;