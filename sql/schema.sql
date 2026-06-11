-- =============================================================================
--  NexShop Group S.A. — Schema de Base de Datos
--  Autor: Sara
--  Motor: MySQL 8.x
-- =============================================================================

DROP DATABASE IF EXISTS nexshop;
CREATE DATABASE nexshop CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE nexshop;

-- =============================================================================
--  1. SEDE
-- =============================================================================
CREATE TABLE sede (
    id_sede     INT           NOT NULL AUTO_INCREMENT,
    nombre      VARCHAR(100)  NOT NULL,
    tipo        ENUM('tienda_fisica','almacen_central') NOT NULL,
    ciudad      VARCHAR(100),
    direccion   VARCHAR(200),
    telefono    VARCHAR(20),
    PRIMARY KEY (id_sede)
) ENGINE=InnoDB;

-- =============================================================================
--  2. EMPLEADO
-- =============================================================================
CREATE TABLE empleado (
    id_empleado          INT           NOT NULL AUTO_INCREMENT,
    nombre               VARCHAR(100)  NOT NULL,
    apellidos            VARCHAR(150)  NOT NULL,
    dni                  VARCHAR(9)    NOT NULL,
    email_corporativo    VARCHAR(150)  NOT NULL,
    fecha_incorporacion  DATE          NOT NULL,
    rol                  VARCHAR(50)   NOT NULL,
    id_sede              INT           NOT NULL,
    PRIMARY KEY (id_empleado),
    UNIQUE KEY uq_empleado_dni   (dni),
    UNIQUE KEY uq_empleado_email (email_corporativo),
    CONSTRAINT fk_empleado_sede FOREIGN KEY (id_sede) REFERENCES sede(id_sede)
) ENGINE=InnoDB;

-- =============================================================================
--  3. CLIENTE
-- =============================================================================
CREATE TABLE cliente (
    id_cliente      INT           NOT NULL AUTO_INCREMENT,
    nombre          VARCHAR(100),
    apellidos       VARCHAR(150),
    email           VARCHAR(150),
    password_hash   VARCHAR(255),
    fecha_nacimiento DATE,
    fecha_registro  DATETIME,
    tipo            ENUM('registrado','anonimo') NOT NULL DEFAULT 'registrado',
    PRIMARY KEY (id_cliente),
    UNIQUE KEY uq_cliente_email (email)
) ENGINE=InnoDB;

-- =============================================================================
--  4. DIRECCION_CLIENTE
-- =============================================================================
CREATE TABLE direccion_cliente (
    id_direccion    INT           NOT NULL AUTO_INCREMENT,
    id_cliente      INT           NOT NULL,
    tipo            VARCHAR(50)   NOT NULL DEFAULT 'domicilio',
    calle           VARCHAR(200)  NOT NULL,
    numero          VARCHAR(10),
    piso            VARCHAR(20),
    codigo_postal   VARCHAR(10)   NOT NULL,
    ciudad          VARCHAR(100)  NOT NULL,
    pais            VARCHAR(100)  NOT NULL DEFAULT 'España',
    PRIMARY KEY (id_direccion),
    CONSTRAINT fk_dir_cliente FOREIGN KEY (id_cliente)
        REFERENCES cliente(id_cliente) ON DELETE CASCADE
) ENGINE=InnoDB;

-- =============================================================================
--  5. CATEGORIA (auto-referencial para categorías y subcategorías)
-- =============================================================================
CREATE TABLE categoria (
    id_categoria        INT           NOT NULL AUTO_INCREMENT,
    nombre              VARCHAR(100)  NOT NULL,
    id_categoria_padre  INT           DEFAULT NULL,
    PRIMARY KEY (id_categoria),
    CONSTRAINT fk_categoria_padre FOREIGN KEY (id_categoria_padre)
        REFERENCES categoria(id_categoria)
) ENGINE=InnoDB;

-- =============================================================================
--  6. PRODUCTO
-- =============================================================================
CREATE TABLE producto (
    id_producto     INT            NOT NULL AUTO_INCREMENT,
    nombre          VARCHAR(200)   NOT NULL,
    descripcion     TEXT,
    pvp             DECIMAL(10,2)  NOT NULL,
    id_subcategoria INT            NOT NULL,
    activo          TINYINT(1)     NOT NULL DEFAULT 1,
    PRIMARY KEY (id_producto),
    CONSTRAINT fk_producto_categoria FOREIGN KEY (id_subcategoria)
        REFERENCES categoria(id_categoria),
    CONSTRAINT chk_pvp_positivo CHECK (pvp >= 0)
) ENGINE=InnoDB;

-- =============================================================================
--  7. HISTORIAL_PRECIO
-- =============================================================================
CREATE TABLE historial_precio (
    id_historial    INT            NOT NULL AUTO_INCREMENT,
    id_producto     INT            NOT NULL,
    pvp             DECIMAL(10,2)  NOT NULL,
    fecha_inicio    DATE           NOT NULL,
    fecha_fin       DATE           DEFAULT NULL,
    PRIMARY KEY (id_historial),
    CONSTRAINT fk_histprecio_producto FOREIGN KEY (id_producto)
        REFERENCES producto(id_producto)
) ENGINE=InnoDB;

-- =============================================================================
--  8. PROMOCION
-- =============================================================================
CREATE TABLE promocion (
    id_promocion         INT            NOT NULL AUTO_INCREMENT,
    nombre               VARCHAR(150)   NOT NULL,
    descripcion          TEXT,
    descuento_porcentaje DECIMAL(5,2)   NOT NULL,
    fecha_inicio         DATE           NOT NULL,
    fecha_fin            DATE           NOT NULL,
    PRIMARY KEY (id_promocion),
    CONSTRAINT chk_promo_descuento CHECK (descuento_porcentaje > 0 AND descuento_porcentaje <= 100),
    CONSTRAINT chk_promo_fechas    CHECK (fecha_fin >= fecha_inicio)
) ENGINE=InnoDB;

-- =============================================================================
--  9. PRODUCTO_PROMOCION  (N:M resuelto)
-- =============================================================================
CREATE TABLE producto_promocion (
    id_producto  INT NOT NULL,
    id_promocion INT NOT NULL,
    PRIMARY KEY (id_producto, id_promocion),
    CONSTRAINT fk_pp_producto  FOREIGN KEY (id_producto)  REFERENCES producto(id_producto),
    CONSTRAINT fk_pp_promocion FOREIGN KEY (id_promocion) REFERENCES promocion(id_promocion)
) ENGINE=InnoDB;

-- =============================================================================
-- 10. PROVEEDOR
-- =============================================================================
CREATE TABLE proveedor (
    id_proveedor     INT           NOT NULL AUTO_INCREMENT,
    nombre           VARCHAR(150)  NOT NULL,
    email            VARCHAR(150),
    telefono         VARCHAR(20),
    direccion        VARCHAR(200),
    id_representante INT           DEFAULT NULL,
    PRIMARY KEY (id_proveedor),
    CONSTRAINT fk_proveedor_rep FOREIGN KEY (id_representante)
        REFERENCES empleado(id_empleado)
) ENGINE=InnoDB;

-- =============================================================================
-- 11. PRODUCTO_PROVEEDOR  (N:M con historial)
-- =============================================================================
CREATE TABLE producto_proveedor (
    id                  INT            NOT NULL AUTO_INCREMENT,
    id_producto         INT            NOT NULL,
    id_proveedor        INT            NOT NULL,
    precio_coste        DECIMAL(10,2)  NOT NULL,
    plazo_entrega_dias  INT            NOT NULL,
    fecha_inicio        DATE           NOT NULL,
    fecha_fin           DATE           DEFAULT NULL,
    PRIMARY KEY (id),
    CONSTRAINT fk_provprod_producto  FOREIGN KEY (id_producto)  REFERENCES producto(id_producto),
    CONSTRAINT fk_provprod_proveedor FOREIGN KEY (id_proveedor) REFERENCES proveedor(id_proveedor),
    CONSTRAINT chk_coste_positivo    CHECK (precio_coste >= 0),
    CONSTRAINT chk_plazo_positivo    CHECK (plazo_entrega_dias > 0)
) ENGINE=InnoDB;

-- =============================================================================
-- 12. STOCK_UBICACION  (N:M resuelto)
-- =============================================================================
CREATE TABLE stock_ubicacion (
    id_producto INT NOT NULL,
    id_sede     INT NOT NULL,
    cantidad    INT NOT NULL DEFAULT 0,
    PRIMARY KEY (id_producto, id_sede),
    CONSTRAINT fk_stock_producto FOREIGN KEY (id_producto) REFERENCES producto(id_producto),
    CONSTRAINT fk_stock_sede     FOREIGN KEY (id_sede)     REFERENCES sede(id_sede),
    CONSTRAINT chk_stock_positivo CHECK (cantidad >= 0)
) ENGINE=InnoDB;

-- =============================================================================
-- 13. PEDIDO_ONLINE
-- =============================================================================
CREATE TABLE pedido_online (
    id_pedido            INT            NOT NULL AUTO_INCREMENT,
    id_cliente           INT            NOT NULL,
    id_direccion_entrega INT            NOT NULL,
    fecha_pedido         DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    estado               ENUM('pendiente','confirmado','en_preparacion','enviado',
                              'entregado','cancelado') NOT NULL DEFAULT 'pendiente',
    total                DECIMAL(10,2),
    puntos_canjeados     INT            NOT NULL DEFAULT 0,
    PRIMARY KEY (id_pedido),
    CONSTRAINT fk_pedido_cliente   FOREIGN KEY (id_cliente)
        REFERENCES cliente(id_cliente),
    CONSTRAINT fk_pedido_direccion FOREIGN KEY (id_direccion_entrega)
        REFERENCES direccion_cliente(id_direccion),
    CONSTRAINT chk_puntos_canje    CHECK (puntos_canjeados >= 0)
) ENGINE=InnoDB;

-- =============================================================================
-- 14. LINEA_PEDIDO
-- =============================================================================
CREATE TABLE linea_pedido (
    id_linea           INT            NOT NULL AUTO_INCREMENT,
    id_pedido          INT            NOT NULL,
    id_producto        INT            NOT NULL,
    cantidad           INT            NOT NULL,
    precio_unitario    DECIMAL(10,2)  NOT NULL,
    descuento_aplicado DECIMAL(5,2)   NOT NULL DEFAULT 0,
    PRIMARY KEY (id_linea),
    CONSTRAINT fk_lp_pedido   FOREIGN KEY (id_pedido)   REFERENCES pedido_online(id_pedido),
    CONSTRAINT fk_lp_producto FOREIGN KEY (id_producto) REFERENCES producto(id_producto),
    CONSTRAINT chk_lp_cantidad  CHECK (cantidad > 0),
    CONSTRAINT chk_lp_descuento CHECK (descuento_aplicado >= 0 AND descuento_aplicado <= 100)
) ENGINE=InnoDB;

-- =============================================================================
-- 15. ENVIO
-- =============================================================================
CREATE TABLE envio (
    id_envio               INT           NOT NULL AUTO_INCREMENT,
    id_pedido              INT           NOT NULL,
    id_sede_origen         INT           NOT NULL,
    numero_seguimiento     VARCHAR(100),
    transportista          VARCHAR(100),
    fecha_estimada_entrega DATE,
    fecha_entrega_real     DATE,
    estado                 ENUM('preparando','en_transito','entregado','devuelto')
                           NOT NULL DEFAULT 'preparando',
    PRIMARY KEY (id_envio),
    UNIQUE KEY uq_envio_seguimiento (numero_seguimiento),
    CONSTRAINT fk_envio_pedido  FOREIGN KEY (id_pedido)      REFERENCES pedido_online(id_pedido),
    CONSTRAINT fk_envio_sede    FOREIGN KEY (id_sede_origen) REFERENCES sede(id_sede)
) ENGINE=InnoDB;

-- =============================================================================
-- 16. LINEA_ENVIO  (N:M resuelto: ENVIO ↔ LINEA_PEDIDO)
-- =============================================================================
CREATE TABLE linea_envio (
    id_envio        INT NOT NULL,
    id_linea_pedido INT NOT NULL,
    cantidad        INT NOT NULL,
    PRIMARY KEY (id_envio, id_linea_pedido),
    CONSTRAINT fk_le_envio  FOREIGN KEY (id_envio)        REFERENCES envio(id_envio),
    CONSTRAINT fk_le_linea  FOREIGN KEY (id_linea_pedido) REFERENCES linea_pedido(id_linea),
    CONSTRAINT chk_le_cantidad CHECK (cantidad > 0)
) ENGINE=InnoDB;

-- =============================================================================
-- 17. VENTA_PRESENCIAL
-- =============================================================================
CREATE TABLE venta_presencial (
    id_venta             INT            NOT NULL AUTO_INCREMENT,
    id_sede              INT            NOT NULL,
    id_empleado_vendedor INT            NOT NULL,
    id_cliente           INT            DEFAULT NULL,
    fecha_venta          DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    total                DECIMAL(10,2),
    PRIMARY KEY (id_venta),
    CONSTRAINT fk_venta_sede     FOREIGN KEY (id_sede)              REFERENCES sede(id_sede),
    CONSTRAINT fk_venta_empleado FOREIGN KEY (id_empleado_vendedor) REFERENCES empleado(id_empleado),
    CONSTRAINT fk_venta_cliente  FOREIGN KEY (id_cliente)           REFERENCES cliente(id_cliente)
) ENGINE=InnoDB;

-- =============================================================================
-- 18. LINEA_VENTA
-- =============================================================================
CREATE TABLE linea_venta (
    id_linea        INT            NOT NULL AUTO_INCREMENT,
    id_venta        INT            NOT NULL,
    id_producto     INT            NOT NULL,
    cantidad        INT            NOT NULL,
    precio_unitario DECIMAL(10,2)  NOT NULL,
    PRIMARY KEY (id_linea),
    CONSTRAINT fk_lv_venta    FOREIGN KEY (id_venta)    REFERENCES venta_presencial(id_venta),
    CONSTRAINT fk_lv_producto FOREIGN KEY (id_producto) REFERENCES producto(id_producto),
    CONSTRAINT chk_lv_cantidad CHECK (cantidad > 0)
) ENGINE=InnoDB;

-- =============================================================================
-- 19. DEVOLUCION_PRESENCIAL
-- =============================================================================
CREATE TABLE devolucion_presencial (
    id_devolucion    INT      NOT NULL AUTO_INCREMENT,
    id_venta         INT      NOT NULL,
    fecha_devolucion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    motivo           TEXT,
    id_empleado      INT      NOT NULL,
    PRIMARY KEY (id_devolucion),
    CONSTRAINT fk_dev_venta     FOREIGN KEY (id_venta)    REFERENCES venta_presencial(id_venta),
    CONSTRAINT fk_dev_empleado  FOREIGN KEY (id_empleado) REFERENCES empleado(id_empleado)
) ENGINE=InnoDB;

-- =============================================================================
-- 20. LINEA_DEVOLUCION
-- =============================================================================
CREATE TABLE linea_devolucion (
    id_linea_devolucion INT NOT NULL AUTO_INCREMENT,
    id_devolucion       INT NOT NULL,
    id_linea_venta      INT NOT NULL,
    cantidad            INT NOT NULL,
    PRIMARY KEY (id_linea_devolucion),
    CONSTRAINT fk_ld_devolucion  FOREIGN KEY (id_devolucion)  REFERENCES devolucion_presencial(id_devolucion),
    CONSTRAINT fk_ld_lineaventa  FOREIGN KEY (id_linea_venta) REFERENCES linea_venta(id_linea),
    CONSTRAINT chk_ld_cantidad   CHECK (cantidad > 0)
) ENGINE=InnoDB;

-- =============================================================================
-- 21. TICKET_INCIDENCIA
-- =============================================================================
CREATE TABLE ticket_incidencia (
    id_ticket       INT           NOT NULL AUTO_INCREMENT,
    id_cliente      INT           DEFAULT NULL,
    id_pedido       INT           DEFAULT NULL,
    id_agente       INT           DEFAULT NULL,
    asunto          VARCHAR(200)  NOT NULL,
    descripcion     TEXT,
    estado          ENUM('abierto','en_gestion','resuelto') NOT NULL DEFAULT 'abierto',
    fecha_apertura  DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_cierre    DATETIME      DEFAULT NULL,
    nota_resolucion TEXT,
    PRIMARY KEY (id_ticket),
    CONSTRAINT fk_ticket_cliente FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
    CONSTRAINT fk_ticket_pedido  FOREIGN KEY (id_pedido)  REFERENCES pedido_online(id_pedido),
    CONSTRAINT fk_ticket_agente  FOREIGN KEY (id_agente)  REFERENCES empleado(id_empleado)
) ENGINE=InnoDB;

-- =============================================================================
-- 22. TRANSFERENCIA_STOCK
-- =============================================================================
CREATE TABLE transferencia_stock (
    id_transferencia      INT      NOT NULL AUTO_INCREMENT,
    id_producto           INT      NOT NULL,
    id_sede_origen        INT      NOT NULL,
    id_sede_destino       INT      NOT NULL,
    cantidad              INT      NOT NULL,
    fecha                 DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    id_empleado_autoriza  INT      NOT NULL,
    PRIMARY KEY (id_transferencia),
    CONSTRAINT fk_trans_producto  FOREIGN KEY (id_producto)          REFERENCES producto(id_producto),
    CONSTRAINT fk_trans_origen    FOREIGN KEY (id_sede_origen)       REFERENCES sede(id_sede),
    CONSTRAINT fk_trans_destino   FOREIGN KEY (id_sede_destino)      REFERENCES sede(id_sede),
    CONSTRAINT fk_trans_empleado  FOREIGN KEY (id_empleado_autoriza) REFERENCES empleado(id_empleado),
    CONSTRAINT chk_trans_cantidad CHECK (cantidad > 0),
    CONSTRAINT chk_trans_sedes    CHECK (id_sede_origen <> id_sede_destino)
) ENGINE=InnoDB;

-- =============================================================================
-- 23. VALORACION
-- =============================================================================
CREATE TABLE valoracion (
    id_valoracion   INT      NOT NULL AUTO_INCREMENT,
    id_cliente      INT      NOT NULL,
    id_producto     INT      NOT NULL,
    puntuacion      INT      NOT NULL,
    comentario      TEXT,
    fecha           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    verificada      TINYINT(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (id_valoracion),
    UNIQUE KEY uq_val_cliente_producto (id_cliente, id_producto),
    CONSTRAINT fk_val_cliente  FOREIGN KEY (id_cliente)  REFERENCES cliente(id_cliente),
    CONSTRAINT fk_val_producto FOREIGN KEY (id_producto) REFERENCES producto(id_producto),
    CONSTRAINT chk_puntuacion  CHECK (puntuacion >= 1 AND puntuacion <= 5)
) ENGINE=InnoDB;

-- =============================================================================
-- 24. MOVIMIENTO_PUNTOS
-- =============================================================================
CREATE TABLE movimiento_puntos (
    id_movimiento   INT           NOT NULL AUTO_INCREMENT,
    id_cliente      INT           NOT NULL,
    id_pedido       INT           DEFAULT NULL,
    tipo            ENUM('ganado','canjeado','ajuste') NOT NULL,
    cantidad_puntos INT           NOT NULL,
    fecha           DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    descripcion     VARCHAR(200),
    PRIMARY KEY (id_movimiento),
    CONSTRAINT fk_mp_cliente FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
    CONSTRAINT fk_mp_pedido  FOREIGN KEY (id_pedido)  REFERENCES pedido_online(id_pedido)
) ENGINE=InnoDB;
