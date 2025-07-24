SELECT
  ProductoID,
  INITCAP(Nombre) AS Nombre,
  Descripcion,
  Precio,
  Stock,
  CategoriaID
FROM {{ source('public', 'productos') }}
