SELECT
  c.carrito_id,
  c.usuario_id,
  c.producto_id,
  c.cantidad,
  c.fecha_agregado,
  p.precio,
  (c.cantidad * p.precio) AS monto_estimado
FROM {{ ref('stg_carrito') }} c
JOIN {{ ref('stg_productos') }} p
  ON c.producto_id = p.producto_id
