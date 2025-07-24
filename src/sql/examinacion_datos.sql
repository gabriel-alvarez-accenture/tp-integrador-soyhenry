-- USUARIOS:
    -- % DE CELDAS NULAS
    WITH total_filas AS (
        SELECT COUNT(*) AS filas FROM usuarios
    ),
    total_nulos AS (
        SELECT
            (COUNT(*) FILTER (WHERE nombre IS NULL)) +
            (COUNT(*) FILTER (WHERE apellido IS NULL)) +
            (COUNT(*) FILTER (WHERE dni IS NULL)) +
            (COUNT(*) FILTER (WHERE email IS NULL)) +
            (COUNT(*) FILTER (WHERE contraseña IS NULL)) +
            (COUNT(*) FILTER (WHERE fecharegistro IS NULL)) AS nulos
        FROM usuarios
    )
    SELECT
        nulos as celdas_nulas,
        filas * 6 AS total_celdas,
        ROUND((nulos::decimal / (filas * 6)) * 100, 2) AS porcentaje_nulos
    FROM total_filas, total_nulos;

    -- CANTIDAD DE FILAS DUPLICADAS
    SELECT SUM(duplicados.cantidad) AS total_filas_duplicadas
    FROM (
        SELECT COUNT(*) - 1 AS cantidad
        FROM usuarios
        GROUP BY nombre, apellido, dni, email, contraseña, fecharegistro
        HAVING COUNT(*) > 1
    ) AS duplicados;

-- CATEGORIAS:
    -- % DE CELDAS NULAS
    WITH total_filas AS (
        SELECT COUNT(*) AS filas FROM categorias
    ),
    total_nulos AS (
        SELECT
            (COUNT(*) FILTER (WHERE nombre IS NULL)) +
            (COUNT(*) FILTER (WHERE descripcion IS NULL)) AS nulos
        FROM categorias
    )
    SELECT
        nulos AS celdas_nulas,
        filas * 2 AS total_celdas,
        ROUND((nulos::decimal / (filas * 2)) * 100, 2) AS porcentaje_nulos
    FROM total_filas, total_nulos;

    -- CANTIDAD DE FILAS DUPLICADAS
    SELECT SUM(duplicados.cantidad) AS total_filas_duplicadas
    FROM (
        SELECT COUNT(*) - 1 AS cantidad
        FROM categorias
        GROUP BY nombre, descripcion
        HAVING COUNT(*) > 1
    ) AS duplicados;

-- PRODUCTOS:
    -- % DE CELDAS NULAS
    WITH total_filas AS (
        SELECT COUNT(*) AS filas FROM productos
    ),
    total_nulos AS (
        SELECT
            (COUNT(*) FILTER (WHERE nombre IS NULL)) +
            (COUNT(*) FILTER (WHERE descripcion IS NULL)) +
            (COUNT(*) FILTER (WHERE precio IS NULL)) +
            (COUNT(*) FILTER (WHERE stock IS NULL)) +
            (COUNT(*) FILTER (WHERE categoriaid IS NULL)) AS nulos
        FROM productos
    )
    SELECT
        nulos AS celdas_nulas,
        filas * 5 AS total_celdas,
        ROUND((nulos::decimal / (filas * 5)) * 100, 2) AS porcentaje_nulos
    FROM total_filas, total_nulos;

    -- CANTIDAD DE FILAS DUPLICADAS
    SELECT SUM(duplicados.cantidad) AS total_filas_duplicadas
    FROM (
        SELECT COUNT(*) - 1 AS cantidad
        FROM productos
        GROUP BY nombre, descripcion, precio, stock, categoriaid
        HAVING COUNT(*) > 1
    ) AS duplicados;

-- ORDENES:
    -- % DE CELDAS NULAS
    WITH total_filas AS (
        SELECT COUNT(*) AS filas FROM ordenes
    ),
    total_nulos AS (
        SELECT
            (COUNT(*) FILTER (WHERE usuarioid IS NULL)) +
            (COUNT(*) FILTER (WHERE fechaorden IS NULL)) +
            (COUNT(*) FILTER (WHERE total IS NULL)) +
            (COUNT(*) FILTER (WHERE estado IS NULL)) AS nulos
        FROM ordenes
    )
    SELECT
        nulos AS celdas_nulas,
        filas * 4 AS total_celdas,
        ROUND((nulos::decimal / (filas * 4)) * 100, 2) AS porcentaje_nulos
    FROM total_filas, total_nulos;

    -- CANTIDAD DE FILAS DUPLICADAS
    SELECT SUM(duplicados.cantidad) AS total_filas_duplicadas
    FROM (
        SELECT COUNT(*) - 1 AS cantidad
        FROM ordenes
        GROUP BY usuarioid, fechaorden, total, estado
        HAVING COUNT(*) > 1
    ) AS duplicados;

-- DETALLEORDENES:
    -- % DE CELDAS NULAS
    WITH total_filas AS (
        SELECT COUNT(*) AS filas FROM detalleordenes
    ),
    total_nulos AS (
        SELECT
            (COUNT(*) FILTER (WHERE ordenid IS NULL)) +
            (COUNT(*) FILTER (WHERE productoid IS NULL)) +
            (COUNT(*) FILTER (WHERE cantidad IS NULL)) +
            (COUNT(*) FILTER (WHERE preciounitario IS NULL)) AS nulos
        FROM detalleordenes
    )
    SELECT
        nulos AS celdas_nulas,
        filas * 4 AS total_celdas,
        ROUND((nulos::decimal / (filas * 4)) * 100, 2) AS porcentaje_nulos
    FROM total_filas, total_nulos;

    -- CANTIDAD DE FILAS DUPLICADAS
    SELECT SUM(duplicados.cantidad) AS total_filas_duplicadas
    FROM (
        SELECT COUNT(*) - 1 AS cantidad
        FROM detalleordenes
        GROUP BY ordenid, productoid, cantidad, preciounitario
        HAVING COUNT(*) > 1
    ) AS duplicados;

-- DIRECCIONESENVIO:
    -- % DE CELDAS NULAS
    WITH total_filas AS (
        SELECT COUNT(*) AS filas FROM direccionesenvio
    ),
    total_nulos AS (
        SELECT
            (COUNT(*) FILTER (WHERE usuarioid IS NULL)) +
            (COUNT(*) FILTER (WHERE calle IS NULL)) +
            (COUNT(*) FILTER (WHERE ciudad IS NULL)) +
            (COUNT(*) FILTER (WHERE departamento IS NULL)) +
            (COUNT(*) FILTER (WHERE provincia IS NULL)) +
            (COUNT(*) FILTER (WHERE distrito IS NULL)) +
            (COUNT(*) FILTER (WHERE estado IS NULL)) +
            (COUNT(*) FILTER (WHERE codigopostal IS NULL)) +
            (COUNT(*) FILTER (WHERE pais IS NULL)) AS nulos
        FROM direccionesenvio
    )
    SELECT
        nulos AS celdas_nulas,
        filas * 9 AS total_celdas,
        ROUND((nulos::decimal / (filas * 9)) * 100, 2) AS porcentaje_nulos
    FROM total_filas, total_nulos;

    -- CANTIDAD DE FILAS DUPLICADAS
    SELECT SUM(duplicados.cantidad) AS total_filas_duplicadas
    FROM (
        SELECT COUNT(*) - 1 AS cantidad
        FROM direccionesenvio
        GROUP BY usuarioid, calle, ciudad, departamento, provincia, distrito, estado, codigopostal, pais
        HAVING COUNT(*) > 1
    ) AS duplicados;

-- CARRITO:
    -- % DE CELDAS NULAS
    WITH total_filas AS (
        SELECT COUNT(*) AS filas FROM carrito
    ),
    total_nulos AS (
        SELECT
            (COUNT(*) FILTER (WHERE usuarioid IS NULL)) +
            (COUNT(*) FILTER (WHERE productoid IS NULL)) +
            (COUNT(*) FILTER (WHERE cantidad IS NULL)) +
            (COUNT(*) FILTER (WHERE fechaagregado IS NULL)) AS nulos
        FROM carrito
    )
    SELECT
        nulos AS celdas_nulas,
        filas * 4 AS total_celdas,
        ROUND((nulos::decimal / (filas * 4)) * 100, 2) AS porcentaje_nulos
    FROM total_filas, total_nulos;

    -- CANTIDAD DE FILAS DUPLICADAS
    SELECT SUM(duplicados.cantidad) AS total_filas_duplicadas
    FROM (
        SELECT COUNT(*) - 1 AS cantidad
        FROM carrito
        GROUP BY usuarioid, productoid, cantidad, fechaagregado
        HAVING COUNT(*) > 1
    ) AS duplicados;

-- METODOSPAGO:
    -- % DE CELDAS NULAS
    WITH total_filas AS (
        SELECT COUNT(*) AS filas FROM metodospago
    ),
    total_nulos AS (
        SELECT
            (COUNT(*) FILTER (WHERE nombre IS NULL)) +
            (COUNT(*) FILTER (WHERE descripcion IS NULL)) AS nulos
        FROM metodospago
    )
    SELECT
        nulos AS celdas_nulas,
        filas * 2 AS total_celdas,
        ROUND((nulos::decimal / (filas * 2)) * 100, 2) AS porcentaje_nulos
    FROM total_filas, total_nulos;

    -- CANTIDAD DE FILAS DUPLICADAS
    SELECT SUM(duplicados.cantidad) AS total_filas_duplicadas
    FROM (
        SELECT COUNT(*) - 1 AS cantidad
        FROM metodospago
        GROUP BY nombre, descripcion
        HAVING COUNT(*) > 1
    ) AS duplicados;

-- ORDENESMETODOSPAGO:
    -- % DE CELDAS NULAS
    WITH total_filas AS (
        SELECT COUNT(*) AS filas FROM ordenesmetodospago
    ),
    total_nulos AS (
        SELECT
            (COUNT(*) FILTER (WHERE ordenid IS NULL)) +
            (COUNT(*) FILTER (WHERE metodopagoid IS NULL)) +
            (COUNT(*) FILTER (WHERE montopagado IS NULL)) AS nulos
        FROM ordenesmetodospago
    )
    SELECT
        nulos AS celdas_nulas,
        filas * 3 AS total_celdas,
        ROUND((nulos::decimal / (filas * 3)) * 100, 2) AS porcentaje_nulos
    FROM total_filas, total_nulos;

    -- CANTIDAD DE FILAS DUPLICADAS
    SELECT SUM(duplicados.cantidad) AS total_filas_duplicadas
    FROM (
        SELECT COUNT(*) - 1 AS cantidad
        FROM ordenesmetodospago
        GROUP BY ordenid, metodopagoid, montopagado
        HAVING COUNT(*) > 1
    ) AS duplicados;

-- RESEÑASPRODUCTOS:
    -- % DE CELDAS NULAS
    WITH total_filas AS (
        SELECT COUNT(*) AS filas FROM reseñasproductos
    ),
    total_nulos AS (
        SELECT
            (COUNT(*) FILTER (WHERE usuarioid IS NULL)) +
            (COUNT(*) FILTER (WHERE productoid IS NULL)) +
            (COUNT(*) FILTER (WHERE calificacion IS NULL)) +
            (COUNT(*) FILTER (WHERE comentario IS NULL)) +
            (COUNT(*) FILTER (WHERE fecha IS NULL)) AS nulos
        FROM reseñasproductos
    )
    SELECT
        nulos AS celdas_nulas,
        filas * 5 AS total_celdas,
        ROUND((nulos::decimal / (filas * 5)) * 100, 2) AS porcentaje_nulos
    FROM total_filas, total_nulos;

    -- CANTIDAD DE FILAS DUPLICADAS
    SELECT SUM(duplicados.cantidad) AS total_filas_duplicadas
    FROM (
        SELECT COUNT(*) - 1 AS cantidad
        FROM reseñasproductos
        GROUP BY usuarioid, productoid, calificacion, comentario, fecha
        HAVING COUNT(*) > 1
    ) AS duplicados;

-- HISTORIALPAGOS:
    -- % DE CELDAS NULAS
    WITH total_filas AS (
        SELECT COUNT(*) AS filas FROM historialpagos
    ),
    total_nulos AS (
        SELECT
            (COUNT(*) FILTER (WHERE ordenid IS NULL)) +
            (COUNT(*) FILTER (WHERE metodopagoid IS NULL)) +
            (COUNT(*) FILTER (WHERE monto IS NULL)) +
            (COUNT(*) FILTER (WHERE fechapago IS NULL)) +
            (COUNT(*) FILTER (WHERE estadopago IS NULL)) AS nulos
        FROM historialpagos
    )
    SELECT
        nulos AS celdas_nulas,
        filas * 5 AS total_celdas,
        ROUND((nulos::decimal / (filas * 5)) * 100, 2) AS porcentaje_nulos
    FROM total_filas, total_nulos;

    -- CANTIDAD DE FILAS DUPLICADAS
    SELECT SUM(duplicados.cantidad) AS total_filas_duplicadas
    FROM (
        SELECT COUNT(*) - 1 AS cantidad
        FROM historialpagos
        GROUP BY ordenid, metodopagoid, monto, fechapago, estadopago
        HAVING COUNT(*) > 1
    ) AS duplicados;
