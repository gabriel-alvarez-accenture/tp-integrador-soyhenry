-- Los atributos clave son los que se encuentran en este archivo para responder las preguntas del negocio.
/* LLAVES PRIMARIAS:
Tabla					Llave Primaria
Usuarios				UsuarioID
Categorias				CategoriaID
Productos				ProductoID
Ordenes					OrdenID
DetalleOrdenes			DetalleID
DireccionesEnvio		DireccionID
Carrito					CarritoID
MetodosPago				MetodoPagoID
OrdenesMetodosPago		OrdenMetodoID
ReseñasProductos		ReseñaID
HistorialPagos			PagoID

LLAVES FORANEAS
Tabla					Llave Foránea	Referencia a
Productos				CategoriaID		Categorias(CategoriaID)
Ordenes					UsuarioID		Usuarios(UsuarioID)
DetalleOrdenes			OrdenID			Ordenes(OrdenID)
DetalleOrdenes			ProductoID		Productos(ProductoID)
DireccionesEnvio		UsuarioID		Usuarios(UsuarioID)
Carrito					UsuarioID		Usuarios(UsuarioID)
Carrito					ProductoID		Productos(ProductoID)
OrdenesMetodosPago		OrdenID			Ordenes(OrdenID)
OrdenesMetodosPago		MetodoPagoID	MetodosPago(MetodoPagoID)
ReseñasProductos		UsuarioID		Usuarios(UsuarioID)
ReseñasProductos		ProductoID		Productos(ProductoID)
HistorialPagos			OrdenID			Ordenes(OrdenID)
HistorialPagos			MetodoPagoID	MetodosPago(MetodoPagoID)
*/

/* ENTREGABLE 2: los datos actuales responden las preguntas del negocio, los hechos y dimensiones se 
detallan en cada par de pregunta-respuesta.
*/

-- ===================================== VENTAS =====================================
-- 1) ¿Cuáles son los productos más vendidos por volumen?
	select 
		prod.descripcion, 
		sum(detord.cantidad) as cant_unidades_vendidas
	from 
		public.detalleordenes detord
	inner join 
		public.ordenes ord on detord.ordenid = ord.ordenid and ord.estado in ('Completado','Enviado')
	inner join 
		public.productos prod on detord.productoid = prod.productoid
	group by 
		prod.descripcion
	order by 
		cant_unidades_vendidas desc
	limit 5;
/*
Hecho (medida): 
	sum(detord.cantidad) → total de unidades vendidas.

Dimensiones:
	prod.descripcion (agrupación por producto)
	ord.estado (filtro: solo órdenes completadas o enviadas)
*/


-- 2) ¿Cuál es el ticket promedio por orden?
	-- Opcion 1:
	SELECT 
		avg(total)
	FROM 
		public.ordenes;

	-- Opcion 2:
	SELECT 
		AVG(cantidad * preciounitario) 
	FROM 
		public.detalleordenes;
/*
Hecho (medida):
	Opción 1: avg(total) → promedio del total por orden
	Opción 2: avg(cantidad * preciounitario) → promedio del monto por ítem en todas las órdenes

Dimensiones: En ambos casos, no se usa ninguna, se podrian agregar filtros como fechas o estado de ordenes.
*/


-- 3) ¿Cuáles son las categorías con mayor número de productos vendidos?
	select 
		cat.nombre,
		sum(c.cant_vendida) as cant_vendida
	from 
		public.productos prod
	inner join 
		public.categorias cat	on prod.categoriaid = cat.categoriaid
	inner join 
		(select 
			detord.productoid,
			detord.cantidad as cant_vendida
		from
			public.detalleordenes detord
		inner join
			public.ordenes ord on detord.ordenid = ord.ordenid and ord.estado in ('Completado','Enviado')
		) c on prod.productoid = c.productoid
	group by 
		cat.nombre
	order by 
		cant_vendida desc
	limit 5;
/*
Hecho (medida): 
	sum(c.cant_vendida) → total de unidades vendidas por categoría

Dimensiones:
	cat.nombre (agrupación por categoría)
	ord.estado (filtro: órdenes completadas o enviadas)
*/


-- 4) ¿Qué día de la semana se generan más ventas?
	SELECT 
		CASE TRIM(TO_CHAR(FechaOrden, 'Day'))
			WHEN 'Sunday' 		THEN 'Domingo'
			WHEN 'Monday' 		THEN 'Lunes'
			WHEN 'Tuesday' 		THEN 'Martes'
			WHEN 'Wednesday' 	THEN 'Miércoles'
			WHEN 'Thursday' 	THEN 'Jueves'
			WHEN 'Friday' 		THEN 'Viernes'
			WHEN 'Saturday' 	THEN 'Sábado'
		END AS dia_semana,
		COUNT(*) AS cantidad_ordenes
	FROM 
		public.Ordenes
	GROUP BY 
		dia_semana
	ORDER BY 
		cantidad_ordenes DESC;
/*
Hecho (medida): 
	COUNT(*) → cantidad de órdenes generadas por día

Dimensión:
	Día de la semana (FechaOrden → transformado con TO_CHAR y agrupado como dia_semana)
*/


-- 5) ¿Cuántas órdenes se generan cada mes y cuál es su variación?
	WITH ordenes_mensuales AS (
		SELECT 
			DATE_TRUNC('month', FechaOrden) AS mes, -- se toma el 1er dia del mes para representarlo
			COUNT(*) AS cant_ordenes
		FROM 
			public.ordenes
		GROUP BY 
			DATE_TRUNC('month', FechaOrden)
	),
	variacion AS (
		SELECT 
			mes,
			cant_ordenes,
			LAG(cant_ordenes) OVER (ORDER BY mes) AS cant_ordenes_mes_anterior
		FROM 
			ordenes_mensuales
	)
	SELECT 
		mes,
		cant_ordenes,
		ROUND(
		CASE 
			WHEN cant_ordenes_mes_anterior IS NULL THEN 0
			ELSE ((cant_ordenes - cant_ordenes_mes_anterior) * 100.0 / cant_ordenes_mes_anterior)
		END, 2
		) AS variacion_porcentual
	FROM 
		variacion
	ORDER BY 
		mes asc;
/*
Hechos (medidas):
	COUNT(*) → cantidad de órdenes por mes
	Variación porcentual mensual de órdenes (variacion_porcentual)

Dimensión:
	Fecha (FechaOrden) truncada al mes → agrupación mensual
*/
-- ===================================== PAGOS Y TRANSACCIONES =====================================
-- 1) ¿Cuáles son los métodos de pago más utilizados?
	select 
		metpago.nombre,
		metpago.descripcion,
		count(*) cant_usos
	from 
		public.ordenesMetodosPago ord_metpago
	inner join
		public.metodosPago metpago on ord_metpago.metodopagoid = metpago.metodopagoid
	group by 
		metpago.nombre,
		metpago.descripcion
	order by 
		cant_usos desc
	limit 5;
/*
Hecho (medida): 
	count(*) → cantidad de usos por método de pago

Dimensiones:
	metpago.nombre y metpago.descripcion (agrupación por método de pago)
*/


-- 2) ¿Cuál es el monto promedio pagado por método de pago?
	SELECT 
		metpago.nombre, 
		ROUND(AVG(hist_pag.monto), 2) AS monto_promedio
	FROM 
		public.historialpagos hist_pag
	INNER JOIN
		public.metodosPago metpago ON hist_pag.metodopagoid = metpago.metodopagoid
	WHERE 
		hist_pag.estadopago = 'Pagado'
	GROUP BY 
		metpago.nombre;
/*
Hecho (medida): 
	AVG(hist_pag.monto) → monto promedio pagado por método de pago

Dimensiones:
	metpago.nombre (agrupación por método de pago)
	hist_pag.estadopago = 'Pagado' (filtro: solo pagos confirmados)
*/


-- 3) ¿Cuántas órdenes se pagaron usando más de un método de pago?
	SELECT 
		ordenid,
		COUNT(DISTINCT metodopagoid) AS cant_metodos_pago
	FROM 
		public.HistorialPagos
	WHERE
		estadopago = 'Pagado'
	GROUP BY 
		ordenid
	HAVING
		COUNT(DISTINCT metodopagoid) > 1
/*
Hecho (medida): 
	COUNT(DISTINCT metodopagoid) → cantidad de métodos de pago por orden

Dimensiones:
	ordenid (agrupación por orden)
	estadopago = 'Pagado' (filtro: solo pagos confirmados)
*/


-- 4) ¿Cuántos pagos están en estado 'Procesando' o 'Fallido'?
	SELECT 
		count(distinct PagoID)
	FROM 
		public.HistorialPagos
	WHERE
		EstadoPago in ('Procesando','Fallido')
/*
Hecho (medida): 
	count(distinct PagoID) → total de pagos únicos en estado no exitoso

Dimensión:
	EstadoPago (filtro: 'Procesando' o 'Fallido')
*/


-- 5) ¿Cuál es el monto total recaudado por mes?
	SELECT 
		DATE_TRUNC('month', FechaPago) AS Mes,
		SUM(Monto) AS MontoTotal
	FROM 
		public.historialPagos
	WHERE 
		EstadoPago = 'Pagado'
	GROUP BY 
		DATE_TRUNC('month', FechaPago)
/*
Hecho (medida): 
	SUM(Monto) → monto total recaudado por mes

Dimensiones:
	FechaPago truncada al mes (DATE_TRUNC('month', FechaPago)) → agrupación temporal
	EstadoPago = 'Pagado' → filtro por pagos confirmados
*/
-- ===================================== USUARIOS =====================================
-- 1) ¿Cuántos usuarios se registran por mes?
	SELECT 
		DATE_TRUNC('month', FechaRegistro) AS Mes,
		COUNT(*) AS CantidadUsuarios
	FROM 
		public.usuarios
	GROUP BY 
		DATE_TRUNC('month', FechaRegistro);
/*
Hecho (medida): 
	COUNT(*) → cantidad de usuarios registrados por mes

Dimensión:
	FechaRegistro truncada al mes (DATE_TRUNC('month', FechaRegistro)
*/


-- 2) ¿Cuántos usuarios han realizado más de una orden?
	SELECT 
		COUNT(DISTINCT UsuarioID)
	FROM 
		public.ordenes
	GROUP BY 
		UsuarioID
	HAVING 
		COUNT(*) > 1;
/*
Hecho (medida): 
	COUNT(DISTINCT UsuarioID) → total de usuarios con más de una orden

Dimensión:
	UsuarioID (agrupación por usuario)
	HAVING COUNT(*) > 1 (filtro para incluir solo quienes hicieron más de una orden)
*/


-- 3) ¿Cuántos usuarios registrados no han hecho ninguna compra?
	SELECT 
		COUNT(distinct UsuarioID)
	FROM 
		public.usuarios
	WHERE
		UsuarioID NOT IN (SELECT UsuarioID FROM public.ordenes WHERE estado = 'Completado')
/*
Hecho (medida): 
	COUNT(distinct UsuarioID) → cantidad de usuarios sin compras completadas

Dimensión:
	UsuarioID (filtro: excluir los que hicieron órdenes 'Completado')
*/


-- 4) ¿Qué usuarios han gastado más en total?
	SELECT 
		usu.UsuarioID,
		usu.Nombre,
		usu.Apellido,
		SUM(ord.Total) AS total_gastado
	FROM 
		Usuarios usu
	JOIN 
		Ordenes ord ON usu.UsuarioID = ord.UsuarioID
	GROUP BY 
		usu.UsuarioID, usu.Nombre, usu.Apellido
	ORDER BY 
		total_gastado DESC
	LIMIT 5;
/*
Hecho (medida): 
	SUM(ord.Total) → monto total gastado por usuario

Dimensiones:
	UsuarioID, Nombre, Apellido → agrupación por usuario
*/


-- 5) ¿Cuántos usuarios han dejado reseñas?
	SELECT 
		COUNT(DISTINCT UsuarioID)
	FROM 
		public.ReseñasProductos
	WHERE
		comentario IS NOT NULL
/*
Hecho (medida): 
	COUNT(DISTINCT UsuarioID) → cantidad de usuarios que dejaron una reseña

Dimensión:
	UsuarioID (agrupación implícita por usuario)
	Filtro: comentario IS NOT NULL → se considera solo si dejaron un texto
*/
-- ===================================== PRODUCTOS Y STOCK =====================================
-- 1) ¿Qué productos tienen alto stock pero bajas ventas?
	SELECT 
		prod.ProductoID,
		prod.Nombre,
		prod.Stock,
		COALESCE(SUM(det_ord.Cantidad), 0) AS TotalVendido
	FROM 
		Productos prod
	LEFT JOIN 
		DetalleOrdenes det_ord ON prod.ProductoID = det_ord.ProductoID
	GROUP BY 
		prod.ProductoID, prod.Nombre, prod.Stock
	HAVING 
		prod.Stock > 60 AND COALESCE(SUM(det_ord.Cantidad), 0) < 780
		-- Valores arbitrarios tomados por mi
	ORDER BY 
		TotalVendido DESC;
/*
Hechos (medidas):
	prod.Stock → nivel de stock
	SUM(det_ord.Cantidad) → cantidad total vendida por producto

Dimensiones:
	ProductoID, Nombre → agrupación por producto
	Filtros en HAVING: alto stock (>60) y bajas ventas (<780)
*/


-- 2) ¿Cuántos productos están actualmente fuera de stock?
	-- Opcion 1:
		select 
			count(distinct ProductoID) as cant_productos
		from 
			public.Productos
		where 
			stock = 0

	-- Opcion 2:
		SELECT 
			count(distinct carr.ProductoID) as cant_productos,
		FROM 
			public.Productos prod
		RIGHT JOIN
			public.Carrito carr ON prod.ProductoID = carr.ProductoID
		WHERE
			carr.cantidad > prod.Stock
/*
Hecho (medida):
	Opción 1: COUNT(distinct ProductoID) → productos con stock igual a 0
	Opción 2: COUNT(distinct carr.ProductoID) → productos en carrito con demanda mayor al stock

Dimensión:
	ProductoID (agrupación implícita por producto)
	Filtro por condición de stock en cada caso
*/


-- 3) ¿Cuáles son los productos peor calificados?
	SELECT 
		prod.ProductoID,
		prod.Nombre,
		ROUND(AVG(res.Calificacion),2) AS promedio_calificacion
	FROM 
		ReseñasProductos res
	JOIN 
		Productos prod ON res.ProductoID = prod.ProductoID
	GROUP BY 
		prod.ProductoID, prod.Nombre
	HAVING 
		AVG(res.Calificacion) < 3
	ORDER BY 
		promedio_calificacion ASC
	LIMIT 5;
/*
Hecho (medida): 
	AVG(res.Calificacion) → promedio de calificación por producto

Dimensiones:
	ProductoID, Nombre → agrupación por producto
	Filtro: AVG(res.Calificacion) < 3 → solo productos con baja calificación
*/


-- 4) ¿Qué productos tienen mayor cantidad de reseñas?
	SELECT 
		prod.ProductoID,
		prod.Nombre,
		COUNT(distinct res.comentario) as cant_reseñas
	FROM 
		public.reseñasProductos res
	JOIN 
		public.productos prod ON res.ProductoID = prod.ProductoID
	GROUP BY 
		prod.ProductoID, prod.Nombre
	ORDER BY 
		cant_reseñas DESC
	LIMIT 5;
/*
Hecho (medida): 
	COUNT(distinct res.comentario) → cantidad de reseñas por producto

Dimensiones:
	ProductoID, Nombre → agrupación por producto
*/


-- 5) ¿Qué categoría tiene el mayor valor económico vendido (no solo volumen)?
	SELECT 
		c.CategoriaID,
		c.Nombre AS Categoria,
		SUM(d.Cantidad * d.PrecioUnitario) AS total_vendido
	FROM 
		DetalleOrdenes d
	JOIN 
		Productos p ON d.ProductoID = p.ProductoID
	JOIN 
		Categorias c ON p.CategoriaID = c.CategoriaID
	GROUP BY 
		c.CategoriaID, c.Nombre
	ORDER BY 
		total_vendido DESC
	LIMIT 1;
/*
Hecho (medida): 
	SUM(d.Cantidad * d.PrecioUnitario) → valor económico total vendido por categoría

Dimensiones:
	CategoriaID, Nombre → agrupación por categoría
*/