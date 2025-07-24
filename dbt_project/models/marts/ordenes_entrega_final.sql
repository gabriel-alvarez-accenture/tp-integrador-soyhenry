SELECT
  o.orden_id,
  o.usuario_id,
  INITCAP(u.nombre) AS nombre_usuario,
  INITCAP(u.apellido) AS apellido_usuario,
  o.fecha_orden,
  o.total,
  INITCAP(o.estado) AS estado_orden,
  INITCAP(d.departamento) AS departamento_entrega,
  INITCAP(d.provincia) AS provincia_entrega
FROM {{ ref('stg_ordenes') }} o
JOIN {{ ref('stg_usuarios') }} u
  ON o.usuario_id = u.usuario_id
JOIN {{ ref('stg_direcciones_envio') }} d
  ON o.usuario_id = d.usuario_id
