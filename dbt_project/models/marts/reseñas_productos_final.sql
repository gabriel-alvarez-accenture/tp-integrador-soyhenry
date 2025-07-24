SELECT
  r.reseña_id,
  r.usuario_id,
  r.producto_id,
  INITCAP(p.nombre) AS nombre_producto,
  p.precio,
  r.calificacion,
  r.comentario,
  r.fecha
FROM {{ ref('stg_reseñas_productos') }} r
JOIN {{ ref('stg_productos') }} p
  ON r.producto_id = p.producto_id
