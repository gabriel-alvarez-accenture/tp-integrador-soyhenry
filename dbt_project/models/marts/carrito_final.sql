SELECT
  c.carritoid,
  c.usuarioid,
  c.productoid,
  c.cantidad,
  c.fechaagregado,
  p.precio,
  (c.cantidad * p.precio) AS monto_estimado
FROM {{ ref('stg_carrito') }} c
JOIN {{ ref('stg_productos') }} p
  ON c.productoid = p.productoid
