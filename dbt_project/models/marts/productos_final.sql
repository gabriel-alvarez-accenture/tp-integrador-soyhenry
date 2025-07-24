SELECT
  p.producto_id,
  INITCAP(p.nombre) AS nombre_producto,
  p.descripcion AS descripcion_producto,
  p.precio,
  p.stock,
  p.categoria_id,
  INITCAP(c.nombre) AS nombre_categoria,
  c.descripcion AS descripcion_categoria
FROM {{ ref('stg_productos') }} p
JOIN {{ ref('stg_categorias') }} c
  ON p.categoria_id = c.categoria_id
