SELECT
  CarritoID,
  UsuarioID,
  ProductoID,
  Cantidad,
  FechaAgregado
FROM {{ source('public', 'carrito') }}
