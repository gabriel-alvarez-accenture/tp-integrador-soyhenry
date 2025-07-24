SELECT
  p.productoid,
  INITCAP(p.nombre) AS nombre_producto,
  p.descripcion AS descripcion_producto,
  p.precio,
  p.stock,
  p.categoriaid,
  INITCAP(c.nombre) AS nombre_categoria,
  c.descripcion AS descripcion_categoria
FROM {{ ref('stg_productos') }} p
JOIN {{ ref('stg_categorias') }} c
  ON p.categoriaid = c.categoriaid
