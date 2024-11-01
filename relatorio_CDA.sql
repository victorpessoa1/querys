--SELECT 
--		CONVERT(varchar(10), [Data_Apresenta], 103) AS Data_Apresenta
--		,Protocolo_Cartorio
--		,Protocolo_Dist
--		,[Cedente]
--      ,[CodPortador]
--      ,[Especie_Tit]
--      ,[Devedor]
--      ,[Data_Protocolo]
--	  ,Data_Retorno
    
--  FROM [SISPROT].[dbo].[tblTitulo] where Especie_Tit = 'CDA' and (Data_Retorno is null) and Data_Apresenta >= '2024-02-01' and Tipo_Ocorrencia = '' 
--  and (CodPortador = '910' or  CodPortador = '914' or CodPortador = '912') ORDER BY Data_Apresenta,Cedente 

SELECT 
		CONVERT(varchar(10), [Data_Apresenta], 103) AS Data_Apresenta
		,tblSelo_Usado.Protocolo_Cartorio
		,Protocolo_Dist
		,Data_Uso
		,[Cedente]
      ,[CodPortador]
      ,[Especie_Tit]
      ,[Devedor]
      ,[Data_Protocolo]
	  ,Data_Retorno
	  ,Data_Protestado
	  ,Doc_Devedor
	  ,N_Selo
	  ,Serie
	  ,TipoSelo
	  ,CodAto
	  ,Saldo
	  ,Emolumentos
	  ,tblSelo_Usado.FRJ
	  ,tblSelo_Usado.FRC
	  ,Data_Cancelado
  FROM [SISPROT].[dbo].[tblTitulo] inner join tblSelo_Usado on tblTitulo.Protocolo_Cartorio = tblSelo_Usado.Protocolo_Cartorio
  where Especie_Tit = 'CDA' 
  and (Data_Cancelado between '2024-07-01' and '2024-07-30' ) 
  and Data_Protestado < '2019-11-01' ORDER BY Data_Apresenta,Cedente 
