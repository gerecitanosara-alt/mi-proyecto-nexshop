# Memoria de Análisis — Base de Datos NexShop Group S.A.

**Alumno:** Sara  
**Proyecto:** Mini Proyecto Avanzado — Base de Datos  
**Empresa:** NexShop Group S.A.  
**Fecha:** Junio 2026

---

## 1. Introducción

NexShop Group S.A. es una empresa de distribución y venta al por menor con sede en Valencia, fundada en 2015. Opera a través de dos canales: una tienda online (nexshop.es) y tres tiendas físicas en Valencia, Madrid y Barcelona. Ambos canales comparten el mismo catálogo de productos pero funcionan de forma casi independiente.

El siguiente documento recoge el análisis completo del modelo de datos: entidades identificadas, atributos, relaciones y justificación de cada decisión de diseño.

---

## 2. Entidades identificadas y justificación

### 2.1 SEDE
**Motivo:** Lo pide el cliente.  
La empresa tiene múltiples ubicaciones (3 tiendas físicas + 1 almacén central). Necesitamos una entidad para representarlas, ya que son el punto de referencia para el stock, los empleados, los envíos y las transferencias.

**Atributos:**
- `id_sede` — PK
- `nombre` — nombre de la sede (ej. "Tienda Valencia")
- `tipo` — ENUM('tienda_fisica', 'almacen_central')
- `ciudad` — ciudad donde está ubicada
- `direccion` — dirección postal completa
- `telefono` — teléfono de contacto

---

### 2.2 EMPLEADO
**Motivo:** Lo pide el cliente (correo de Ana Ferrer).  
Se necesita saber qué empleado realizó cada venta presencial, quién gestiona cada ticket y quién autorizó cada transferencia de stock.

**Atributos:**
- `id_empleado` — PK
- `nombre`, `apellidos`
- `dni` — UNIQUE, identificador legal
- `email_corporativo` — UNIQUE
- `fecha_incorporacion`
- `rol` — ej. encargado, vendedor, responsable_almacen, logistica, atencion_cliente
- `id_sede` — FK a SEDE (sede a la que está asignado)

---

### 2.3 CLIENTE
**Motivo:** Lo pide el cliente.  
Los clientes online se registran con datos personales. Los clientes de tienda física pueden comprar sin registrarse (anónimos). El modelo debe soportar ambos casos y también la posterior vinculación de un cliente anónimo a una cuenta registrada.

**Atributos:**
- `id_cliente` — PK
- `nombre`, `apellidos` — nullable (anónimos no tienen datos)
- `email` — UNIQUE, nullable (solo clientes registrados)
- `password_hash` — nullable
- `fecha_nacimiento` — nullable (para promoción de cumpleaños)
- `fecha_registro` — fecha en que se registró en la plataforma, nullable
- `tipo` — ENUM('registrado', 'anonimo')

> **Nota de diseño:** Un cliente anónimo se crea con tipo='anonimo' y sin datos personales. Cuando se vincula a una cuenta online, se actualiza su tipo y se rellenan sus datos, o bien se vincula la venta presencial al cliente registrado mediante el campo `id_cliente` en `VENTA_PRESENCIAL` (nullable → actualizable).

---

### 2.4 DIRECCION_CLIENTE
**Motivo:** Lo pide el cliente.  
Un cliente puede tener múltiples direcciones guardadas (domicilio, trabajo, otras). Al hacer un pedido online, elige la dirección de entrega.

**Atributos:**
- `id_direccion` — PK
- `id_cliente` — FK a CLIENTE
- `tipo` — ej. 'domicilio', 'trabajo', 'otra'
- `calle`, `numero`, `piso`
- `codigo_postal`, `ciudad`, `pais`

---

### 2.5 CATEGORIA
**Motivo:** Lo pide el cliente.  
El catálogo tiene más de 2.000 referencias organizadas en categorías y subcategorías. Por ejemplo: Informática > Portátiles > Portátiles gaming. Se modela como una tabla auto-referencial para soportar cualquier profundidad de jerarquía.

**Atributos:**
- `id_categoria` — PK
- `nombre`
- `id_categoria_padre` — FK a CATEGORIA (NULL si es categoría raíz)

> **Nota:** Un producto pertenece siempre a una sola subcategoria (hoja del árbol).

---

### 2.6 PRODUCTO
**Motivo:** Lo pide el cliente.  
El catálogo de NexShop tiene más de 2.000 referencias. Cada producto pertenece a exactamente una subcategoría y tiene un PVP que puede variar con el tiempo.

**Atributos:**
- `id_producto` — PK
- `nombre`
- `descripcion`
- `pvp` — precio de venta actual (se mantiene también historial)
- `id_subcategoria` — FK a CATEGORIA
- `activo` — boolean (baja lógica)

---

### 2.7 HISTORIAL_PRECIO
**Motivo:** Lo pide el cliente.  
El PVP puede variar con el tiempo y el sistema debe mostrar el historial completo de precios.

**Atributos:**
- `id_historial` — PK
- `id_producto` — FK a PRODUCTO
- `pvp`
- `fecha_inicio`
- `fecha_fin` — NULL si es el precio actual

---

### 2.8 PROMOCION
**Motivo:** Lo pide el cliente.  
Marketing lanza promociones periódicas: descuento porcentual sobre el PVP de ciertos productos durante un rango de fechas. Un producto puede tener varias promociones históricas.

**Atributos:**
- `id_promocion` — PK
- `nombre`
- `descripcion`
- `descuento_porcentaje` — CHECK > 0 AND <= 100
- `fecha_inicio`, `fecha_fin`

---

### 2.9 PRODUCTO_PROMOCION (tabla intermedia N:M)
**Motivo:** Lo pide el cliente.  
Una promoción puede aplicarse a varios productos y un producto puede tener varias promociones. Relación N:M resuelta con tabla intermedia.

**Atributos:**
- `id_producto` — FK a PRODUCTO (parte de PK compuesta)
- `id_promocion` — FK a PROMOCION (parte de PK compuesta)

---

### 2.10 PROVEEDOR
**Motivo:** Lo pide el cliente.  
Los proveedores suministran productos al almacén central. Cada proveedor tiene asignado un representante comercial de NexShop.

**Atributos:**
- `id_proveedor` — PK
- `nombre`, `email`, `telefono`, `direccion`
- `id_representante` — FK a EMPLEADO

---

### 2.11 PRODUCTO_PROVEEDOR (tabla intermedia N:M con historial)
**Motivo:** Lo pide el cliente.  
Un mismo producto puede ser suministrado por más de un proveedor. Para cada combinación producto-proveedor se negocia precio de coste y plazo de entrega, y estos datos cambian periódicamente (historial).

**Atributos:**
- `id` — PK (surrogada, para facilitar historial)
- `id_producto` — FK
- `id_proveedor` — FK
- `precio_coste`
- `plazo_entrega_dias`
- `fecha_inicio`
- `fecha_fin` — NULL si es el acuerdo vigente

---

### 2.12 STOCK_UBICACION
**Motivo:** Lo pide el cliente.  
El stock se controla por ubicación: cada tienda y el almacén central tienen su propio nivel de stock para cada referencia.

**Atributos:**
- `id_producto` — FK (parte de PK compuesta)
- `id_sede` — FK (parte de PK compuesta)
- `cantidad` — CHECK >= 0

---

### 2.13 PEDIDO_ONLINE
**Motivo:** Lo pide el cliente.  
Canal de venta online. Tiene estado, dirección de entrega elegida por el cliente y puede incluir canje de puntos.

**Atributos:**
- `id_pedido` — PK
- `id_cliente` — FK
- `id_direccion_entrega` — FK a DIRECCION_CLIENTE
- `fecha_pedido`
- `estado` — ENUM(pendiente, confirmado, en_preparacion, enviado, entregado, cancelado)
- `total`
- `puntos_canjeados` — puntos usados como descuento en este pedido

---

### 2.14 LINEA_PEDIDO
**Motivo:** Lo pide el cliente (implícito — un pedido tiene productos y cantidades).  
Cada línea de pedido registra qué producto, en qué cantidad y a qué precio se incluyó en el pedido. El precio se guarda en el momento de la compra para preservar el histórico.

**Atributos:**
- `id_linea` — PK
- `id_pedido` — FK
- `id_producto` — FK
- `cantidad`
- `precio_unitario` — precio en el momento de la compra
- `descuento_aplicado` — porcentaje de descuento aplicado (si había promoción)

---

### 2.15 ENVIO
**Motivo:** Lo pide el cliente.  
Un pedido puede generar varios envíos parciales desde distintos almacenes. Cada envío tiene su número de seguimiento, transportista y fecha estimada.

**Atributos:**
- `id_envio` — PK
- `id_pedido` — FK
- `id_sede_origen` — FK a SEDE
- `numero_seguimiento` — UNIQUE
- `transportista`
- `fecha_estimada_entrega`
- `fecha_entrega_real` — nullable
- `estado` — ENUM(preparando, en_transito, entregado, devuelto)

---

### 2.16 LINEA_ENVIO
**Motivo:** Lo propongo yo.  
Para saber exactamente qué líneas de pedido van en cada envío parcial (cuando un pedido se divide), necesitamos una tabla intermedia entre ENVIO y LINEA_PEDIDO.

**Atributos:**
- `id_envio` — FK (parte de PK)
- `id_linea_pedido` — FK (parte de PK)
- `cantidad` — puede ser parcial respecto a la línea del pedido

---

### 2.17 VENTA_PRESENCIAL
**Motivo:** Lo pide el cliente.  
Las ventas en tienda física generan un ticket de venta distinto al pedido online. Registra el empleado vendedor y la sede donde se realizó.

**Atributos:**
- `id_venta` — PK
- `id_sede` — FK
- `id_empleado_vendedor` — FK a EMPLEADO
- `id_cliente` — FK a CLIENTE (nullable — puede ser anónimo)
- `fecha_venta`
- `total`

---

### 2.18 LINEA_VENTA
**Motivo:** Lo pide el cliente (implícito).  
Detalle de productos vendidos en una venta presencial.

**Atributos:**
- `id_linea` — PK
- `id_venta` — FK
- `id_producto` — FK
- `cantidad`
- `precio_unitario`

---

### 2.19 DEVOLUCION_PRESENCIAL
**Motivo:** Lo pide el cliente.  
Las devoluciones de tienda se gestionan con un documento de devolución vinculado al ticket de venta original.

**Atributos:**
- `id_devolucion` — PK
- `id_venta` — FK a VENTA_PRESENCIAL
- `fecha_devolucion`
- `motivo`
- `id_empleado` — FK (empleado que gestiona la devolución)

---

### 2.20 LINEA_DEVOLUCION
**Motivo:** Lo propongo yo.  
Para registrar qué productos concretos se devuelven (y en qué cantidad), necesito el detalle a nivel de línea de venta.

**Atributos:**
- `id_linea_devolucion` — PK
- `id_devolucion` — FK
- `id_linea_venta` — FK a LINEA_VENTA
- `cantidad`

---

### 2.21 TICKET_INCIDENCIA
**Motivo:** Lo pide el cliente.  
Cuando un cliente llama para quejarse o consultar, se abre un ticket. Puede estar vinculado a un pedido o no. Lo gestiona un agente de atención al cliente.

**Atributos:**
- `id_ticket` — PK
- `id_cliente` — FK (nullable — puede ser una consulta general sin cliente identificado)
- `id_pedido` — FK a PEDIDO_ONLINE (nullable)
- `id_agente` — FK a EMPLEADO
- `asunto`, `descripcion`
- `estado` — ENUM(abierto, en_gestion, resuelto)
- `fecha_apertura`, `fecha_cierre` — nullable
- `nota_resolucion` — nullable

---

### 2.22 TRANSFERENCIA_STOCK
**Motivo:** Lo pide el cliente.  
Cuando una tienda se queda sin stock, puede solicitarlo desde el almacén central u otra tienda. Se registra con fecha, origen, destino, producto, cantidad y empleado autorizante.

**Atributos:**
- `id_transferencia` — PK
- `id_producto` — FK
- `id_sede_origen` — FK
- `id_sede_destino` — FK
- `cantidad`
- `fecha`
- `id_empleado_autoriza` — FK a EMPLEADO

---

### 2.23 VALORACION
**Motivo:** Lo pide el cliente (correo de Ana Ferrer).  
Los clientes registrados pueden puntuar (1-5) y comentar los productos que han comprado. Solo una valoración por cliente-producto. Se distingue si está verificada (compra confirmada) o no.

**Atributos:**
- `id_valoracion` — PK
- `id_cliente` — FK
- `id_producto` — FK
- `puntuacion` — CHECK entre 1 y 5
- `comentario`
- `fecha`
- `verificada` — boolean

> **Restricción:** UNIQUE(id_cliente, id_producto) — solo una valoración por cliente y producto.

---

### 2.24 MOVIMIENTO_PUNTOS
**Motivo:** Lo pide el cliente (correo de Ana Ferrer).  
Sistema de fidelización: cada euro gastado = 10 puntos. Los puntos se pueden canjear (100 puntos = 1€). Se guarda cada movimiento (ganado/canjeado) para calcular el saldo desde el historial.

**Atributos:**
- `id_movimiento` — PK
- `id_cliente` — FK
- `id_pedido` — FK a PEDIDO_ONLINE (nullable)
- `tipo` — ENUM(ganado, canjeado, ajuste)
- `cantidad_puntos` — positivo si ganado, negativo si canjeado
- `fecha`
- `descripcion`

---

## 3. Relaciones y cardinalidades

| Relación | Cardinalidad | Tabla intermedia |
|---|---|---|
| SEDE — EMPLEADO | 1:N | — |
| CLIENTE — DIRECCION_CLIENTE | 1:N | — |
| CATEGORIA — CATEGORIA (padre) | 1:N (auto-ref.) | — |
| PRODUCTO — CATEGORIA | N:1 | — |
| PRODUCTO — HISTORIAL_PRECIO | 1:N | — |
| PRODUCTO — PROMOCION | N:M | PRODUCTO_PROMOCION |
| EMPLEADO — PROVEEDOR (representante) | 1:N | — |
| PRODUCTO — PROVEEDOR | N:M (con historial) | PRODUCTO_PROVEEDOR |
| PRODUCTO — SEDE (stock) | N:M | STOCK_UBICACION |
| CLIENTE — PEDIDO_ONLINE | 1:N | — |
| DIRECCION_CLIENTE — PEDIDO_ONLINE | 1:N | — |
| PEDIDO_ONLINE — LINEA_PEDIDO | 1:N | — |
| PRODUCTO — LINEA_PEDIDO | 1:N | — |
| PEDIDO_ONLINE — ENVIO | 1:N | — |
| SEDE — ENVIO (origen) | 1:N | — |
| ENVIO — LINEA_PEDIDO | N:M | LINEA_ENVIO |
| SEDE — VENTA_PRESENCIAL | 1:N | — |
| EMPLEADO — VENTA_PRESENCIAL | 1:N | — |
| CLIENTE — VENTA_PRESENCIAL | 0..1:N | — |
| VENTA_PRESENCIAL — LINEA_VENTA | 1:N | — |
| PRODUCTO — LINEA_VENTA | 1:N | — |
| VENTA_PRESENCIAL — DEVOLUCION_PRESENCIAL | 1:N | — |
| DEVOLUCION_PRESENCIAL — LINEA_DEVOLUCION | 1:N | — |
| LINEA_VENTA — LINEA_DEVOLUCION | 1:N | — |
| CLIENTE — TICKET_INCIDENCIA | 0..1:N | — |
| PEDIDO_ONLINE — TICKET_INCIDENCIA | 0..1:N | — |
| EMPLEADO — TICKET_INCIDENCIA | 1:N | — |
| PRODUCTO — TRANSFERENCIA_STOCK | 1:N | — |
| SEDE — TRANSFERENCIA_STOCK (origen/destino) | 1:N | — |
| EMPLEADO — TRANSFERENCIA_STOCK | 1:N | — |
| CLIENTE — VALORACION | 1:N | — |
| PRODUCTO — VALORACION | 1:N | — |
| CLIENTE — MOVIMIENTO_PUNTOS | 1:N | — |
| PEDIDO_ONLINE — MOVIMIENTO_PUNTOS | 0..1:N | — |

---

## 4. Preguntas de reflexión obligatorias

### Pregunta 1: ¿Cómo has modelado que un pedido online puede generar varios envíos?

He creado la entidad **ENVIO** con una FK hacia `PEDIDO_ONLINE` con cardinalidad 1:N: un pedido puede tener uno o varios envíos. Cada ENVIO tiene su propio `numero_seguimiento`, `transportista` y `fecha_estimada_entrega`.

Para reflejar qué líneas del pedido van en cada envío parcial, he añadido la tabla **LINEA_ENVIO** (id_envio, id_linea_pedido, cantidad). Esto permite que, por ejemplo, las 2 unidades de un portátil vayan en un envío desde Valencia, y los 3 ratones vayan en otro envío desde Madrid.

Esta tabla la propongo yo como necesidad de diseño: sin ella no sería posible saber qué productos concretos se enviaron desde cada almacén.

### Pregunta 2: ¿Una tabla o dos para ventas presenciales y pedidos online?

He optado por **dos tablas separadas**: `PEDIDO_ONLINE` y `VENTA_PRESENCIAL`.

**Ventajas de tablas separadas:**
- Cada entidad tiene atributos propios que no encajan en la otra (ej. `id_direccion_entrega` solo aplica a online; `id_empleado_vendedor` solo aplica a presencial).
- Las consultas son más claras y no se necesitan NULL masivos.
- La lógica de negocio de cada canal es diferente (envíos, devoluciones, tickets).
- Más fácil de mantener y extender.

**Inconvenientes:**
- Para obtener el total de ventas por producto hay que hacer UNION entre las dos tablas.
- Duplicación de atributos comunes (total, fecha, id_producto en líneas).

Considero que las ventajas superan los inconvenientes dado que el texto describe explícitamente que "las ventas presenciales y los pedidos online son procesos distintos" con flujos de devolución diferentes.

### Pregunta 3: ¿Cómo diferencias el historial de precios del historial de promociones?

Son dos conceptos distintos que he modelado con dos tablas independientes:

- **HISTORIAL_PRECIO**: registra los cambios del PVP base del producto a lo largo del tiempo. Cada registro tiene `pvp`, `fecha_inicio` y `fecha_fin`. Refleja cuánto costaba el producto en cada momento.

- **PROMOCION** + **PRODUCTO_PROMOCION**: registran descuentos temporales aplicados sobre el PVP de determinados productos. Un descuento porcentual no cambia el PVP base del producto; es una reducción puntual y acotada por fechas.

La diferencia clave: el historial de precios refleja la evolución del valor "oficial" del producto. Las promociones son eventos de marketing superpuestos a ese precio base.

### Pregunta 4: Saldo de puntos desde el historial — ¿guardas saldo_actual?

He decidido **no guardar un campo `saldo_actual`** en la tabla CLIENTE. El saldo se calcula siempre como:

```sql
SELECT SUM(cantidad_puntos) FROM movimiento_puntos WHERE id_cliente = ?;
```

**Razonamiento:** El texto exige explícitamente que "el saldo actual pueda calcularse siempre desde el histórico de movimientos". Mantener un campo `saldo_actual` sería una desnormalización que crea riesgo de inconsistencia: si por cualquier razón el campo no se actualiza correctamente (bug, error de transacción), el saldo sería incorrecto. Al derivarlo del historial, la fuente de verdad es única.

**Implicación de diseño:** La columna `cantidad_puntos` es positiva para movimientos de tipo 'ganado' y negativa para 'canjeado', lo que permite hacer SUM directamente.

Si el rendimiento fuera un problema en producción (cliente con millones de movimientos), se podría añadir `saldo_actual` como caché y validarlo periódicamente contra el historial, pero esto sería una optimización posterior, no parte del modelo inicial.

### Pregunta 5: ¿Cómo has previsto la vinculación de un cliente anónimo a una cuenta online?

En la tabla `VENTA_PRESENCIAL`, el campo `id_cliente` es **nullable**. Cuando un cliente compra en tienda sin registrarse, la venta queda con `id_cliente = NULL`.

Cuando ese cliente luego se registra en la plataforma online y solicita vincular su historial presencial, el proceso sería:

1. El cliente facilita datos que permitan identificar la venta (fecha, tienda, importe, productos) — dato que podría constar en su ticket de caja.
2. Un agente o el propio sistema actualiza el campo `id_cliente` de esas ventas para apuntar al nuevo `id_cliente` registrado.

Esta solución es simple y no requiere tablas adicionales. La única limitación es que la vinculación depende de poder identificar la venta (el cliente debe conservar algún comprobante). En la memoria queda documentado que esto resuelve el problema que Laura Pons mencionó: "no tenemos forma de hacerlo actualmente" — el modelo lo habilita.

### Pregunta 6: ¿Hay algún requisito que hayas decidido no implementar o simplificar?

He tomado la decisión de **simplificar las devoluciones online**: el texto dice que "se gestionan como una incidencia en atención al cliente y generan un envío de recogida". He modelado esto mediante:
- Un `TICKET_INCIDENCIA` del tipo devolución vinculado al pedido.
- Un `ENVIO` de recogida (envío inverso) asociado al pedido, con estado 'devuelto'.

No he creado una entidad separada `DEVOLUCION_ONLINE` porque el propio ticket cubre la gestión y el envío inverso cubre la logística. El impacto es que para consultar devoluciones online hay que filtrar tickets por tipo/asunto, lo cual es una limitación menor.

---

## 5. Resumen del modelo

El modelo final consta de **24 tablas** que cubren todos los requisitos del cliente sin omisiones. Las decisiones de diseño priorizan la integridad referencial, el soporte de históricos y la claridad semántica sobre la optimización prematura.
