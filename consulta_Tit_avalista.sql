use Protesto21PA
SELECT        PesPessoa.PesId, PesPessoa.Pes_TdcId, PesPessoa.PesNome, PesPessoa.PesDocumento, PesPessoa.PesTelefone, PesPessoa.PesBuscaBR, PesPessoa.PesCelular, PesPessoa.PesFax, PesPessoa.PesEmail, 
                         PesPessoa.PesNacionalidade, PesPessoa.Pes_EscId, PesPessoa.PesProfissao, TenTituloEnvolvido.Ten_TitId, TenTituloEnvolvido.Ten_EnvId, TenTituloEnvolvido.TenTipoDevedor, TenTituloEnvolvido.Ten_EndId, 
                         TenTituloEnvolvido.Ten_PesId, TitTitulo.TitProtocolo, TitTitulo.TitProtocoloDistribuidor, EndEndereco.EndEndereco, EndEndereco.EndBairro, EndEndereco.EndCidade, EndEndereco.EndEstado, EndEndereco.EndCEP
FROM            EndEndereco INNER JOIN
                         TenTituloEnvolvido ON EndEndereco.EndId = TenTituloEnvolvido.Ten_EndId LEFT OUTER JOIN
                         PesPessoa ON TenTituloEnvolvido.Ten_PesId = PesPessoa.PesId RIGHT OUTER JOIN
                         TitTitulo ON TenTituloEnvolvido.Ten_TitId = TitTitulo.TitId
WHERE        (PesPessoa.PesDocumento IS NOT NULL) AND (TitTitulo.TitProtocoloDistribuidor = '480042')
ORDER BY TitTitulo.TitProtocolo