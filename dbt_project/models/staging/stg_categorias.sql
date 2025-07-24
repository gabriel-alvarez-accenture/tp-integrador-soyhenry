SELECT
  CategoriaID,
  INITCAP(Nombre) AS Nombre,
  Descripcion
FROM {{ source('public', 'categorias') }}
