SELECT
  r.reseñaid,
  r.usuarioid,
  r.productoid,
  INITCAP(p.nombre) AS nombre_producto,
  p.precio,
  r.calificacion,
  r.comentario,
  r.fecha
FROM {{ ref('stg_reseñas_productos') }} r
JOIN {{ ref('stg_productos') }} p
  ON r.productoid = p.productoid
