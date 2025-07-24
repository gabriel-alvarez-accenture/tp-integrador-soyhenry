SELECT
  omp.ordenid,
  o.usuarioid,
  INITCAP(u.nombre) AS nombre_usuario,
  INITCAP(u.apellido) AS apellido_usuario,
  omp.metodopagoid,
  INITCAP(mp.nombre) AS nombre_metodo_pago,
  omp.montopagado,
  o.fechaorden,
  INITCAP(o.estado) AS estado_orden
FROM {{ ref('stg_ordenes_metodos_pago') }} omp
JOIN {{ ref('stg_ordenes') }} o
  ON omp.ordenid = o.ordenid
JOIN {{ ref('stg_usuarios') }} u
  ON o.usuarioid = u.usuarioid
JOIN {{ ref('stg_metodos_pago') }} mp
  ON omp.metodopagoid = mp.metodopagoid
