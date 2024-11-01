select *
  FROM [SISPROT2].[dbo].[tblBoletos]  ORDER BY 
    CASE 
        WHEN Especie != 'CDA' THEN 1
        ELSE 2
    END 
