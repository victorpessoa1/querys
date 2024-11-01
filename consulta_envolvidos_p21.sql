use Protesto21PA
select nome,cod_envolvido,
ROW_NUMBER() OVER (PARTITION BY titid ORDER BY tenid) as sequencia,
case cod_envolvido 
	when 1 then 'Devedor'
	when 2 then 'Avalista'
	when 3 then 'Cedente/credor_atual'
	when 4 then 'Sacador/credor_original'
end
as envolvido
from view_credorOriginal_credorAtual_devedor as vccd 
inner join view_apresentantes as va on vccd.protocolo = va.TitProtocolo
where protocolo = '808956';

select 
	top(200) view_apresentantes.TitProtocolo,
	view_apresentantes.TitProtocoloDistribuidor,
	view_apresentantes.PesNome as apresentante,
	view_credorOriginal_credorAtual_devedor.nome,
	case cod_envolvido 
		when 1 then 'Devedor'
		when 2 then 'Avalista'
		when 3 then 'Cedente/credor_atual'
		when 4 then 'Sacador/credor_original'
	end as envolvido
from view_apresentantes inner join view_credorOriginal_credorAtual_devedor on view_apresentantes.TitProtocolo = view_credorOriginal_credorAtual_devedor.TitProtocolo
where view_credorOriginal_credorAtual_devedor.TitDataApresentacao > '2020-01-01' and view_apresentantes.TitProtocoloDistribuidor = '1807908'



--select top(200) *
--from view_credorOriginal_credorAtual_devedor

--update SISPROT2.dbo.tblTitulo 
--set 
--	SISPROT2.dbo.tblTitulo.Sacador = case vccd.cod_envolvido when '4' then vccd.nome end,
--	SISPROT2.dbo.tblTitulo.Cedente = case vccd.cod_envolvido when '3' then vccd.nome end
--from view_credorOriginal_credorAtual_devedor vccd 
--where SISPROT2.dbo.tblTitulo.Protocolo_Cartorio = TRY_CONVERT(INT,vccd.titProtocolo)


--update SISPROT2.dbo.tblTitulo 
--set 
--	SISPROT2.dbo.tblTitulo.Sacador = case vccd.cod_envolvido when '4' then vccd.nome end,
--	SISPROT2.dbo.tblTitulo.Cedente = case vccd.cod_envolvido when '3' then vccd.nome end
--from view_credorOriginal_credorAtual_devedor vccd 
--inner join SISPROT2.dbo.tblTitulo tbtit on tbtit.Protocolo_Cartorio = TRY_CONVERT(INT,vccd.titProtocolo)
--where SISPROT2.dbo.tblTitulo.Protocolo_Cartorio = TRY_CONVERT(INT,vccd.titProtocolo)

--select
--	case vccd.cod_envolvido when '4' then vccd.nome end as sacador,
--	case vccd.cod_envolvido when '3' then vccd.nome end as cedente
--from view_credorOriginal_credorAtual_devedor vccd 
--inner join SISPROT2.dbo.tblTitulo tbtit on tbtit.Protocolo_Cartorio = TRY_CONVERT(INT,vccd.titProtocolo)
--where tbtit.Protocolo_Cartorio = '1042686' and (vccd.cod_envolvido = '3' or vccd.cod_envolvido = '4')


--update SISPROT2.dbo.tblTitulo 
--set 
--	SISPROT2.dbo.tblTitulo.Sacador = case cod_envolvido when '4' then nome end,
--	SISPROT2.dbo.tblTitulo.Cedente = case cod_envolvido when '3' then nome end
--from(
--	select
--		cod_envolvido,
--		nome,
--		vccd.titProtocolo,
--		Protocolo_Cartorio
--	from view_credorOriginal_credorAtual_devedor vccd 
--	inner join SISPROT2.dbo.tblTitulo tbtit on tbtit.Protocolo_Cartorio = TRY_CONVERT(INT,vccd.titProtocolo)
--	where (vccd.cod_envolvido = '3' or vccd.cod_envolvido = '4') order by tbtit.Protocolo_Cartorio,cod_envolvido
--) as subconsulta where  SISPROT2.dbo.tblTitulo.Protocolo_Cartorio = TRY_CONVERT(INT,view_credorOriginal_credorAtual_devedor.titProtocolo)

--UPDATE tbtit
--SET 
--    --tbtit.Sacador = case subconsulta.cod_envolvido when 4 then subconsulta.nome end
--    tbtit.Cedente = CASE subconsulta.cod_envolvido WHEN 3 THEN subconsulta.nome END
--FROM SISPROT2.dbo.tblTitulo tbtit
--INNER JOIN (
--    SELECT
--        vccd.cod_envolvido,
--        vccd.nome,
--        TRY_CONVERT(INT, vccd.titProtocolo) AS Protocolo_Cartorio
--    FROM view_credorOriginal_credorAtual_devedor vccd 
--    --WHERE vccd.cod_envolvido IN ('3', '4')
--	WHERE vccd.cod_envolvido IN ('3')
--) AS subconsulta ON tbtit.Protocolo_Cartorio = subconsulta.Protocolo_Cartorio
--WHERE tbtit.Protocolo_Cartorio = subconsulta.Protocolo_Cartorio;

--UPDATE tbtit
--SET 
--    tbtit.Sacador = case subconsulta.cod_envolvido when 4 then subconsulta.nome end
--    --tbtit.Cedente = CASE subconsulta.cod_envolvido WHEN 3 THEN subconsulta.nome END
--FROM SISPROT2.dbo.tblTitulo tbtit
--INNER JOIN (
--    SELECT
--        vccd.cod_envolvido,
--        vccd.nome,
--        TRY_CONVERT(INT, vccd.titProtocolo) AS Protocolo_Cartorio
--    FROM view_credorOriginal_credorAtual_devedor vccd 
--    --WHERE vccd.cod_envolvido IN ('3', '4')
--	WHERE vccd.cod_envolvido IN ('4')
--) AS subconsulta ON tbtit.Protocolo_Cartorio = subconsulta.Protocolo_Cartorio
--WHERE tbtit.Protocolo_Cartorio = subconsulta.Protocolo_Cartorio;

