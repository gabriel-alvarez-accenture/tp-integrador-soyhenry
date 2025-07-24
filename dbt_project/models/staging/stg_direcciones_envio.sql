SELECT
  direccionid,
  usuarioid,
  INITCAP(calle) AS calle,
  INITCAP(ciudad) AS ciudad,
  INITCAP(departamento) AS departamento,
  INITCAP(provincia) AS provincia,
  INITCAP(distrito) AS distrito,
  INITCAP(estado) AS estado,
  codigopostal,
  INITCAP(pais) AS pais
FROM {{ source('public', 'direccionesenvio') }}
