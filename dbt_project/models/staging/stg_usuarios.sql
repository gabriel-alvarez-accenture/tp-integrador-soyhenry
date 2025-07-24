select
  usuarioID,
  nombre,
  apellido,
  dni,
  email,
  fecharegistro
from {{ source('public', 'usuarios') }}