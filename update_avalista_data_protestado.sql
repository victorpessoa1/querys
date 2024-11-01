use SISPROT

update tblAvalista 
	set Protestado =  CASE 
							WHEN tt.Data_Protestado is not null then 1
					  END,
	Data_Protestado = tt.Data_Protestado
from tblTitulo tt
where 
	tblAvalista.Protocolo_Cartorio = tt.Protocolo_Cartorio 
	and tt.Tipo_Ocorrencia = '2' 
	and Anulado = '0' 
	and Baixado = '0'



--	select  tblAvalista.Num_devedor,tblAvalista.Data_Protestado from tblTitulo tt inner join tblAvalista on tblAvalista.Protocolo_Cartorio = tt.Protocolo_Cartorio 
--where 
--	tblAvalista.Protocolo_Cartorio = tt.Protocolo_Cartorio 
--	and tt.Tipo_Ocorrencia = '2' 
--	and Anulado = '0' 
--	and Baixado = '0'