SELECT
  OrdenID,
  UsuarioID,
  FechaOrden,
  Total,
  INITCAP(Estado) AS Estado
FROM {{ source('public', 'ordenes') }}
