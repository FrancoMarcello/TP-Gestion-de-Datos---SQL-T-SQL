USE GD1C2025; -- Utiliza la base de datos GD1C2025
GO

CREATE OR ALTER PROCEDURE sp_crear_esquema1
AS
BEGIN
    -- Verifica si el esquema 'SOMOS_QUERY_LORDS' no existe
    IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'SOMOS_QUERY_LORDS')
    BEGIN
        -- Si no existe, lo crea
        EXEC('CREATE SCHEMA SOMOS_QUERY_LORDS');
    END
END
GO

-- Procedimiento para crear las tablas
CREATE OR ALTER PROCEDURE sp_crear_tablas
AS
BEGIN
    IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SOMOS_QUERY_LORDS.PROVINCIA') AND type in (N'U'))
    BEGIN
        CREATE TABLE SOMOS_QUERY_LORDS.PROVINCIA (
            id BIGINT IDENTITY(1,1) PRIMARY KEY,  -- Campo id que autoincrementa y es clave primaria
            nombre nvarchar(255) NOT NULL
        );
    END

	IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SOMOS_QUERY_LORDS.LOCALIDAD') AND type in (N'U'))
    BEGIN
        CREATE TABLE SOMOS_QUERY_LORDS.LOCALIDAD (
            id BIGINT IDENTITY(1,1) PRIMARY KEY,
            nombre nvarchar(255) NOT NULL,
			provincia_id BIGINT NOT NULL,
			CONSTRAINT FK_localidad_provincia_id FOREIGN KEY (provincia_id) REFERENCES SOMOS_QUERY_LORDS.PROVINCIA (id),  -- Clave foránea que referencia PROVINCIA
        );
    END

	IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SOMOS_QUERY_LORDS.MEDIDA') AND type in (N'U'))
	BEGIN
		CREATE TABLE SOMOS_QUERY_LORDS.MEDIDA (
			id BIGINT IDENTITY(1,1) PRIMARY KEY,
			precio decimal(18,2),
			alto decimal(18,2),
			ancho decimal(18,2),
			profundidad decimal(18,2)
		);
	END

	IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SOMOS_QUERY_LORDS.MODELO') AND type in (N'U'))
    BEGIN
        CREATE TABLE SOMOS_QUERY_LORDS.MODELO (
            id BIGINT IDENTITY(1,1) PRIMARY KEY,
			precio DECIMAL(18,2) NOT NULL,  
			nombre NVARCHAR(255) NOT NULL,
			descripcion NVARCHAR(255) NOT NULL
        );
    END

	IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SOMOS_QUERY_LORDS.MATERIAL') AND type in (N'U'))
    BEGIN
        CREATE TABLE SOMOS_QUERY_LORDS.MATERIAL (
            id BIGINT IDENTITY(1,1) PRIMARY KEY,
            nombre nvarchar(255) NOT NULL,
			tipo nvarchar(255) NOT NULL,
			descripcion nvarchar(255) NOT NULL,
			precioVenta decimal(38,2) NOT NULL
        );
    END

	IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SOMOS_QUERY_LORDS.COLOR') AND type in (N'U'))
    BEGIN
        CREATE TABLE SOMOS_QUERY_LORDS.COLOR (
            id BIGINT IDENTITY(1,1) PRIMARY KEY,
            nombre nvarchar(255) NOT NULL
        );
    END

	--------------------------------------------

	IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SOMOS_QUERY_LORDS.CLIENTE') AND type in (N'U'))
    BEGIN
        CREATE TABLE SOMOS_QUERY_LORDS.CLIENTE (
            id BIGINT IDENTITY(1,1) PRIMARY KEY,
			localidad_id BIGINT NOT NULL,
			CONSTRAINT FK_cliente_localidad_id FOREIGN KEY (localidad_id) REFERENCES SOMOS_QUERY_LORDS.LOCALIDAD (id),  -- Clave foránea que referencia LOCALIDAD
			dni BIGINT NOT NULL,
			nombre nvarchar(255) NOT NULL,
			apellido nvarchar(255) NOT NULL,
			fechaNacimiento datetime2(6) NOT NULL,
			direccion nvarchar(255) NOT NULL,
			mail nvarchar(255) NOT NULL,
			telefono nvarchar(255) NOT NULL,
        );
    END

	IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SOMOS_QUERY_LORDS.PROVEEDOR') AND type in (N'U'))
	BEGIN
		CREATE TABLE SOMOS_QUERY_LORDS.PROVEEDOR (
			id BIGINT IDENTITY(1,1) PRIMARY KEY,
			localidad_id BIGINT NOT NULL,  
			razonSocial NVARCHAR(255) NOT NULL,
			cuit NVARCHAR(255) NOT NULL,
			direccion NVARCHAR(255),
			telefono NVARCHAR(255),
			mail NVARCHAR(255),
			CONSTRAINT FK_proveedor_localidad_id FOREIGN KEY (localidad_id) REFERENCES SOMOS_QUERY_LORDS.LOCALIDAD(id),
		);
	END

	IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SOMOS_QUERY_LORDS.SILLON') AND type in (N'U'))
	BEGIN
		CREATE TABLE SOMOS_QUERY_LORDS.SILLON (
			id BIGINT IDENTITY(1,1) PRIMARY KEY,
			modelo_id BIGINT NOT NULL,  
			medida_id BIGINT NOT NULL,
			CONSTRAINT FK_sillon_modelo_id FOREIGN KEY (modelo_id) REFERENCES SOMOS_QUERY_LORDS.MODELO(id),
			CONSTRAINT FK_sillon_medida_id FOREIGN KEY (medida_id) REFERENCES SOMOS_QUERY_LORDS.MEDIDA(id)
		);
	END

	---------------------------------------------

    IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SOMOS_QUERY_LORDS.SUCURSAL') AND type in (N'U'))
    BEGIN
        CREATE TABLE SOMOS_QUERY_LORDS.SUCURSAL (
            id BIGINT IDENTITY(1,1) PRIMARY KEY,
			localidad_id BIGINT NOT NULL,
			CONSTRAINT FK_sucursal_localidad_id FOREIGN KEY (localidad_id) REFERENCES SOMOS_QUERY_LORDS.LOCALIDAD (id),
            direccion VARCHAR(255) NOT NULL,
			mail NVARCHAR(255) NOT NULL,
			telefono NVARCHAR(255) NOT NULL,
        );
    END

	IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SOMOS_QUERY_LORDS.PEDIDO') AND type in (N'U'))
    BEGIN
        CREATE TABLE SOMOS_QUERY_LORDS.PEDIDO (
            id DECIMAL(18,0) IDENTITY(1,1) PRIMARY KEY,
			cliente_id BIGINT NOT NULL,
			CONSTRAINT FK_pedido_cliente_id FOREIGN KEY (cliente_id) REFERENCES SOMOS_QUERY_LORDS.CLIENTE (id),
			sucursal_id BIGINT NOT NULL,
			CONSTRAINT FK_pedido_sucursal_id FOREIGN KEY (sucursal_id) REFERENCES SOMOS_QUERY_LORDS.SUCURSAL (id),
			fechaHora DATETIME2(6) NOT NULL,  
            total DECIMAL(18,2) NOT NULL,  
            estado NVARCHAR(255) NOT NULL,
        );
    END

	---------------------------------------------

	IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SOMOS_QUERY_LORDS.FACTURA') AND type in (N'U'))
    BEGIN
        CREATE TABLE SOMOS_QUERY_LORDS.FACTURA (
            id BIGINT IDENTITY(1,1) PRIMARY KEY,
			cliente_id BIGINT NOT NULL,
			CONSTRAINT FK_factura_cliente_id FOREIGN KEY (cliente_id) REFERENCES SOMOS_QUERY_LORDS.CLIENTE (id),
			sucursal_id BIGINT NOT NULL,
			CONSTRAINT FK_factura_sucursal_id FOREIGN KEY (sucursal_id) REFERENCES SOMOS_QUERY_LORDS.SUCURSAL (id),
			pedido_id DECIMAL(18,0) NOT NULL,
			CONSTRAINT FK_factura_pedido_id FOREIGN KEY (pedido_id) REFERENCES SOMOS_QUERY_LORDS.PEDIDO (id),
			fechaHora DATETIME2(6) NOT NULL,  
            total DECIMAL(38,2) NOT NULL,  
        );
    END

	IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SOMOS_QUERY_LORDS.CANCELACION') AND type in (N'U'))
    BEGIN
        CREATE TABLE SOMOS_QUERY_LORDS.CANCELACION (
            id BIGINT IDENTITY(1,1) PRIMARY KEY,
			pedido_id DECIMAL(18,0) NOT NULL,
			CONSTRAINT FK_cancelacion_pedido_id FOREIGN KEY (pedido_id) REFERENCES SOMOS_QUERY_LORDS.PEDIDO(id),
			fecha DATETIME2(6) NOT NULL,
            motivo NVARCHAR(255) NOT NULL,
        );
    END

	IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SOMOS_QUERY_LORDS.COMPRA') AND type in (N'U'))
	BEGIN
		CREATE TABLE SOMOS_QUERY_LORDS.COMPRA (
			id decimal(18,0) IDENTITY(1,1) PRIMARY KEY,
			proveedor_id BIGINT NOT NULL,  
			sucursal_id BIGINT NOT NULL,  
			fecha DATETIME NOT NULL,
			total decimal(18,2),

			CONSTRAINT FK_compra_proveedor FOREIGN KEY (proveedor_id) REFERENCES SOMOS_QUERY_LORDS.PROVEEDOR(id),
			CONSTRAINT FK_compra_sucursal FOREIGN KEY (sucursal_id) REFERENCES SOMOS_QUERY_LORDS.SUCURSAL(id),
		);
	END

	IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SOMOS_QUERY_LORDS.ENVIO') AND type in (N'U'))
    BEGIN
        CREATE TABLE SOMOS_QUERY_LORDS.ENVIO (
            id DECIMAL(18,0) IDENTITY(1,1) PRIMARY KEY,
			factura_id BIGINT NOT NULL,
			CONSTRAINT FK_envio_factura_id FOREIGN KEY (factura_id) REFERENCES SOMOS_QUERY_LORDS.FACTURA (id),
			fechaProgramada DATETIME2(6) NOT NULL,
			fechaEntrega DATETIME2(6) NOT NULL,
            importeTraslado DECIMAL(18,2) NOT NULL,  
			importeSubida DECIMAL(18,2) NOT NULL,  
            total NVARCHAR(255) NOT NULL,
        );
    END

	----------------------------------------------

	IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SOMOS_QUERY_LORDS.MATERIALES_POR_SILLON') AND type in (N'U'))
	BEGIN
		CREATE TABLE SOMOS_QUERY_LORDS.MATERIALES_POR_SILLON (
			sillon_id BIGINT,  
            material_id BIGINT,  
            PRIMARY KEY(sillon_id, material_id),  -- Clave primaria compuesta
			CONSTRAINT FK_materiales_por_sillon_sillon_id FOREIGN KEY (sillon_id) REFERENCES SOMOS_QUERY_LORDS.SILLON(id),
			CONSTRAINT FK_materiales_por_sillon_material_id FOREIGN KEY (material_id) REFERENCES SOMOS_QUERY_LORDS.MATERIAL(id)
		);
	END
	
	IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SOMOS_QUERY_LORDS.MATERIALES_POR_COMPRA') AND type in (N'U'))
	BEGIN
		CREATE TABLE SOMOS_QUERY_LORDS.MATERIALES_POR_COMPRA (
		    compra_id decimal(18,0),  
            material_id BIGINT,  
            PRIMARY KEY(compra_id, material_id),  -- Clave primaria compuesta
			cantidad decimal(18,2),
			precioDeCompra decimal(18,2),
			subtotal decimal(18,2),
			CONSTRAINT FK_materiales_por_compra_compra_id FOREIGN KEY (compra_id) REFERENCES SOMOS_QUERY_LORDS.COMPRA(id),
			CONSTRAINT FK_materiales_por_compra_material_id FOREIGN KEY (material_id) REFERENCES SOMOS_QUERY_LORDS.MATERIAL(id),
		);
	END

	IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SOMOS_QUERY_LORDS.TELA') AND type in (N'U'))
    BEGIN
        CREATE TABLE SOMOS_QUERY_LORDS.TELA (
            id BIGINT IDENTITY(1,1) PRIMARY KEY,
            textura nvarchar(255) NOT NULL,
			material_id BIGINT NOT NULL,
			CONSTRAINT FK_tela_material_id FOREIGN KEY (material_id) REFERENCES SOMOS_QUERY_LORDS.MATERIAL(id),
			color_id BIGINT NOT NULL,
			CONSTRAINT FK_tela_color_id FOREIGN KEY (color_id) REFERENCES SOMOS_QUERY_LORDS.COLOR(id)
        );
    END

	IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SOMOS_QUERY_LORDS.MADERA') AND type in (N'U'))
    BEGIN
        CREATE TABLE SOMOS_QUERY_LORDS.MADERA (
            id BIGINT IDENTITY(1,1) PRIMARY KEY,
            dureza nvarchar(255) NOT NULL,
			material_id BIGINT NOT NULL,
			CONSTRAINT FK_madera_material_id FOREIGN KEY (material_id) REFERENCES SOMOS_QUERY_LORDS.MATERIAL(id),
			color_id BIGINT NOT NULL,
			CONSTRAINT FK_madera_color_id FOREIGN KEY (color_id) REFERENCES SOMOS_QUERY_LORDS.COLOR(id)
        );
    END

	IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SOMOS_QUERY_LORDS.RELLENO') AND type in (N'U'))
    BEGIN
        CREATE TABLE SOMOS_QUERY_LORDS.RELLENO (
            id BIGINT IDENTITY(1,1) PRIMARY KEY,
            densidad decimal(38,2) NOT NULL,
			material_id BIGINT NOT NULL,
			CONSTRAINT FK_relleno_material_id FOREIGN KEY (material_id) REFERENCES SOMOS_QUERY_LORDS.MATERIAL(id)
        );
    END

	IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SOMOS_QUERY_LORDS.SILLONES_POR_PEDIDO') AND type in (N'U'))
	BEGIN
		CREATE TABLE SOMOS_QUERY_LORDS.SILLONES_POR_PEDIDO (
			id BIGINT IDENTITY(1,1) PRIMARY KEY,
			sillon_id BIGINT,  
            pedido_id decimal(18,0),
			cantidad decimal(18,0),
			precio decimal(18,2),
			subtotal decimal(18,2),
			CONSTRAINT FK_SILLONES_POR_PEDIDO_SILLON FOREIGN KEY (sillon_id) REFERENCES SOMOS_QUERY_LORDS.SILLON(id),
			CONSTRAINT FK_SILLONES_POR_PEDIDO_PEDIDO FOREIGN KEY (pedido_id) REFERENCES SOMOS_QUERY_LORDS.PEDIDO(id)
		);
	END

	IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SOMOS_QUERY_LORDS.SILLONES_POR_FACTURA') AND type in (N'U'))
	BEGIN
		CREATE TABLE SOMOS_QUERY_LORDS.SILLONES_POR_FACTURA (
			sillonesPorPedido_id BIGINT,  
            factura_id BIGINT,  
            PRIMARY KEY(sillonesPorPedido_id, factura_id),  -- Clave primaria compuesta
			cantidad decimal(18,0),
			precio decimal(18,2),
			subtotal decimal(18,2),
			CONSTRAINT FK_SILLONES_POR_FACTURA_SILLON FOREIGN KEY (sillonesPorPedido_id) REFERENCES SOMOS_QUERY_LORDS.SILLONES_POR_PEDIDO(id),
			CONSTRAINT FK_SILLONES_POR_FACTURA_FACTURA FOREIGN KEY (factura_id) REFERENCES SOMOS_QUERY_LORDS.FACTURA(id)
		);
	END
END
GO

-- Procedimientos para inserciones individuales

-- Inserta en PROVINCIA
CREATE OR ALTER PROCEDURE sp_insertar_provincia 
AS
BEGIN    
    INSERT INTO SOMOS_QUERY_LORDS.PROVINCIA (nombre)
    SELECT DISTINCT Proveedor_Provincia
    FROM [gd_esquema].[Maestra]
    WHERE Proveedor_Provincia IS NOT NULL

    UNION
	
    SELECT DISTINCT Sucursal_Provincia
    FROM [gd_esquema].[Maestra]
    WHERE Sucursal_Provincia IS NOT NULL

	UNION
	
    SELECT DISTINCT Cliente_Provincia
    FROM [gd_esquema].[Maestra]
    WHERE Cliente_Provincia IS NOT NULL
END
GO

-- Inserta en LOCALIDAD
CREATE OR ALTER PROCEDURE sp_insertar_localidad 
AS
BEGIN    
    INSERT INTO SOMOS_QUERY_LORDS.LOCALIDAD (nombre,provincia_id)
    SELECT DISTINCT Proveedor_Localidad, p.id
    FROM [gd_esquema].[Maestra]
	JOIN SOMOS_QUERY_LORDS.PROVINCIA p ON p.nombre = Proveedor_Provincia
    WHERE Proveedor_Localidad IS NOT NULL

    UNION
	
    SELECT DISTINCT Sucursal_Localidad, p.id
    FROM [gd_esquema].[Maestra]
	JOIN SOMOS_QUERY_LORDS.PROVINCIA p ON p.nombre = Sucursal_Provincia
    WHERE Sucursal_Localidad IS NOT NULL

	UNION
	
    SELECT DISTINCT Cliente_Localidad, p.id
    FROM [gd_esquema].[Maestra]
	JOIN SOMOS_QUERY_LORDS.PROVINCIA p ON p.nombre = Cliente_Provincia
    WHERE Cliente_Localidad IS NOT NULL

	order by Proveedor_Localidad
END
GO

-- Inserta en COLOR
CREATE OR ALTER PROCEDURE sp_insertar_color
AS
BEGIN
    INSERT INTO [SOMOS_QUERY_LORDS].[COLOR] (nombre)
    SELECT DISTINCT Tela_Color AS nombre
    FROM [gd_esquema].[Maestra]
    WHERE Tela_Color IS NOT NULL

    UNION

    SELECT DISTINCT Madera_Color AS nombre
    FROM [gd_esquema].[Maestra]
    WHERE Madera_Color IS NOT NULL
END
GO

--Inserta en MATERIAL
CREATE OR ALTER PROCEDURE sp_insertar_materiales1
AS
BEGIN    
    INSERT INTO [SOMOS_QUERY_LORDS].[MATERIAL] (nombre, tipo, descripcion, precioVenta) 
    SELECT DISTINCT Material_Nombre, Material_Tipo, Material_Descripcion, Material_Precio
    FROM [gd_esquema].[Maestra] WHERE
          Material_Nombre IS NOT NULL
		  AND Material_Tipo IS NOT NULL
		  AND Material_Descripcion IS NOT NULL
		  AND Material_Precio IS NOT NULL -- Evita nulos
END
GO

-- Inserta en MEDIDA
CREATE OR ALTER PROCEDURE sp_insertar_medida
AS
BEGIN
    INSERT INTO SOMOS_QUERY_LORDS.MEDIDA (precio, alto, ancho, profundidad)
    SELECT DISTINCT 
        Sillon_Medida_Precio, 
        Sillon_Medida_Alto, 
        Sillon_Medida_Ancho, 
        Sillon_Medida_Profundidad
    FROM gd_esquema.Maestra
    WHERE Sillon_Medida_Precio IS NOT NULL
		AND Sillon_Medida_Alto IS NOT NULL
		AND Sillon_Medida_Ancho IS NOT NULL
		AND Sillon_Medida_Profundidad IS NOT NULL;
END
GO

-- Inserta en MODELO
CREATE OR ALTER PROCEDURE sp_insertar_modelo
AS
BEGIN    
	SET IDENTITY_INSERT SOMOS_QUERY_LORDS.MODELO ON
    INSERT INTO SOMOS_QUERY_LORDS.MODELO (id, nombre, descripcion, precio)
    SELECT DISTINCT Sillon_Modelo_Codigo, Sillon_Modelo, Sillon_Modelo_Descripcion, Sillon_Modelo_Precio
    FROM [gd_esquema].[Maestra]
    WHERE Sillon_Modelo IS NOT NULL
      AND Sillon_Modelo_Descripcion IS NOT NULL
      AND Sillon_Modelo_Precio IS NOT NULL;
	SET IDENTITY_INSERT SOMOS_QUERY_LORDS.MODELO OFF
END
GO

----------------------------------------------------------

-- Inserta en CLIENTE
CREATE OR ALTER PROCEDURE sp_insertar_cliente
AS
BEGIN
    INSERT INTO [SOMOS_QUERY_LORDS].[CLIENTE](localidad_id, apellido, nombre, dni, direccion, fechaNacimiento, mail, telefono)
    SELECT DISTINCT l.id, Cliente_Apellido, Cliente_Nombre, Cliente_Dni, Cliente_Direccion, Cliente_FechaNacimiento, Cliente_Mail, Cliente_Telefono
    FROM [gd_esquema].[Maestra] m
        JOIN SOMOS_QUERY_LORDS.LOCALIDAD l ON m.Cliente_Localidad = l.nombre
        JOIN SOMOS_QUERY_LORDS.PROVINCIA p ON p.nombre = Cliente_Provincia
    WHERE Cliente_Dni IS NOT NULL
          AND Cliente_Nombre IS NOT NULL
          AND l.provincia_id = p.id
END
GO

-- Inserta en PROVEEDOR
CREATE OR ALTER PROCEDURE sp_insertar_proveedores
AS
BEGIN
    INSERT INTO [SOMOS_QUERY_LORDS].[PROVEEDOR] (razonSocial, cuit, direccion, telefono, mail, localidad_id)
    SELECT DISTINCT Proveedor_RazonSocial, Proveedor_Cuit, Proveedor_Direccion, Proveedor_Telefono, Proveedor_Mail, l.id
    FROM [gd_esquema].[Maestra] m
    JOIN SOMOS_QUERY_LORDS.LOCALIDAD l ON m.Proveedor_Localidad = l.nombre
    JOIN SOMOS_QUERY_LORDS.PROVINCIA p ON p.nombre = m.Proveedor_Provincia
    WHERE
          Proveedor_RazonSocial IS NOT NULL
          AND Proveedor_Cuit IS NOT NULL
          AND Proveedor_Direccion IS NOT NULL 
          AND Proveedor_Telefono IS NOT NULL
          AND Proveedor_Mail IS NOT NULL 
          AND Proveedor_Direccion IS NOT NULL 
          AND l.provincia_id = p.id
END
GO

-- Inserta en SILLON
CREATE OR ALTER PROCEDURE sp_insertar_sillon
AS
BEGIN
	SET IDENTITY_INSERT SOMOS_QUERY_LORDS.SILLON ON
    INSERT INTO [SOMOS_QUERY_LORDS].[SILLON] (id, modelo_id, medida_id) 
    SELECT DISTINCT Sillon_Codigo, mo.id, me.id
    FROM [gd_esquema].[Maestra] m
	JOIN SOMOS_QUERY_LORDS.MODELO mo ON m.Sillon_Modelo = mo.nombre
	JOIN SOMOS_QUERY_LORDS.MEDIDA me ON m.Sillon_Medida_Alto+m.Sillon_Medida_Ancho+m.Sillon_Medida_Profundidad = me.alto+me.ancho+me.profundidad
	SET IDENTITY_INSERT SOMOS_QUERY_LORDS.SILLON OFF
END
GO

---------------------------------------------------

-- Inserta en SUCURSAL
CREATE OR ALTER PROCEDURE sp_insertar_sucursal
AS
BEGIN    
	SET IDENTITY_INSERT SOMOS_QUERY_LORDS.SUCURSAL ON
    INSERT INTO SOMOS_QUERY_LORDS.SUCURSAL (id, localidad_id, direccion, mail, telefono)
    SELECT DISTINCT Sucursal_NroSucursal, l.id, Sucursal_Direccion, Sucursal_Mail, Sucursal_Telefono
    FROM [gd_esquema].[Maestra] m
    JOIN SOMOS_QUERY_LORDS.LOCALIDAD l ON m.Sucursal_Localidad = l.nombre
	JOIN SOMOS_QUERY_LORDS.PROVINCIA p on m.Sucursal_Provincia = p.nombre
    WHERE Sucursal_Direccion IS NOT NULL
      AND Sucursal_Mail IS NOT NULL
      AND Sucursal_Telefono IS NOT NULL
	  AND l.provincia_id = p.id
	 order by 1
	SET IDENTITY_INSERT SOMOS_QUERY_LORDS.SUCURSAL OFF
END
GO

-- Inserta en PEDIDO
CREATE OR ALTER PROCEDURE sp_insertar_pedido
AS
BEGIN
	SET IDENTITY_INSERT SOMOS_QUERY_LORDS.PEDIDO ON
    INSERT INTO [SOMOS_QUERY_LORDS].[PEDIDO](id, cliente_id, sucursal_id, total, fechaHora, estado)
    SELECT DISTINCT Pedido_Numero, c.id, s.id, Pedido_Total, Pedido_Fecha, Pedido_Estado
    FROM [gd_esquema].[Maestra] m
		JOIN SOMOS_QUERY_LORDS.CLIENTE c ON m.Cliente_Dni = c.dni
		JOIN SOMOS_QUERY_LORDS.SUCURSAL s ON m.Sucursal_NroSucursal = s.id
	WHERE Pedido_Numero IS NOT NULL
	SET IDENTITY_INSERT SOMOS_QUERY_LORDS.PEDIDO OFF
END
GO

--------------------------------------------------------------

-- Inserta en FACTURA
CREATE OR ALTER PROCEDURE sp_insertar_factura
AS
BEGIN
	SET IDENTITY_INSERT SOMOS_QUERY_LORDS.FACTURA ON
    INSERT INTO [SOMOS_QUERY_LORDS].[FACTURA](id, cliente_id, sucursal_id, pedido_id, fechaHora, total)
    SELECT DISTINCT Factura_Numero, cl.id, su.id, pe.id, Factura_Fecha, Factura_Total
	FROM [gd_esquema].[Maestra] m
		JOIN SOMOS_QUERY_LORDS.CLIENTE cl ON m.Cliente_Dni = cl.dni
		JOIN SOMOS_QUERY_LORDS.SUCURSAL su ON m.Sucursal_NroSucursal = su.id
		JOIN SOMOS_QUERY_LORDS.PEDIDO pe ON m.Pedido_Numero = pe.id
	WHERE Factura_Numero IS NOT NULL
	SET IDENTITY_INSERT SOMOS_QUERY_LORDS.FACTURA OFF
END
GO

-- Inserta en CANCELACION
CREATE OR ALTER PROCEDURE sp_insertar_cancelacion
AS
BEGIN
	INSERT INTO [SOMOS_QUERY_LORDS].[CANCELACION](pedido_id, fecha, motivo)
	SELECT DISTINCT p.id, Pedido_Cancelacion_Fecha, Pedido_Cancelacion_Motivo
	FROM [gd_esquema].[Maestra] m
		JOIN SOMOS_QUERY_LORDS.PEDIDO p ON m.Pedido_Numero = p.id
	WHERE Pedido_Numero IS NOT NULL
	  AND Pedido_Cancelacion_Fecha IS NOT NULL
	  AND Pedido_Cancelacion_Motivo IS NOT NULL
END
GO

-- Inserta en COMPRA
CREATE OR ALTER PROCEDURE sp_insertar_compra
AS
BEGIN
	SET IDENTITY_INSERT SOMOS_QUERY_LORDS.COMPRA ON
    INSERT INTO SOMOS_QUERY_LORDS.COMPRA (id, fecha, total, proveedor_id, sucursal_id)
    SELECT DISTINCT Compra_Numero, Compra_Fecha, Compra_Total, pr.id, su.id
    FROM [gd_esquema].[Maestra] m
    JOIN SOMOS_QUERY_LORDS.PROVEEDOR pr ON m.Proveedor_Cuit = pr.cuit
    JOIN SOMOS_QUERY_LORDS.SUCURSAL su ON m.Sucursal_Direccion = su.direccion
    WHERE Compra_Numero IS NOT NULL
      AND Compra_Fecha IS NOT NULL
      AND Compra_Total IS NOT NULL;
	SET IDENTITY_INSERT SOMOS_QUERY_LORDS.COMPRA OFF
END
GO

-- Inserta en ENVIO
CREATE OR ALTER PROCEDURE sp_insertar_envio
AS
BEGIN
	SET IDENTITY_INSERT SOMOS_QUERY_LORDS.ENVIO ON
    INSERT INTO [SOMOS_QUERY_LORDS].[ENVIO](id, factura_id, fechaProgramada, fechaEntrega, importeTraslado, importeSubida, total)
    SELECT DISTINCT Envio_Numero, f.id, Envio_Fecha_Programada, Envio_Fecha, Envio_ImporteTraslado, Envio_importeSubida, Envio_Total
    FROM [gd_esquema].[Maestra] m
		JOIN SOMOS_QUERY_LORDS.FACTURA f ON m.Factura_Numero = f.id
	WHERE Envio_Numero IS NOT NULL
	SET IDENTITY_INSERT SOMOS_QUERY_LORDS.ENVIO OFF
END
GO

-------------------------------------------------------------

-- Inserta en MATERIALES_POR_SILLON
CREATE OR ALTER PROCEDURE sp_insertar_materiales_por_sillon
AS
BEGIN    
    INSERT INTO [SOMOS_QUERY_LORDS].[MATERIALES_POR_SILLON] (sillon_id, material_id) 
    SELECT DISTINCT s.id, ma.id
    FROM [gd_esquema].[Maestra] m
	JOIN SOMOS_QUERY_LORDS.MATERIAL ma ON m.Material_Nombre = ma.nombre
	JOIN SOMOS_QUERY_LORDS.SILLON s ON m.Sillon_Codigo = s.id
END
GO

-- Inserta en MATERIALES_POR_COMPRA
CREATE OR ALTER PROCEDURE sp_insertar_materiales_por_compra
AS
BEGIN    
    INSERT INTO [SOMOS_QUERY_LORDS].[MATERIALES_POR_COMPRA] (compra_id, material_id, cantidad, precioDeCompra, subtotal) 
    SELECT DISTINCT c.id, ma.id, Detalle_Compra_Cantidad, Detalle_Compra_Precio, Detalle_Compra_SubTotal
    FROM [gd_esquema].[Maestra] m
	JOIN SOMOS_QUERY_LORDS.MATERIAL ma ON m.Material_Nombre = ma.nombre
	JOIN SOMOS_QUERY_LORDS.COMPRA c ON m.Compra_Numero = c.id --REVISAR
	WHERE
         Detalle_Compra_Cantidad IS NOT NULL
		 AND Detalle_Compra_Precio IS NOT NULL
		 AND Detalle_Compra_Subtotal IS NOT NULL
END
GO

-- Inserta en TELA
CREATE OR ALTER PROCEDURE sp_insertar_tela
AS
BEGIN    
    INSERT INTO SOMOS_QUERY_LORDS.TELA (textura, material_id, color_id)
    SELECT DISTINCT Tela_Textura, ma.id, c.id
    FROM [gd_esquema].[Maestra] m
    JOIN SOMOS_QUERY_LORDS.MATERIAL ma ON m.Material_Nombre = ma.nombre
    JOIN SOMOS_QUERY_LORDS.COLOR c ON m.Tela_Color = c.nombre
    WHERE Tela_Textura IS NOT NULL;
END
GO

-- Inserta en MADERA
CREATE OR ALTER PROCEDURE sp_insertar_madera
AS
BEGIN    
    INSERT INTO [SOMOS_QUERY_LORDS].[MADERA] (material_id, color_id, dureza) 
    SELECT DISTINCT ma.id, c.id, Madera_Dureza
    FROM [gd_esquema].[Maestra] m
	JOIN SOMOS_QUERY_LORDS.MATERIAL ma ON m.Material_Nombre = ma.nombre
	JOIN SOMOS_QUERY_LORDS.COLOR c ON m.Madera_Color = c.nombre
	WHERE Madera_Dureza IS NOT NULL
END
GO

-- Inserta en RELLENO
CREATE OR ALTER PROCEDURE sp_insertar_relleno
AS
BEGIN    
    INSERT INTO [SOMOS_QUERY_LORDS].[RELLENO] (material_id, densidad) 
    SELECT DISTINCT ma.id, Relleno_Densidad
    FROM [gd_esquema].[Maestra] m
	JOIN SOMOS_QUERY_LORDS.MATERIAL ma ON m.Material_Nombre = ma.nombre
	WHERE Relleno_Densidad IS NOT NULL
END
GO

-- Inserta en SILLONES_POR_PEDIDO
CREATE OR ALTER PROCEDURE sp_insertar_sillones_por_pedido
AS
BEGIN
    INSERT INTO [SOMOS_QUERY_LORDS].SILLONES_POR_PEDIDO(sillon_id, pedido_id, cantidad, precio, subtotal)
    SELECT DISTINCT s.id, p.id, Detalle_Pedido_Cantidad, Detalle_Pedido_Precio, Detalle_Pedido_SubTotal
    FROM [gd_esquema].[Maestra] m
		JOIN SOMOS_QUERY_LORDS.SILLON s ON m.Sillon_Codigo = s.id
		JOIN SOMOS_QUERY_LORDS.PEDIDO p ON m.Pedido_Numero = p.id
	WHERE Pedido_Numero IS NOT NULL
END
GO

-- Inserta en SILLONES_POR_FACTURA
CREATE OR ALTER PROCEDURE sp_insertar_sillones_por_factura
AS
BEGIN
    INSERT INTO [SOMOS_QUERY_LORDS].SILLONES_POR_FACTURA(sillonesPorPedido_id, factura_id, cantidad, precio, subtotal)
    SELECT DISTINCT
      sp.id,
      s2.Factura_Numero,
      s2.Detalle_Factura_Cantidad,
      s2.Detalle_Factura_Precio,
      s2.Detalle_Factura_SubTotal
    FROM gd_esquema.Maestra s1
    JOIN gd_esquema.Maestra s2
      ON s1.Pedido_Numero = s2.Pedido_Numero
      AND s1.Detalle_Pedido_Cantidad = s2.Detalle_Pedido_Cantidad
      AND s1.Detalle_Pedido_Precio = s2.Detalle_Pedido_Precio
      AND s1.Detalle_Pedido_SubTotal = s2.Detalle_Pedido_SubTotal
    JOIN SOMOS_QUERY_LORDS.SILLONES_POR_PEDIDO sp 
      ON sp.pedido_id = s1.Pedido_Numero
      AND sp.sillon_id = s1.Sillon_Codigo
    WHERE 
      s1.Sillon_Codigo IS NOT NULL AND s1.Factura_Numero IS NULL
      AND s2.Sillon_Codigo IS NULL AND s2.Factura_Numero IS NOT NULL
END
GO

-- Ejecutar procedimientos para crear esquema y tablas
EXEC sp_crear_esquema1; -- Ejecuta el procedimiento para crear el esquema
EXEC sp_crear_tablas; -- Ejecuta el procedimiento para crear las tablas
EXEC sp_insertar_provincia;
EXEC sp_insertar_localidad;	
EXEC sp_insertar_color;
EXEC sp_insertar_materiales1;
EXEC sp_insertar_medida;
EXEC sp_insertar_modelo;
EXEC sp_insertar_cliente
EXEC sp_insertar_proveedores;
EXEC sp_insertar_sillon;
EXEC sp_insertar_sucursal;
EXEC sp_insertar_pedido
EXEC sp_insertar_factura;
EXEC sp_insertar_cancelacion;
EXEC sp_insertar_compra;
EXEC sp_insertar_envio;
EXEC sp_insertar_materiales_por_sillon;
EXEC sp_insertar_materiales_por_compra;
EXEC sp_insertar_tela;
EXEC sp_insertar_madera;
EXEC sp_insertar_relleno;
EXEC sp_insertar_sillones_por_pedido;
EXEC sp_insertar_sillones_por_factura;