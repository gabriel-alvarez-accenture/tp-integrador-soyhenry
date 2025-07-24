SELECT
  DetalleID,
  OrdenID,
  ProductoID,
  Cantidad,
  PrecioUnitario
FROM {{ source('public', 'detalleordenes') }}
