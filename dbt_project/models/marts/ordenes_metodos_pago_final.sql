SELECT
  omp.orden_id,
  o.usuario_id,
  INITCAP(u.nombre) AS nombre_usuario,
  INITCAP(u.apellido) AS apellido_usuario,
  omp.metodo_pago_id,
  INITCAP(mp.nombre) AS nombre_metodo_pago,
  omp.monto_pagado,
  o.fecha_orden,
  INITCAP(o.estado) AS estado_orden
FROM {{ ref('stg_ordenes_metodos_pago') }} omp
JOIN {{ ref('stg_ordenes') }} o
  ON omp.orden_id = o.orden_id
JOIN {{ ref('stg_usuarios') }} u
  ON o.usuario_id = u.usuario_id
JOIN {{ ref('stg_metodos_pago') }} mp
  ON omp.metodo_pago_id = mp.metodo_pago_id
