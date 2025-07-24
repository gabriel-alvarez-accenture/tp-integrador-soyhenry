SELECT
  o.ordenid,
  o.usuarioid,
  INITCAP(u.nombre) AS nombre_usuario,
  INITCAP(u.apellido) AS apellido_usuario,
  o.fechaorden,
  o.total,
  INITCAP(o.estado) AS estado_orden,
  INITCAP(d.departamento) AS departamento_entrega,
  INITCAP(d.provincia) AS provincia_entrega
FROM {{ ref('stg_ordenes') }} o
JOIN {{ ref('stg_usuarios') }} u
  ON o.usuarioid = u.usuarioid
JOIN {{ ref('stg_direcciones_envio') }} d
  ON o.usuarioid = d.usuarioid
