SELECT
  ReseñaID,
  UsuarioID,
  ProductoID,
  Calificacion,
  Comentario,
  Fecha
FROM {{ source('public', 'reseñasproductos') }}
