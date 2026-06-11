# Modelo Relacional — NexShop Group S.A.

**Notación:** `PK` = clave primaria | `FK` = clave foránea | `UQ` = unique | `NN` = not null

---

## Tablas del modelo

### SEDE
```
sede(
    id_sede     INT           PK  AUTO_INCREMENT,
    nombre      VARCHAR(100)  NN,
    tipo        ENUM(tienda_fisica, almacen_central)  NN,
    ciudad      VARCHAR(100),
    direccion   VARCHAR(200),
    telefono    VARCHAR(20)
)
```

---

### EMPLEADO
```
empleado(
    id_empleado         INT           PK  AUTO_INCREMENT,
    nombre              VARCHAR(100)  NN,
    apellidos           VARCHAR(150)  NN,
    dni                 VARCHAR(9)    NN  UQ,
    email_corporativo   VARCHAR(150)  NN  UQ,
    fecha_incorporacion DATE          NN,
    rol                 VARCHAR(50)   NN,
    id_sede             INT           NN  FK → sede(id_sede)
)
```

---

### CLIENTE
```
cliente(
    id_cliente      INT           PK  AUTO_INCREMENT,
    nombre          VARCHAR(100),
    apellidos       VARCHAR(150),
    email           VARCHAR(150)  UQ,
    password_hash   VARCHAR(255),
    fecha_nacimiento DATE,
    fecha_registro  DATETIME,
    tipo            ENUM(registrado, anonimo)  DEFAULT registrado
)
```

---

### DIRECCION_CLIENTE
```
direccion_cliente(
    id_direccion    INT           PK  AUTO_INCREMENT,
    id_cliente      INT           NN  FK → cliente(id_cliente),
    tipo            VARCHAR(50)   DEFAULT domicilio,
    calle           VARCHAR(200)  NN,
    numero          VARCHAR(10),
    piso            VARCHAR(20),
    codigo_postal   VARCHAR(10)   NN,
    ciudad          VARCHAR(100)  NN,
    pais            VARCHAR(100)  NN  DEFAULT España
)
```

---

### CATEGORIA
```
categoria(
    id_categoria        INT           PK  AUTO_INCREMENT,
    nombre              VARCHAR(100)  NN,
    id_categoria_padre  INT           FK → categoria(id_categoria)  -- NULL = categoría raíz
)
```
> Relación auto-referencial 0..1:N. Una categoría puede tener subcategorías hijas.

---

### PRODUCTO
```
producto(
    id_producto     INT            PK  AUTO_INCREMENT,
    nombre          VARCHAR(200)   NN,
    descripcion     TEXT,
    pvp             DECIMAL(10,2)  NN,
    id_subcategoria INT            NN  FK → categoria(id_categoria),
    activo          BOOLEAN        DEFAULT TRUE
)
```

---

### HISTORIAL_PRECIO
```
historial_precio(
    id_historial    INT            PK  AUTO_INCREMENT,
    id_producto     INT            NN  FK → producto(id_producto),
    pvp             DECIMAL(10,2)  NN,
    fecha_inicio    DATE           NN,
    fecha_fin       DATE           -- NULL si es el precio actual
)
```

---

### PROMOCION
```
promocion(
    id_promocion        INT            PK  AUTO_INCREMENT,
    nombre              VARCHAR(150)   NN,
    descripcion         TEXT,
    descuento_porcentaje DECIMAL(5,2)  NN  CHECK(> 0 AND <= 100),
    fecha_inicio        DATE           NN,
    fecha_fin           DATE           NN,
    CHECK (fecha_fin >= fecha_inicio)
)
```

---

### PRODUCTO_PROMOCION  ← Resolución N:M (PRODUCTO ↔ PROMOCION)
```
producto_promocion(
    id_producto     INT  NN  FK → producto(id_producto),
    id_promocion    INT  NN  FK → promocion(id_promocion),
    PRIMARY KEY (id_producto, id_promocion)
)
```
> Un producto puede tener múltiples promociones activas o históricas; una promoción puede aplicarse a múltiples productos.

---

### PROVEEDOR
```
proveedor(
    id_proveedor        INT           PK  AUTO_INCREMENT,
    nombre              VARCHAR(150)  NN,
    email               VARCHAR(150),
    telefono            VARCHAR(20),
    direccion           VARCHAR(200),
    id_representante    INT           FK → empleado(id_empleado)
)
```

---

### PRODUCTO_PROVEEDOR  ← Resolución N:M con historial (PRODUCTO ↔ PROVEEDOR)
```
producto_proveedor(
    id                  INT            PK  AUTO_INCREMENT,
    id_producto         INT            NN  FK → producto(id_producto),
    id_proveedor        INT            NN  FK → proveedor(id_proveedor),
    precio_coste        DECIMAL(10,2)  NN,
    plazo_entrega_dias  INT            NN,
    fecha_inicio        DATE           NN,
    fecha_fin           DATE           -- NULL si es el acuerdo vigente
)
```
> PK surrogada (en lugar de PK compuesta) para soportar el historial: varias filas por misma combinación producto-proveedor en períodos distintos.

---

### STOCK_UBICACION  ← Resolución N:M (PRODUCTO ↔ SEDE)
```
stock_ubicacion(
    id_producto INT  NN  FK → producto(id_producto),
    id_sede     INT  NN  FK → sede(id_sede),
    cantidad    INT  NN  DEFAULT 0  CHECK(>= 0),
    PRIMARY KEY (id_producto, id_sede)
)
```

---

### PEDIDO_ONLINE
```
pedido_online(
    id_pedido               INT            PK  AUTO_INCREMENT,
    id_cliente              INT            NN  FK → cliente(id_cliente),
    id_direccion_entrega    INT            NN  FK → direccion_cliente(id_direccion),
    fecha_pedido            DATETIME       DEFAULT CURRENT_TIMESTAMP,
    estado                  ENUM(pendiente, confirmado, en_preparacion, enviado,
                                 entregado, cancelado)  DEFAULT pendiente,
    total                   DECIMAL(10,2),
    puntos_canjeados        INT            DEFAULT 0
)
```

---

### LINEA_PEDIDO
```
linea_pedido(
    id_linea            INT            PK  AUTO_INCREMENT,
    id_pedido           INT            NN  FK → pedido_online(id_pedido),
    id_producto         INT            NN  FK → producto(id_producto),
    cantidad            INT            NN  CHECK(> 0),
    precio_unitario     DECIMAL(10,2)  NN,
    descuento_aplicado  DECIMAL(5,2)   DEFAULT 0
)
```

---

### ENVIO
```
envio(
    id_envio                INT           PK  AUTO_INCREMENT,
    id_pedido               INT           NN  FK → pedido_online(id_pedido),
    id_sede_origen          INT           NN  FK → sede(id_sede),
    numero_seguimiento      VARCHAR(100)  UQ,
    transportista           VARCHAR(100),
    fecha_estimada_entrega  DATE,
    fecha_entrega_real      DATE,
    estado                  ENUM(preparando, en_transito, entregado, devuelto)  DEFAULT preparando
)
```

---

### LINEA_ENVIO  ← Resolución N:M (ENVIO ↔ LINEA_PEDIDO)
```
linea_envio(
    id_envio        INT  NN  FK → envio(id_envio),
    id_linea_pedido INT  NN  FK → linea_pedido(id_linea),
    cantidad        INT  NN  CHECK(> 0),
    PRIMARY KEY (id_envio, id_linea_pedido)
)
```
> Necesaria para los envíos parciales: indica qué líneas del pedido van en cada envío y en qué cantidad.

---

### VENTA_PRESENCIAL
```
venta_presencial(
    id_venta                INT            PK  AUTO_INCREMENT,
    id_sede                 INT            NN  FK → sede(id_sede),
    id_empleado_vendedor    INT            NN  FK → empleado(id_empleado),
    id_cliente              INT            FK → cliente(id_cliente),  -- NULL si anónimo
    fecha_venta             DATETIME       DEFAULT CURRENT_TIMESTAMP,
    total                   DECIMAL(10,2)
)
```

---

### LINEA_VENTA
```
linea_venta(
    id_linea        INT            PK  AUTO_INCREMENT,
    id_venta        INT            NN  FK → venta_presencial(id_venta),
    id_producto     INT            NN  FK → producto(id_producto),
    cantidad        INT            NN  CHECK(> 0),
    precio_unitario DECIMAL(10,2)  NN
)
```

---

### DEVOLUCION_PRESENCIAL
```
devolucion_presencial(
    id_devolucion   INT       PK  AUTO_INCREMENT,
    id_venta        INT       NN  FK → venta_presencial(id_venta),
    fecha_devolucion DATETIME DEFAULT CURRENT_TIMESTAMP,
    motivo          TEXT,
    id_empleado     INT       NN  FK → empleado(id_empleado)
)
```

---

### LINEA_DEVOLUCION
```
linea_devolucion(
    id_linea_devolucion INT  PK  AUTO_INCREMENT,
    id_devolucion       INT  NN  FK → devolucion_presencial(id_devolucion),
    id_linea_venta      INT  NN  FK → linea_venta(id_linea),
    cantidad            INT  NN  CHECK(> 0)
)
```

---

### TICKET_INCIDENCIA
```
ticket_incidencia(
    id_ticket       INT           PK  AUTO_INCREMENT,
    id_cliente      INT           FK → cliente(id_cliente),
    id_pedido       INT           FK → pedido_online(id_pedido),   -- nullable
    id_agente       INT           FK → empleado(id_empleado),
    asunto          VARCHAR(200)  NN,
    descripcion     TEXT,
    estado          ENUM(abierto, en_gestion, resuelto)  DEFAULT abierto,
    fecha_apertura  DATETIME      DEFAULT CURRENT_TIMESTAMP,
    fecha_cierre    DATETIME,
    nota_resolucion TEXT
)
```

---

### TRANSFERENCIA_STOCK
```
transferencia_stock(
    id_transferencia        INT       PK  AUTO_INCREMENT,
    id_producto             INT       NN  FK → producto(id_producto),
    id_sede_origen          INT       NN  FK → sede(id_sede),
    id_sede_destino         INT       NN  FK → sede(id_sede),
    cantidad                INT       NN  CHECK(> 0),
    fecha                   DATETIME  DEFAULT CURRENT_TIMESTAMP,
    id_empleado_autoriza    INT       NN  FK → empleado(id_empleado)
)
```

---

### VALORACION
```
valoracion(
    id_valoracion   INT       PK  AUTO_INCREMENT,
    id_cliente      INT       NN  FK → cliente(id_cliente),
    id_producto     INT       NN  FK → producto(id_producto),
    puntuacion      INT       NN  CHECK(>= 1 AND <= 5),
    comentario      TEXT,
    fecha           DATETIME  DEFAULT CURRENT_TIMESTAMP,
    verificada      BOOLEAN   DEFAULT FALSE,
    UNIQUE (id_cliente, id_producto)
)
```

---

### MOVIMIENTO_PUNTOS
```
movimiento_puntos(
    id_movimiento   INT           PK  AUTO_INCREMENT,
    id_cliente      INT           NN  FK → cliente(id_cliente),
    id_pedido       INT           FK → pedido_online(id_pedido),  -- nullable
    tipo            ENUM(ganado, canjeado, ajuste)  NN,
    cantidad_puntos INT           NN,   -- positivo si ganado, negativo si canjeado
    fecha           DATETIME      DEFAULT CURRENT_TIMESTAMP,
    descripcion     VARCHAR(200)
)
```

---

## Resumen de relaciones N:M resueltas

| Relación N:M | Tabla intermedia | Atributos extra |
|---|---|---|
| PRODUCTO ↔ PROMOCION | producto_promocion | — |
| PRODUCTO ↔ PROVEEDOR (con historial) | producto_proveedor | precio_coste, plazo_entrega_dias, fecha_inicio, fecha_fin |
| PRODUCTO ↔ SEDE (stock) | stock_ubicacion | cantidad |
| ENVIO ↔ LINEA_PEDIDO | linea_envio | cantidad |

---

## Integridad referencial destacada

- `categoria.id_categoria_padre` → puede ser NULL (categorías raíz).
- `venta_presencial.id_cliente` → puede ser NULL (clientes anónimos).
- `ticket_incidencia.id_pedido` → puede ser NULL (consultas generales).
- `movimiento_puntos.id_pedido` → puede ser NULL (ajustes manuales).
- `historial_precio.fecha_fin` → puede ser NULL (precio vigente).
- `producto_proveedor.fecha_fin` → puede ser NULL (acuerdo vigente).
