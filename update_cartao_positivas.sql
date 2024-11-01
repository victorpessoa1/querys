--select * from tblFinanceiro where TipoCertidao='POSITIVA' AND (Codigo = '' or codigo is null)
select * from tblFinanceiro where Codigo = '2902'

select * from tblFinanceiro where Cartao is null and Data_Certidao is not null order by Codigo
--SELECT * from tblReqCertidao where Num_doc= '67087574272'

--UPDATE f
--SET f.Cartao = r.Cartao
--FROM tblFinanceiro f
--JOIN (
--    SELECT Codigo, Cartao
--    FROM tblFinanceiro
--    WHERE TipoCertidao = 'REQUISIÇÃO'
--) r ON f.Codigo = r.Codigo
--WHERE f.Codigo = '2902';

--DECLARE @codigo_atual VARCHAR(255);

--DECLARE cur CURSOR FOR
--SELECT DISTINCT Codigo FROM tblFinanceiro;

--OPEN cur;
--FETCH NEXT FROM cur INTO @codigo_atual;

--WHILE @@FETCH_STATUS = 0
--BEGIN
--    UPDATE f
--    SET f.Cartao = r.Cartao
--    FROM tblFinanceiro f
--    JOIN (
--        SELECT Codigo, Cartao
--        FROM tblFinanceiro
--        WHERE TipoCertidao = 'REQUISIÇÃO'
--    ) r ON f.Codigo = r.Codigo
--    WHERE f.Codigo = @codigo_atual;

--    FETCH NEXT FROM cur INTO @codigo_atual;
--END;

--CLOSE cur;
--DEALLOCATE cur;
