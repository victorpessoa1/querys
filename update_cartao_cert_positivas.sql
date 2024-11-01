use SISPROT2
UPDATE tblFinanceiro
SET cartao = (
    SELECT TOP 1 cartao
    FROM tblFinanceiro AS c2
    WHERE c2.codigo = tblFinanceiro.codigo AND c2.TipoCertidao = 'REQUISIÇÃO'
    ORDER BY c2.cartao
)
WHERE TipoCertidao <> 'REQUISIÇÃO'
  AND EXISTS (
    SELECT 1
    FROM tblFinanceiro AS c3
    WHERE c3.codigo = tblFinanceiro.codigo AND c3.TipoCertidao = 'REQUISIÇÃO'
);