SELECT
  MetodoPagoID,
  INITCAP(Nombre) AS Nombre,
  Descripcion
FROM {{ source('public', 'metodospago') }}
