SELECT
  direccion_id,
  usuario_id,
  INITCAP(calle) AS calle,
  INITCAP(ciudad) AS ciudad,
  INITCAP(departamento) AS departamento,
  INITCAP(provincia) AS provincia,
  INITCAP(distrito) AS distrito,
  INITCAP(estado) AS estado,
  codigo_postal,
  INITCAP(pais) AS pais
FROM {{ source('public', 'direccionesenvio') }}
