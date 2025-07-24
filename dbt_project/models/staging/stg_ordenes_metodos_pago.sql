SELECT
  OrdenMetodoID,
  OrdenID,
  MetodoPagoID,
  MontoPagado
FROM {{ source('public', 'ordenesmetodospago') }}
