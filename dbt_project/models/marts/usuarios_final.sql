select
  UsuarioID,
  initcap(Nombre) as Nombre,
  initcap(Apellido) as Apellido,
  DNI,
  lower(Email) as Email,
  FechaRegistro
from {{ ref('stg_usuarios') }}