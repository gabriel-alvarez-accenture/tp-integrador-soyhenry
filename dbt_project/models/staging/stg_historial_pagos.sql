SELECT
  PagoID,
  OrdenID,
  MetodoPagoID,
  Monto,
  FechaPago,
  INITCAP(EstadoPago) AS EstadoPago
FROM {{ source('public', 'historialpagos') }}
