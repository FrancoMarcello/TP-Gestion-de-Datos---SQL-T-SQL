USE GD1C2025;
GO

-- Procedimiento para crear la tabla BI_DIM_TIEMPOS
CREATE OR ALTER PROCEDURE sp_crear_bi_dim_tiempos
AS
BEGIN
    IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SOMOS_QUERY_LORDS.BI_DIM_TIEMPOS') AND type in (N'U'))
    BEGIN
        CREATE TABLE SOMOS_QUERY_LORDS.BI_DIM_TIEMPOS (
            id INT PRIMARY KEY IDENTITY(1,1),  
            anio INT NOT NULL,
            cuatrimestre INT NOT NULL,
            mes INT NOT NULL
			);
    END
END
GO

-- Procedimiento para crear la tabla BI_DIM_UBICACIONES
CREATE OR ALTER PROCEDURE sp_crear_bi_dim_ubicaciones
AS
BEGIN
    IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SOMOS_QUERY_LORDS.BI_DIM_UBICACIONES') AND type in (N'U'))
    BEGIN
        CREATE TABLE SOMOS_QUERY_LORDS.BI_DIM_UBICACIONES (
            id BIGINT IDENTITY(1,1) PRIMARY KEY,
            provincia NVARCHAR(255) NOT NULL,
            localidad NVARCHAR(255) NOT NULL
        );
    END
END
GO




-- Procedimiento para crear la tabla BI_DIM_RANGO_ETARIOS
CREATE OR ALTER PROCEDURE sp_crear_bi_dim_rango_etarios
AS
BEGIN
    IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SOMOS_QUERY_LORDS.BI_DIM_RANGO_ETARIOS') AND type in (N'U'))
    BEGIN
        CREATE TABLE SOMOS_QUERY_LORDS.BI_DIM_RANGO_ETARIOS (
            id BIGINT IDENTITY(1,1) PRIMARY KEY, 
            rango NVARCHAR(255) NOT NULL
        );
    END
END
GO


-- Procedimiento para crear la tabla BI_DIM_ESTADO_PEDIDO
CREATE OR ALTER PROCEDURE sp_crear_bi_dim_estado_pedido
AS
BEGIN
    IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SOMOS_QUERY_LORDS.BI_DIM_ESTADO_PEDIDO') AND type in (N'U'))
    BEGIN
        CREATE TABLE SOMOS_QUERY_LORDS.BI_DIM_ESTADO_PEDIDO (
            id BIGINT IDENTITY(1,1) PRIMARY KEY, 
            estado NVARCHAR(255) NOT NULL
        );
    END
END
GO


-- Procedimiento para crear la tabla BI_DIM_TURNO_VENTAS
CREATE OR ALTER PROCEDURE sp_crear_bi_dim_turno_ventas
AS
BEGIN
    IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SOMOS_QUERY_LORDS.BI_DIM_TURNO_VENTAS') AND type in (N'U'))
    BEGIN
        CREATE TABLE SOMOS_QUERY_LORDS.BI_DIM_TURNO_VENTAS (
            id BIGINT IDENTITY(1,1) PRIMARY KEY, 
            turno NVARCHAR(255) NOT NULL
        );
    END
END
GO


-- Procedimiento para crear la tabla BI_DIM_MODELO_SILLON
CREATE OR ALTER PROCEDURE sp_crear_bi_dim_modelo_sillon
AS
BEGIN
    IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SOMOS_QUERY_LORDS.BI_DIM_MODELO_SILLON') AND type in (N'U'))
    BEGIN
        CREATE TABLE SOMOS_QUERY_LORDS.BI_DIM_MODELO_SILLON (
            id BIGINT IDENTITY(1,1) PRIMARY KEY, 
            modelo NVARCHAR(255) NOT NULL
        );
    END
END
GO

-- Procedimiento para crear la tabla BI_DIM_TIPO_MATERIAL
CREATE OR ALTER PROCEDURE sp_crear_bi_dim_tipo_material
AS
BEGIN
    IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SOMOS_QUERY_LORDS.BI_DIM_TIPO_MATERIAL') AND type in (N'U'))
    BEGIN
        CREATE TABLE SOMOS_QUERY_LORDS.BI_DIM_TIPO_MATERIAL (
            id BIGINT IDENTITY(1,1) PRIMARY KEY, 
            descripcion NVARCHAR(255) NOT NULL
        );
    END
END
GO


-- Procedimiento para crear la tabla BI_DIM_SUCURSAL
CREATE OR ALTER PROCEDURE sp_crear_bi_dim_sucursal
AS
BEGIN
    IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SOMOS_QUERY_LORDS.BI_DIM_SUCURSAL') AND type in (N'U'))
    BEGIN
        CREATE TABLE SOMOS_QUERY_LORDS.BI_DIM_SUCURSAL (
            id BIGINT IDENTITY(1,1) PRIMARY KEY, 
			id_ubicacion BIGINT NOT NULL,
            direccion VARCHAR(255) NOT NULL,
			mail NVARCHAR(255) NOT NULL,
			telefono NVARCHAR(255) NOT NULL,
			CONSTRAINT FK_sucursal_ubicacion_id FOREIGN KEY (id_ubicacion) REFERENCES SOMOS_QUERY_LORDS.BI_DIM_UBICACIONES(id)
        );
    END
END
GO


-- Procedimiento para crear la tabla BI_DIM_CLIENTE
CREATE OR ALTER PROCEDURE sp_crear_bi_dim_cliente
AS
BEGIN
    IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SOMOS_QUERY_LORDS.BI_DIM_CLIENTE') AND type in (N'U'))
    BEGIN
        CREATE TABLE SOMOS_QUERY_LORDS.BI_DIM_CLIENTE (
            id BIGINT IDENTITY(1,1) PRIMARY KEY, 
			id_ubicacion BIGINT NOT NULL,
            dni BIGINT NOT NULL,
			nombre NVARCHAR(255) NOT NULL,
			apellido NVARCHAR(255) NOT NULL,
			fechaNacimiento DATETIME2(6) NOT NULL,
			direccion NVARCHAR(255) NOT NULL,
			mail NVARCHAR(255) NOT NULL,
			telefono NVARCHAR(255) NOT NULL,
			CONSTRAINT FK_cliente_ubicacion_id FOREIGN KEY (id_ubicacion) REFERENCES SOMOS_QUERY_LORDS.BI_DIM_UBICACIONES(id)
        );
    END
END 
GO


-- Procedimiendo para crear tabla BI_HECHOS_VENTAS
CREATE OR ALTER PROCEDURE sp_crear_bi_hecho_ventas
AS
BEGIN
    IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SOMOS_QUERY_LORDS.bi_hecho_ventas') AND type = 'U')
    BEGIN
        CREATE TABLE SOMOS_QUERY_LORDS.bi_hecho_ventas (
            id BIGINT IDENTITY(1,1) PRIMARY KEY,

			id_ubicacion BIGINT NOT NULL,
			id_rango_etario BIGINT NOT NULL,
            id_tiempo INT NOT NULL,
            id_cliente BIGINT NOT NULL,
            id_sucursal BIGINT NOT NULL,
            id_turno BIGINT NOT NULL,
            id_modelo_sillon BIGINT NOT NULL,        

            total DECIMAL(18,2) NOT NULL,
			tiempo_fabricacion DECIMAL(18,2) NOT NULL,

			CONSTRAINT FK_hecho_venta_ubicacion_id FOREIGN KEY (id_ubicacion) REFERENCES SOMOS_QUERY_LORDS.BI_DIM_UBICACIONES(id),
			CONSTRAINT FK_hecho_venta_rango_etario_id FOREIGN KEY (id_rango_etario) REFERENCES SOMOS_QUERY_LORDS.BI_DIM_RANGO_ETARIOS(id),
            CONSTRAINT FK_hecho_venta_tiempo_id FOREIGN KEY (id_tiempo) REFERENCES SOMOS_QUERY_LORDS.BI_DIM_TIEMPOS(id),
            CONSTRAINT FK_hecho_venta_cliente_id FOREIGN KEY (id_cliente) REFERENCES SOMOS_QUERY_LORDS.BI_DIM_CLIENTE(id),
            CONSTRAINT FK_hecho_venta_sucursal_id FOREIGN KEY (id_sucursal) REFERENCES SOMOS_QUERY_LORDS.BI_DIM_SUCURSAL(id),
            CONSTRAINT FK_hecho_venta_turno_id FOREIGN KEY (id_turno) REFERENCES SOMOS_QUERY_LORDS.BI_DIM_TURNO_VENTAS(id),
            CONSTRAINT FK_hecho_venta_modelo_id FOREIGN KEY (id_modelo_sillon) REFERENCES SOMOS_QUERY_LORDS.BI_DIM_MODELO_SILLON(id),
        );
    END
END
GO


-- Procedimiendo para crear tabla BI_HECHOS_PEDIDOS
CREATE OR ALTER PROCEDURE sp_crear_bi_hecho_pedidos
AS
BEGIN
    IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SOMOS_QUERY_LORDS.BI_HECHO_PEDIDOS') AND type = 'U')
    BEGIN
        CREATE TABLE SOMOS_QUERY_LORDS.BI_HECHO_PEDIDOS (
            id BIGINT IDENTITY(1,1) PRIMARY KEY,

            id_ubicacion BIGINT NOT NULL,
            id_estado_pedido BIGINT NOT NULL,
            id_tiempo INT NOT NULL,
            id_modelo_sillon BIGINT NOT NULL,
            id_rango_etario BIGINT NOT NULL,
            id_sucursal BIGINT NOT NULL,
            id_cliente BIGINT NOT NULL,
			id_turno BIGINT NOT NULL,

            cantidad INT NOT NULL,

            CONSTRAINT FK_hecho_pedidos_ubicacion FOREIGN KEY (id_ubicacion) REFERENCES SOMOS_QUERY_LORDS.BI_DIM_UBICACIONES(id),
            CONSTRAINT FK_hecho_pedidos_estado FOREIGN KEY (id_estado_pedido) REFERENCES SOMOS_QUERY_LORDS.BI_DIM_ESTADO_PEDIDO(id),
            CONSTRAINT FK_hecho_pedidos_tiempo FOREIGN KEY (id_tiempo) REFERENCES SOMOS_QUERY_LORDS.BI_DIM_TIEMPOS(id),
            CONSTRAINT FK_hecho_pedidos_modelo FOREIGN KEY (id_modelo_sillon) REFERENCES SOMOS_QUERY_LORDS.BI_DIM_MODELO_SILLON(id),
            CONSTRAINT FK_hecho_pedidos_rango FOREIGN KEY (id_rango_etario) REFERENCES SOMOS_QUERY_LORDS.BI_DIM_RANGO_ETARIOS(id),
            CONSTRAINT FK_hecho_pedidos_sucursal FOREIGN KEY (id_sucursal) REFERENCES SOMOS_QUERY_LORDS.BI_DIM_SUCURSAL(id),
            CONSTRAINT FK_hecho_pedidos_cliente FOREIGN KEY (id_cliente) REFERENCES SOMOS_QUERY_LORDS.BI_DIM_CLIENTE(id),
            CONSTRAINT FK_hecho_pedidos_turno FOREIGN KEY (id_turno) REFERENCES SOMOS_QUERY_LORDS.BI_DIM_TURNO_VENTAS(id)
        );
    END
END
GO


-- Procedimiendo para crear tabla BI_HECHOS_COMPRAS
CREATE OR ALTER PROCEDURE sp_crear_bi_hecho_compras
AS
BEGIN
    IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SOMOS_QUERY_LORDS.BI_HECHO_COMPRAS') AND type = 'U')
    BEGIN
        CREATE TABLE SOMOS_QUERY_LORDS.BI_HECHO_COMPRAS (
            id BIGINT IDENTITY(1,1) PRIMARY KEY,

            id_ubicacion BIGINT NOT NULL,
            id_tipo_material BIGINT NOT NULL,
            id_tiempo INT NOT NULL,
            id_sucursal BIGINT NOT NULL,

            total_compra DECIMAL(18,2) NOT NULL,

            CONSTRAINT FK_hecho_compras_ubicacion FOREIGN KEY (id_ubicacion) REFERENCES SOMOS_QUERY_LORDS.BI_DIM_UBICACIONES(id),
            CONSTRAINT FK_hecho_compras_material FOREIGN KEY (id_tipo_material) REFERENCES SOMOS_QUERY_LORDS.BI_DIM_TIPO_MATERIAL(id),
            CONSTRAINT FK_hecho_compras_tiempo FOREIGN KEY (id_tiempo) REFERENCES SOMOS_QUERY_LORDS.BI_DIM_TIEMPOS(id),
            CONSTRAINT FK_hecho_compras_sucursal FOREIGN KEY (id_sucursal) REFERENCES SOMOS_QUERY_LORDS.BI_DIM_SUCURSAL(id)
        );
    END
END
GO


-- Procedimiendo para crear tabla BI_HECHOS_ENVIOS

CREATE OR ALTER PROCEDURE sp_crear_bi_hecho_envios
AS
BEGIN
    IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SOMOS_QUERY_LORDS.BI_HECHO_ENVIOS') AND type = 'U')
    BEGIN
        CREATE TABLE SOMOS_QUERY_LORDS.BI_HECHO_ENVIOS (
            id BIGINT IDENTITY(1,1) PRIMARY KEY,

            id_ubicacion BIGINT NOT NULL,
            id_tiempo_programada INT NOT NULL,
            id_tiempo_entrega INT NOT NULL,
            id_cliente BIGINT NOT NULL,

            total_monto_envio DECIMAL(18,2) NOT NULL,
			total_cantidad_envio INT NOT NULL,
			envio_cumplido INT NOT NULL

            CONSTRAINT FK_hecho_envios_ubicacion FOREIGN KEY (id_ubicacion) REFERENCES SOMOS_QUERY_LORDS.BI_DIM_UBICACIONES(id),
            CONSTRAINT FK_hecho_envios_tiempo_prog FOREIGN KEY (id_tiempo_programada) REFERENCES SOMOS_QUERY_LORDS.BI_DIM_TIEMPOS(id),
            CONSTRAINT FK_hecho_envios_tiempo_entrega FOREIGN KEY (id_tiempo_entrega) REFERENCES SOMOS_QUERY_LORDS.BI_DIM_TIEMPOS(id),
            CONSTRAINT FK_hecho_envios_cliente FOREIGN KEY (id_cliente) REFERENCES SOMOS_QUERY_LORDS.BI_DIM_CLIENTE(id)
        );
    END
END
GO

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Procedimiento para insertar datos en BI_DIM_TIEMPO
CREATE OR ALTER PROCEDURE sp_generar_dim_tiempo
AS
BEGIN    
    DELETE FROM SOMOS_QUERY_LORDS.BI_DIM_TIEMPOS;
	DECLARE @AnioInicio INT, @AnioFin INT
	SET @AnioInicio = (select min(year(fechaHora)) from SOMOS_QUERY_LORDS.FACTURA)
	SET @AnioFin = (select MAX(year(fechaHora)) from SOMOS_QUERY_LORDS.FACTURA)
    DECLARE @Fecha DATE = CAST(@AnioInicio AS NVARCHAR) + '-01-01';
    WHILE YEAR(@Fecha) <= @AnioFin
    BEGIN
        INSERT INTO SOMOS_QUERY_LORDS.BI_DIM_TIEMPOS (anio, cuatrimestre, mes)
        VALUES (
            YEAR(@Fecha),
            CEILING(MONTH(@Fecha) / 4.0),
            MONTH(@Fecha)
        );

        SET @Fecha = DATEADD(MONTH, 1, @Fecha);
    END;
END
GO

-- Procedimiento para insertar datos en BI_DIM_UBICACIONES
CREATE OR ALTER PROCEDURE sp_insertar_bi_dim_ubicaciones
AS
BEGIN	
	INSERT INTO SOMOS_QUERY_LORDS.BI_DIM_UBICACIONES(provincia, localidad)
	SELECT DISTINCT p.nombre, l.nombre from SOMOS_QUERY_LORDS.PROVINCIA p
	left join SOMOS_QUERY_LORDS.LOCALIDAD l on l.provincia_id = p.id
END
GO

-- Procedimiento para insertar datos en BI_DIM_RANGO_ETARIOS
CREATE OR ALTER PROCEDURE sp_insertar_bi_dim_rango_etarios
AS
BEGIN
    -- Inserta rangos etarios predefinidos en la tabla BI_DIM_RANGO_ETARIOS
    INSERT INTO SOMOS_QUERY_LORDS.BI_DIM_RANGO_ETARIOS(rango)
    VALUES
    ('<25'),           -- Menos de 25
    ('25-35'),        -- Entre 25 y 35
    ('35-50'),        -- Entre 36 y 50
    ('>50');          -- Más de 50
END
GO

-- Función para obtener ID de rango etario según @fecha_de_nacimiento
CREATE OR ALTER FUNCTION SOMOS_QUERY_LORDS.ObtenerIdRangoEtario (@fecha_de_nacimiento DATE)
RETURNS NVARCHAR(255)
AS
BEGIN
    DECLARE @edad INT
    DECLARE @id INT

    -- Calcular la edad
    SET @edad = DATEDIFF(YEAR, @fecha_de_nacimiento, GETDATE())
                - CASE
                    WHEN MONTH(@fecha_de_nacimiento) > MONTH(GETDATE()) OR
                         (MONTH(@fecha_de_nacimiento) = MONTH(GETDATE()) AND DAY(@fecha_de_nacimiento) > DAY(GETDATE()))
                    THEN 1
                    ELSE 0
                  END

    -- Obtener el ID segun el rango etario
    IF @edad < 25
        SELECT @id = id
        FROM SOMOS_QUERY_LORDS.BI_DIM_RANGO_ETARIOS
        WHERE rango = '<25'
    ELSE IF @edad BETWEEN 25 AND 35
        SELECT @id = id
        FROM SOMOS_QUERY_LORDS.BI_DIM_RANGO_ETARIOS
        WHERE rango = '25-35'
    ELSE IF @edad BETWEEN 36 AND 50
        SELECT @id = id
        FROM SOMOS_QUERY_LORDS.BI_DIM_RANGO_ETARIOS
        WHERE rango = '35-50'
    ELSE
        SELECT @id = id
        FROM SOMOS_QUERY_LORDS.BI_DIM_RANGO_ETARIOS
        WHERE rango = '>50'

    RETURN @id
END
GO


-- Procedimiento para insertar datos en BI_DIM_ESTADO_PEDIDO
CREATE OR ALTER PROCEDURE sp_insertar_bi_dim_estado_pedido
AS
BEGIN
    INSERT INTO SOMOS_QUERY_LORDS.BI_DIM_ESTADO_PEDIDO (estado)
    SELECT DISTINCT estado
    FROM SOMOS_QUERY_LORDS.PEDIDO;
END
GO

-- Procedimiento para insertar datos en BI_DIM_TURNO_VENTAS
CREATE OR ALTER PROCEDURE sp_insertar_bi_dim_turno_ventas
AS
BEGIN
    DELETE FROM SOMOS_QUERY_LORDS.BI_DIM_TURNO_VENTAS; -- opcional si querés limpiar antes

    INSERT INTO SOMOS_QUERY_LORDS.BI_DIM_TURNO_VENTAS (turno)
    VALUES
        ('08:00 - 14:00'),  -- 08:00 a 14:00
        ('14:00 - 20:00');   -- 14:00 a 20:00
END
GO

CREATE OR ALTER FUNCTION SOMOS_QUERY_LORDS.ObtenerIdTurno (@hora TIME)
RETURNS BIGINT
AS
BEGIN
    DECLARE @turno NVARCHAR(255)
    DECLARE @id BIGINT

    IF @hora >= '08:00' AND @hora < '14:00'
        SET @turno = '08:00 - 14:00'
    ELSE IF @hora >= '14:00' AND @hora < '20:00'
        SET @turno = '14:00 - 20:00'
    ELSE
        SET @turno = NULL  -- Fuera de horario de ventas

    SELECT @id = id
    FROM SOMOS_QUERY_LORDS.BI_DIM_TURNO_VENTAS
    WHERE turno = @turno

    RETURN @id
END
GO


-- Procedimiento para insertar datos en BI_DIM_MODELO_SILLON
CREATE OR ALTER PROCEDURE sp_insertar_bi_dim_modelo_sillon
AS
BEGIN
    INSERT INTO SOMOS_QUERY_LORDS.BI_DIM_MODELO_SILLON (modelo)
    SELECT DISTINCT nombre
    FROM SOMOS_QUERY_LORDS.MODELO;
END
GO


-- Procedimiento para insertar datos en BI_DIM_TIPO_MATERIAL
CREATE OR ALTER PROCEDURE sp_insertar_bi_dim_tipo_material
AS
BEGIN
    INSERT INTO SOMOS_QUERY_LORDS.BI_DIM_TIPO_MATERIAL (descripcion)
    SELECT DISTINCT tipo 
	FROM SOMOS_QUERY_LORDS.MATERIAL;
END
GO


-- Procedimiento para insertar datos en BI_DIM_CLIENTE
CREATE OR ALTER PROCEDURE sp_insertar_bi_dim_cliente
AS
BEGIN
    INSERT INTO SOMOS_QUERY_LORDS.BI_DIM_CLIENTE (id_ubicacion, dni, nombre, apellido, fechaNacimiento, direccion, mail, telefono)
    SELECT DISTINCT
        ubi.id,
        c.dni,
        c.nombre,
        c.apellido,
        c.fechaNacimiento,
        c.direccion,
        c.mail,
        c.telefono
    FROM SOMOS_QUERY_LORDS.CLIENTE c
    INNER JOIN SOMOS_QUERY_LORDS.LOCALIDAD l ON l.id = c.localidad_id
	INNER JOIN SOMOS_QUERY_LORDS.PROVINCIA p ON p.id = l.provincia_id
    INNER JOIN SOMOS_QUERY_LORDS.BI_DIM_UBICACIONES ubi ON ubi.provincia = p.nombre AND ubi.localidad = l.nombre;
END
GO


-- Procedimiento para insertar datos en BI_DIM_SUCURSAL
CREATE OR ALTER PROCEDURE sp_insertar_bi_dim_sucursal
AS
BEGIN
    INSERT INTO SOMOS_QUERY_LORDS.BI_DIM_SUCURSAL (id_ubicacion, direccion, mail, telefono)
    SELECT DISTINCT
        ubi.id,
        s.direccion,
        s.mail,
        s.telefono
    FROM SOMOS_QUERY_LORDS.SUCURSAL s
    INNER JOIN SOMOS_QUERY_LORDS.LOCALIDAD l ON l.id = s.localidad_id
	INNER JOIN SOMOS_QUERY_LORDS.PROVINCIA p ON p.id = l.provincia_id
    INNER JOIN SOMOS_QUERY_LORDS.BI_DIM_UBICACIONES ubi ON ubi.provincia = p.nombre AND ubi.localidad = l.nombre;
END
GO

CREATE OR ALTER PROCEDURE sp_insertar_bi_hecho_pedidos
AS
BEGIN
    INSERT INTO SOMOS_QUERY_LORDS.BI_HECHO_PEDIDOS (id_ubicacion, id_estado_pedido, id_tiempo, id_modelo_sillon,id_rango_etario,id_sucursal,
	id_cliente,id_turno,cantidad)  
    SELECT DISTINCT
        ubi.id, 
        ep.id, 
		ti.id,
        mbi.id, 
		re.id,
		sbi.id,
		cbi.id,
		tu.id,
		count(p.id)

    FROM SOMOS_QUERY_LORDS.PEDIDO p
	INNER JOIN SOMOS_QUERY_LORDS.BI_DIM_ESTADO_PEDIDO ep ON ep.estado = p.estado	
	/*ubicacion*/
	INNER JOIN SOMOS_QUERY_LORDS.SUCURSAL s on s.id = p.sucursal_id
	INNER JOIN SOMOS_QUERY_LORDS.LOCALIDAD l on l.id = s.localidad_id
    INNER JOIN SOMOS_QUERY_LORDS.PROVINCIA prov ON l.provincia_id = prov.id
    INNER JOIN SOMOS_QUERY_LORDS.BI_DIM_UBICACIONES ubi ON ubi.provincia = prov.nombre AND ubi.localidad = l.nombre
	/*RELACION MODELO*/
	INNER JOIN SOMOS_QUERY_LORDS.SILLONES_POR_PEDIDO sp on sp.pedido_id = p.id
	INNER JOIN SOMOS_QUERY_LORDS.SILLON si on si.id = sp.sillon_id 
	INNER JOIN SOMOS_QUERY_LORDS.MODELO m on m.id = si.modelo_id
    INNER JOIN SOMOS_QUERY_LORDS.BI_DIM_MODELO_SILLON mbi ON mbi.modelo = m.nombre

	INNER JOIN SOMOS_QUERY_LORDS.CLIENTE c on c.id = p.cliente_id
	INNER JOIN SOMOS_QUERY_LORDS.BI_DIM_CLIENTE cbi on cbi.dni = c.dni 
	INNER JOIN SOMOS_QUERY_LORDS.BI_DIM_RANGO_ETARIOS re on re.id = SOMOS_QUERY_LORDS.ObtenerIdRangoEtario(c.fechaNacimiento)
	
	INNER JOIN SOMOS_QUERY_LORDS.BI_DIM_SUCURSAL sbi on sbi.direccion = s.direccion

	INNER JOIN SOMOS_QUERY_LORDS.BI_DIM_TURNO_VENTAS  tu on tu.id = SOMOS_QUERY_LORDS.ObtenerIdTurno(CAST(p.fechaHora AS TIME))
	
	/*tiempos*/
	INNER JOIN SOMOS_QUERY_LORDS.BI_DIM_TIEMPOS ti ON
        ti.anio = year(p.fechaHora) and
        ti.mes = month(p.fechaHora) and
        ti.cuatrimestre = CEILING(MONTH(p.fechaHora) / 4.0)

	GROUP BY
	ubi.id, 
        ep.id, 
        ti.id,
        mbi.id, 
		re.id,
		sbi.id,
		cbi.id,
		tu.id
END
GO

CREATE OR ALTER PROCEDURE sp_insertar_bi_hecho_envios
AS
BEGIN
    INSERT INTO SOMOS_QUERY_LORDS.BI_HECHO_ENVIOS (id_ubicacion, id_tiempo_programada, id_tiempo_entrega, id_cliente, total_monto_envio,
			total_cantidad_envio, envio_cumplido)  	
    SELECT DISTINCT
		ubi.id,
        tp.id, 
        te.id, 
		cbi.id,		
		sum(cast(e.total as decimal(12,2))), -- monto TOTAL DE ENVIOS	
		count(e.id),
		(case when DATEDIFF(DAY, e.fechaProgramada, e.fechaEntrega) <= 0 then 1 else 0 end)
    FROM SOMOS_QUERY_LORDS.ENVIO e		
	INNER JOIN SOMOS_QUERY_LORDS.FACTURA f on e.factura_id = f.id
	INNER JOIN SOMOS_QUERY_LORDS.CLIENTE c on c.id = f.cliente_id
	INNER JOIN SOMOS_QUERY_LORDS.BI_DIM_CLIENTE cbi on cbi.dni = c.dni
	INNER JOIN SOMOS_QUERY_LORDS.BI_DIM_UBICACIONES ubi ON cbi.id_ubicacion = ubi.id
	INNER JOIN SOMOS_QUERY_LORDS.BI_DIM_TIEMPOS tp ON
        tp.anio = year(e.fechaEntrega) and
        tp.mes = month(e.fechaEntrega) and
        tp.cuatrimestre = CEILING(MONTH(e.fechaEntrega) / 4.0)
	INNER JOIN SOMOS_QUERY_LORDS.BI_DIM_TIEMPOS te ON
        te.anio = year(e.fechaProgramada) and
        te.mes = month(e.fechaProgramada) and
        te.cuatrimestre = CEILING(MONTH(e.fechaProgramada) / 4.0)
	GROUP BY
		ubi.id,
		tp.id, 
        te.id, 
		cbi.id, 
		e.fechaProgramada,
		e.fechaEntrega
END
GO
CREATE OR ALTER PROCEDURE sp_insertar_bi_hecho_ventas
AS
BEGIN
    INSERT INTO SOMOS_QUERY_LORDS.bi_hecho_ventas (id_ubicacion,id_rango_etario,id_tiempo, id_cliente,  id_sucursal,
	id_turno, id_modelo_sillon, total, tiempo_fabricacion)  
 
    SELECT DISTINCT        
		ubi.id, 
		re.id,
        ti.id,
		cbi.id,
		sbi.id,
		tu.id,
        mbi.id, 
		sum(f.total),
		DATEDIFF(HOUR, p.fechaHora, f.fechaHora)

    FROM SOMOS_QUERY_LORDS.FACTURA f	
	/*ubicacion*/
	INNER JOIN SOMOS_QUERY_LORDS.SUCURSAL s on s.id = f.sucursal_id
	INNER JOIN SOMOS_QUERY_LORDS.LOCALIDAD l on l.id = s.localidad_id
    INNER JOIN SOMOS_QUERY_LORDS.PROVINCIA prov ON l.provincia_id = prov.id
    INNER JOIN SOMOS_QUERY_LORDS.BI_DIM_UBICACIONES ubi ON ubi.provincia = prov.nombre AND ubi.localidad = l.nombre
	/*RELACION MODELO*/
	INNER JOIN SOMOS_QUERY_LORDS.PEDIDO p ON f.pedido_id = p.id
	INNER JOIN SOMOS_QUERY_LORDS.SILLONES_POR_PEDIDO sp on sp.pedido_id = p.id
	INNER JOIN SOMOS_QUERY_LORDS.SILLON si on si.id = sp.sillon_id 
	INNER JOIN SOMOS_QUERY_LORDS.MODELO m on m.id = si.modelo_id
    INNER JOIN SOMOS_QUERY_LORDS.BI_DIM_MODELO_SILLON mbi ON mbi.modelo = m.nombre

	INNER JOIN SOMOS_QUERY_LORDS.CLIENTE c on c.id = f.cliente_id
	INNER JOIN SOMOS_QUERY_LORDS.BI_DIM_CLIENTE cbi on cbi.dni = c.dni 
	INNER JOIN SOMOS_QUERY_LORDS.BI_DIM_RANGO_ETARIOS re on re.id = SOMOS_QUERY_LORDS.ObtenerIdRangoEtario(c.fechaNacimiento)
	
	INNER JOIN SOMOS_QUERY_LORDS.BI_DIM_SUCURSAL sbi on sbi.direccion = s.direccion

	INNER JOIN SOMOS_QUERY_LORDS.BI_DIM_TURNO_VENTAS tu on tu.id = SOMOS_QUERY_LORDS.ObtenerIdTurno(CAST(f.fechaHora AS TIME))
	
	/*tiempos*/
	INNER JOIN SOMOS_QUERY_LORDS.BI_DIM_TIEMPOS ti ON
        ti.anio = year(f.fechaHora) and
        ti.mes = month(f.fechaHora) and
        ti.cuatrimestre = CEILING(MONTH(f.fechaHora) / 4.0)	
		GROUP BY
		ubi.id, 
		re.id,
        ti.id,
		cbi.id,
		sbi.id,
		tu.id,
        mbi.id,
		p.fechaHora,
		f.fechaHora
END
GO

CREATE OR ALTER PROCEDURE sp_insertar_bi_hecho_compras
AS
BEGIN
    -- Inserta datos en BI_HECHO_COMPRAS una vez procesados desde otras tablas
    INSERT INTO SOMOS_QUERY_LORDS.BI_HECHO_COMPRAS (id_ubicacion, id_tipo_material, id_tiempo, id_sucursal, total_compra)
    SELECT
        bdu.id,--ok                                     -- ID del ubicacion
		bdtm.id,     --ok                                  -- ID de la tipo material
        bdt.id,    --ok                           -- ID de dimensión de tiempo
        bds.id,       --ok                            -- ID de dimensión de sucursal
        sum(c.total) as total_compra

    FROM SOMOS_QUERY_LORDS.COMPRA c
    INNER JOIN SOMOS_QUERY_LORDS.SUCURSAL s ON s.id = c.sucursal_id
    INNER JOIN SOMOS_QUERY_LORDS.BI_DIM_SUCURSAL bds ON bds.direccion = s.direccion    
    INNER JOIN SOMOS_QUERY_LORDS.LOCALIDAD l ON l.id = s.localidad_id
    INNER JOIN SOMOS_QUERY_LORDS.PROVINCIA prov ON l.provincia_id = prov.id
    INNER JOIN SOMOS_QUERY_LORDS.BI_DIM_UBICACIONES bdu ON bdu.provincia = prov.nombre AND bdu.localidad = l.nombre
    INNER JOIN SOMOS_QUERY_LORDS.MATERIALES_POR_COMPRA mpc ON mpc.compra_id = c.id
    INNER JOIN SOMOS_QUERY_LORDS.MATERIAL m ON mpc.material_id = m.id
    INNER JOIN SOMOS_QUERY_LORDS.BI_DIM_TIPO_MATERIAL bdtm ON bdtm.descripcion = m.tipo
    INNER JOIN SOMOS_QUERY_LORDS.BI_DIM_TIEMPOS bdt ON -- Une dimensiones de tiempo
        bdt.anio = year(c.fecha) and
        bdt.mes = month(c.fecha) and
        bdt.cuatrimestre = CEILING(MONTH(c.fecha) / 4.0)
    GROUP BY
        bdu.id, --ok                                     -- ID del ubicacion
        bdtm.id,     --ok                                  -- ID de la tipo material
        bdt.id,    --ok                           -- ID de dimensión de tiempo
        bds.id;
END
GO

EXEC sp_crear_bi_dim_ubicaciones;
EXEC sp_crear_bi_dim_turno_ventas;
EXEC sp_crear_bi_dim_tiempos;
EXEC sp_crear_bi_dim_sucursal;
EXEC sp_crear_bi_dim_rango_etarios;
EXEC sp_crear_bi_dim_modelo_sillon;
EXEC sp_crear_bi_dim_estado_pedido;
EXEC sp_crear_bi_dim_cliente;
EXEC sp_crear_bi_dim_tipo_material;
EXEC sp_crear_bi_hecho_pedidos;
EXEC sp_crear_bi_hecho_compras;
EXEC sp_crear_bi_hecho_envios;
EXEC sp_crear_bi_hecho_ventas;
GO

EXEC sp_insertar_bi_dim_ubicaciones;
EXEC sp_insertar_bi_dim_turno_ventas;
EXEC sp_generar_dim_tiempo;
EXEC sp_insertar_bi_dim_rango_etarios;
EXEC sp_insertar_bi_dim_estado_pedido;
EXEC sp_insertar_bi_dim_modelo_sillon;
EXEC sp_insertar_bi_dim_tipo_material;
EXEC sp_insertar_bi_dim_cliente;
EXEC sp_insertar_bi_dim_sucursal;
EXEC sp_insertar_bi_hecho_pedidos;
EXEC sp_insertar_bi_hecho_compras;
EXEC sp_insertar_bi_hecho_envios;
EXEC sp_insertar_bi_hecho_ventas;
GO
--VISTAS
-- 1 
GO
CREATE OR ALTER VIEW v_ganancias_mensuales_sucursal
AS
SELECT
    t.anio,
    t.mes,
    s.id as id_sucursal,
    SUM(isnull(v.total,0)) - SUM(isnull(c.total_compra,0)) AS ganancia
	FROM SOMOS_QUERY_LORDS.BI_DIM_TIEMPOS t
	JOIN SOMOS_QUERY_LORDS.bi_hecho_ventas v ON v.id_tiempo = t.id
	JOIN SOMOS_QUERY_LORDS.BI_HECHO_COMPRAS c ON c.id_tiempo = t.id and v.id_sucursal = c.id_sucursal
	JOIN SOMOS_QUERY_LORDS.BI_DIM_SUCURSAL s ON s.id = v.id_sucursal
	group by t.anio , t.mes, s.id;
GO

-- 2 Factura promedio mensual

GO
CREATE OR ALTER VIEW v_fact_prom_mensual
AS
SELECT
    t.anio,
    t.cuatrimestre,
    u.provincia,
    isNull(AVG(v.total),0) AS prom_fact
FROM SOMOS_QUERY_LORDS.BI_DIM_sucursal s
JOIN SOMOS_QUERY_LORDS.BI_DIM_ubicaciones u ON u.id = s.id_ubicacion
LEFT JOIN SOMOS_QUERY_LORDS.bi_hecho_ventas v ON v.id_sucursal = s.id
LEFT JOIN SOMOS_QUERY_LORDS.BI_DIM_tiempos t ON t.id = v.id_tiempo

GROUP BY t.anio, t.cuatrimestre, u.provincia;
GO

-- 3
GO
CREATE OR ALTER VIEW v_rendimiento_modelos
AS
    WITH rank_vtas_modelos_x_tiempo AS (
        select 
            ROW_NUMBER() OVER(PARTITION BY t.anio, t.cuatrimestre, u.localidad, re.rango ORDER BY t.anio DESC, t.cuatrimestre DESC, u.localidad, re.rango, count(*) DESC) AS nro_fila,
            v.id_modelo_sillon,
            t.anio,
            t.cuatrimestre,
            u.localidad,
            re.rango,
            count(*) AS cant_vtas
        from 
             SOMOS_QUERY_LORDS.bi_hecho_ventas v 
        JOIN SOMOS_QUERY_LORDS.BI_DIM_tiempos t ON t.id = v.id_tiempo
        JOIN SOMOS_QUERY_LORDS.BI_DIM_ubicaciones u ON u.id = v.id_ubicacion
        JOIN SOMOS_QUERY_LORDS.BI_DIM_rango_etarios re ON re.id = v.id_rango_etario
        group by
            v.id_modelo_sillon, t.anio, t.cuatrimestre, u.localidad, re.rango
    )
    SELECT rk.id_modelo_sillon, rk.anio, rk.cuatrimestre, rk.localidad, rk.rango, rk.cant_vtas FROM rank_vtas_modelos_x_tiempo rk
    WHERE rk.nro_fila <= 3
; 
GO

--4
GO

CREATE OR ALTER VIEW v_vol_pedidos
AS
SELECT
		tu.turno, su.direccion as sucursal, ti.anio, ti.mes, count(*) as cantidad_pedidos  from SOMOS_QUERY_LORDS.BI_HECHO_PEDIDOS hp
		join SOMOS_QUERY_LORDS.BI_DIM_TURNO_VENTAS tu on tu.id = hp.id_turno
		join SOMOS_QUERY_LORDS.BI_DIM_SUCURSAL su on su.id = hp.id_sucursal
		join SOMOS_QUERY_LORDS.BI_DIM_TIEMPOS ti on ti.id = hp.id_tiempo
		group by tu.turno, su.direccion,ti.anio, ti.mes ;
GO

-- 5
GO
CREATE OR ALTER VIEW v_conversion_pedidos
AS
SELECT 
    t.cuatrimestre,
    s.id,
    CAST(
        (select CAST(COUNT(*) AS DECIMAL(10,2)) from SOMOS_QUERY_LORDS.BI_HECHO_PEDIDOS p2
            join SOMOS_QUERY_LORDS.BI_Dim_Tiempos ti on ti.id = p2.id_tiempo
            where p2.id_estado_pedido = 1 
                and ti.cuatrimestre = t.cuatrimestre 
                and p2.id_sucursal = s.id
        ) * 100 / CAST(COUNT(*) AS DECIMAL(10,2))
    AS DECIMAL(10,2)
    ) as [pedidos entregados(%)],

    CAST(
        (select CAST(COUNT(*) AS DECIMAL(10,2)) from SOMOS_QUERY_LORDS.BI_HECHO_PEDIDOS p3
            join SOMOS_QUERY_LORDS.BI_Dim_Tiempos ti2 on ti2.id = p3.id_tiempo
            where p3.id_estado_pedido = 2 
            and ti2.cuatrimestre = t.cuatrimestre 
            and p3.id_sucursal = s.id
        ) * 100 / CAST(COUNT(*) AS DECIMAL(10,2))
    AS DECIMAL(10,2)
    ) as [pedidos cancelados (%)]
FROM
     SOMOS_QUERY_LORDS.BI_HECHO_PEDIDOS p
join SOMOS_QUERY_LORDS.BI_Dim_Estado_pedido ep on ep.id = p.id_estado_pedido
join SOMOS_QUERY_LORDS.BI_Dim_sucursal s on s.id = p.id_sucursal
join SOMOS_QUERY_LORDS.BI_Dim_Tiempos t on t.id = p.id_tiempo
GROUP BY t.cuatrimestre, s.id;
GO

--6
GO
CREATE OR ALTER VIEW v_promedio_fabricacion
AS
SELECT hv.id_sucursal , avg(hv.tiempo_fabricacion) as tiempo_promedio, ti.cuatrimestre from SOMOS_QUERY_LORDS.BI_HECHO_VENTAS hv
JOIN SOMOS_QUERY_LORDS.BI_DIM_TIEMPOS ti ON ti.id = hv.id_tiempo
GROUP BY  hv.id_sucursal,ti.cuatrimestre;
GO

-- 7 
GO
CREATE OR ALTER VIEW v_promedio_compras_mensual AS
SELECT
    t.anio,
    t.mes,
    avg(c.total_compra) AS promedio_mensual
FROM SOMOS_QUERY_LORDS.BI_HECHO_COMPRAS c
join SOMOS_QUERY_LORDS.BI_DIM_TIEMPOS t ON t.id = c.id_tiempo
group by t.anio, t.mes
;
GO

--8
GO
CREATE OR ALTER VIEW v_compras_tipo_material 
AS
SELECT
    t.anio,
    t.cuatrimestre,
    s.id AS id_sucursal,
    tm.descripcion AS tipo_material,
    sum(c.total_compra) AS total_compra
	FROM SOMOS_QUERY_LORDS.BI_HECHO_COMPRAS c
	JOIN SOMOS_QUERY_LORDS.BI_DIM_TIEMPOS t ON t.id = c.id_tiempo
	JOIN SOMOS_QUERY_LORDS.BI_DIM_SUCURSAL s ON s.id = c.id_sucursal
	JOIN SOMOS_QUERY_LORDS.BI_DIM_TIPO_MATERIAL tm ON tm.id = c.id_tipo_material
	GROUP BY t.anio, t.cuatrimestre, s.id, tm.descripcion
;
GO

--9
GO

CREATE OR ALTER VIEW v_cumplimiento_envios 
AS
SELECT tp.mes, (sum(he.envio_cumplido) * 100/ sum(he.total_cantidad_envio) ) AS 'cumplimiento%' from SOMOS_QUERY_LORDS.BI_HECHO_ENVIOS he
JOIN SOMOS_QUERY_LORDS.BI_DIM_TIEMPOS tp on he.id_tiempo_programada = tp.id
JOIN SOMOS_QUERY_LORDS.BI_DIM_TIEMPOS te on he.id_tiempo_entrega = te.id
GROUP BY tp.mes

GO

--10 
GO

CREATE OR ALTER VIEW v_localidades_costo_envios 
AS
	SELECT ubi.localidad, avg(he.total_monto_envio) as promedio_costo_envio FROM SOMOS_QUERY_LORDS.BI_HECHO_ENVIOS he
	JOIN SOMOS_QUERY_LORDS.BI_DIM_UBICACIONES ubi on ubi.id = he.id_ubicacion
	WHERE ubi.localidad in (SELECT top 3 ubi.localidad FROM SOMOS_QUERY_LORDS.BI_HECHO_ENVIOS he
							JOIN SOMOS_QUERY_LORDS.BI_DIM_UBICACIONES ubi on ubi.id = he.id_ubicacion
							group by ubi.localidad
							order by avg(he.total_monto_envio) desc)
	group by ubi.localidad
	
GO
