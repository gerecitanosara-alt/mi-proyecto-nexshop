-- =============================================================================
--  NexShop Group S.A. — Datos de prueba
--  Ejecutar después de schema.sql
-- =============================================================================

USE nexshop;

-- =============================================================================
-- SEDES
-- =============================================================================
INSERT INTO sede (nombre, tipo, ciudad, direccion, telefono) VALUES
('Almacén Central Valencia',    'almacen_central', 'Valencia',  'Polígono Fuente del Jarro, Calle A, 15',     '963 100 200'),
('Tienda NexShop Valencia',     'tienda_fisica',   'Valencia',  'Calle Colón, 12',                            '963 200 300'),
('Tienda NexShop Madrid',       'tienda_fisica',   'Madrid',    'Gran Vía, 45',                               '914 500 600'),
('Tienda NexShop Barcelona',    'tienda_fisica',   'Barcelona', 'Passeig de Gràcia, 88',                      '932 100 400');

-- =============================================================================
-- EMPLEADOS
-- =============================================================================
INSERT INTO empleado (nombre, apellidos, dni, email_corporativo, fecha_incorporacion, rol, id_sede) VALUES
('David',   'Cano Pérez',       '12345678A', 'd.cano@nexshop.es',         '2015-03-01', 'responsable_logistica',   1),
('Ana',     'Ferrer Blasco',    '23456789B', 'a.ferrer@nexshop.es',       '2015-03-01', 'directora_operaciones',   1),
('Sergio',  'Blanco Mora',      '34567890C', 's.blanco@nexshop.es',       '2015-06-01', 'responsable_IT',          1),
('Laura',   'Pons García',      '45678901D', 'l.pons@nexshop.es',         '2016-01-15', 'jefa_atencion_cliente',   1),
('Marco',   'Ruiz Soler',       '56789012E', 'm.ruiz@nexshop.es',         '2016-04-01', 'encargado',               2),
('Elena',   'Torres Vidal',     '67890123F', 'e.torres@nexshop.es',       '2017-02-01', 'vendedora',               2),
('Javier',  'López Martín',     '78901234G', 'j.lopez@nexshop.es',        '2017-05-10', 'vendedor',                2),
('Carmen',  'Díaz Fernández',   '89012345H', 'c.diaz@nexshop.es',         '2018-01-20', 'responsable_almacen',     2),
('Miguel',  'Santos Roca',      '90123456I', 'm.santos@nexshop.es',       '2016-09-01', 'encargado',               3),
('Lucía',   'Vega Ortiz',       '01234567J', 'l.vega@nexshop.es',         '2019-03-15', 'vendedora',               3),
('Pablo',   'Herrero Sanz',     '11223344K', 'p.herrero@nexshop.es',      '2018-07-01', 'encargado',               4),
('Nuria',   'Castillo Reyes',   '22334455L', 'n.castillo@nexshop.es',     '2020-01-10', 'vendedora',               4),
('Alberto', 'Méndez Gil',       '33445566M', 'a.mendez@nexshop.es',       '2019-11-01', 'agente_atencion_cliente', 1),
('Rosa',    'Jiménez Navarro',  '44556677N', 'r.jimenez@nexshop.es',      '2021-02-15', 'agente_atencion_cliente', 1),
('Fernando','Morales Cuesta',   '55667788O', 'f.morales@nexshop.es',      '2020-06-01', 'comercial',               1);

-- =============================================================================
-- CLIENTES
-- =============================================================================
INSERT INTO cliente (nombre, apellidos, email, password_hash, fecha_nacimiento, fecha_registro, tipo) VALUES
('Carlos',   'García López',     'carlos.garcia@gmail.com',   '$2b$12$hash1',  '1990-04-15', '2022-01-10 10:00:00', 'registrado'),
('María',    'Sánchez Pérez',    'maria.sanchez@gmail.com',   '$2b$12$hash2',  '1985-08-22', '2022-03-05 11:30:00', 'registrado'),
('Jorge',    'Martínez Ruiz',    'jorge.martinez@hotmail.com','$2b$12$hash3',  '1995-12-01', '2022-06-18 09:15:00', 'registrado'),
('Ana',      'Fernández Gómez',  'ana.fernandez@gmail.com',   '$2b$12$hash4',  '1992-07-30', '2023-01-22 14:00:00', 'registrado'),
('Pedro',    'Rodríguez Torres', 'pedro.rodriguez@yahoo.com', '$2b$12$hash5',  '1988-03-11', '2023-04-10 16:45:00', 'registrado'),
('Sofía',    'López Díaz',       'sofia.lopez@gmail.com',     '$2b$12$hash6',  '2000-11-05', '2023-07-01 08:00:00', 'registrado'),
('Luis',     'González Vega',    'luis.gonzalez@outlook.com', '$2b$12$hash7',  '1998-06-20', '2024-01-15 12:00:00', 'registrado'),
('Elena',    'Castro Blanco',    'elena.castro@gmail.com',    '$2b$12$hash8',  '1993-02-14', '2024-03-20 10:30:00', 'registrado'),
(NULL,       NULL,               NULL,                        NULL,            NULL,          NULL,                  'anonimo'),
(NULL,       NULL,               NULL,                        NULL,            NULL,          NULL,                  'anonimo');

-- =============================================================================
-- DIRECCIONES DE CLIENTES
-- =============================================================================
INSERT INTO direccion_cliente (id_cliente, tipo, calle, numero, piso, codigo_postal, ciudad, pais) VALUES
(1, 'domicilio', 'Calle Mayor',          '12', '3B',  '46001', 'Valencia',  'España'),
(1, 'trabajo',   'Avenida del Puerto',   '5',  NULL,  '46023', 'Valencia',  'España'),
(2, 'domicilio', 'Calle Alcalá',         '88', '2A',  '28009', 'Madrid',    'España'),
(3, 'domicilio', 'Carrer de Provença',   '200','4C',  '08008', 'Barcelona', 'España'),
(4, 'domicilio', 'Calle Real',           '3',  '1D',  '41001', 'Sevilla',   'España'),
(5, 'domicilio', 'Rúa Nova',             '11', NULL,  '15001', 'A Coruña',  'España'),
(6, 'domicilio', 'Calle San Fernando',   '7',  '5E',  '46013', 'Valencia',  'España'),
(7, 'domicilio', 'Gran Vía',             '60', '2B',  '28013', 'Madrid',    'España'),
(8, 'domicilio', 'Avinguda Diagonal',    '150','1A',  '08018', 'Barcelona', 'España');

-- =============================================================================
-- CATEGORÍAS
-- =============================================================================
INSERT INTO categoria (nombre, id_categoria_padre) VALUES
('Informática',         NULL),  -- 1
('Electrónica',         NULL),  -- 2
('Periféricos',         NULL),  -- 3
('Portátiles',          1),     -- 4
('Sobremesa',           1),     -- 5
('Componentes',         1),     -- 6
('Smartphones',         2),     -- 7
('Tablets',             2),     -- 8
('Televisores',         2),     -- 9
('Ratones',             3),     -- 10
('Teclados',            3),     -- 11
('Monitores',           3),     -- 12
('Portátiles Gaming',   4),     -- 13
('Portátiles Oficina',  4),     -- 14
('Portátiles Ultraligeros', 4); -- 15

-- =============================================================================
-- PRODUCTOS
-- =============================================================================
INSERT INTO producto (nombre, descripcion, pvp, id_subcategoria, activo) VALUES
('Laptop ASUS ROG Zephyrus G14',   'Portátil gaming AMD Ryzen 9, RTX 3060, 16GB RAM',   1499.99, 13, 1),
('Laptop Dell XPS 13',             'Portátil ultraligero Intel i7, 16GB RAM, 512GB SSD', 1199.99, 15, 1),
('Laptop HP EliteBook 840',        'Portátil oficina Intel i5, 8GB RAM, 256GB SSD',       849.99, 14, 1),
('Smartphone Samsung Galaxy S24',  'Snapdragon 8 Gen3, 6.2", 128GB',                      799.99,  7, 1),
('Smartphone iPhone 15',           'Apple A16 Bionic, 6.1", 256GB',                       999.99,  7, 1),
('Tablet iPad Air',                'Apple M1, 10.9", Wi-Fi, 64GB',                        699.99,  8, 1),
('Monitor LG UltraWide 34"',       'IPS 3440x1440, 144Hz, FreeSync',                      549.99, 12, 1),
('Teclado Mecánico Logitech MX',   'Switches táctiles, retroiluminado RGB',               149.99, 11, 1),
('Ratón Gaming Razer DeathAdder',  '20000 DPI, 8 botones programables',                    69.99, 10, 1),
('Smart TV Samsung 55" 4K',        'QLED, HDR10+, Tizen OS',                              799.99,  9, 1),
('Memoria RAM Corsair 16GB DDR5',  'DDR5 5600MHz, CL36, XMP 3.0',                          89.99,  6, 1),
('SSD Samsung 990 Pro 1TB',        'NVMe M.2, 7450MB/s lectura',                          129.99,  6, 1),
('Webcam Logitech C920 HD',        '1080p, 30fps, micrófono estéreo',                      79.99, 12, 1),
('Auriculares Sony WH-1000XM5',    'Cancelación de ruido, Bluetooth 5.2',                 299.99,  2, 1),
('PC Gamer Tower Corsair',         'Intel i9, RTX 4080, 32GB RAM, 2TB SSD',              2499.99,  5, 1);

-- =============================================================================
-- HISTORIAL DE PRECIOS
-- =============================================================================
INSERT INTO historial_precio (id_producto, pvp, fecha_inicio, fecha_fin) VALUES
(1, 1699.99, '2023-01-01', '2023-09-30'),
(1, 1499.99, '2023-10-01', NULL),
(2, 1299.99, '2022-06-01', '2023-05-31'),
(2, 1199.99, '2023-06-01', NULL),
(4,  899.99, '2023-01-01', '2023-11-30'),
(4,  799.99, '2023-12-01', NULL),
(5, 1099.99, '2023-09-01', '2024-02-28'),
(5,  999.99, '2024-03-01', NULL);

-- =============================================================================
-- PROMOCIONES
-- =============================================================================
INSERT INTO promocion (nombre, descripcion, descuento_porcentaje, fecha_inicio, fecha_fin) VALUES
('Black Friday 2023',       'Descuentos especiales Black Friday',      15.00, '2023-11-24', '2023-11-27'),
('Rebajas Enero 2024',      'Rebajas de temporada enero 2024',         10.00, '2024-01-07', '2024-01-31'),
('Promo Gaming Verano',     'Descuentos en equipos gaming',            12.00, '2024-07-01', '2024-07-31'),
('Vuelta al Cole 2024',     'Portátiles y periféricos back-to-school', 8.00,  '2024-09-01', '2024-09-30'),
('Cumpleaños NexShop 2024', 'Celebración 9 aniversario',              20.00, '2024-10-15', '2024-10-20');

-- =============================================================================
-- PRODUCTO_PROMOCION
-- =============================================================================
INSERT INTO producto_promocion (id_producto, id_promocion) VALUES
(1, 1), (1, 3), (2, 1), (2, 4), (3, 4),
(4, 1), (4, 2), (5, 1), (7, 2), (8, 4),
(9, 3), (11, 2), (12, 2), (15, 3), (15, 5);

-- =============================================================================
-- PROVEEDORES
-- =============================================================================
INSERT INTO proveedor (nombre, email, telefono, direccion, id_representante) VALUES
('TechDistrib Spain S.L.',   'ventas@techdistrib.es',    '912 000 100', 'Polígono Industrial Norte, Madrid', 15),
('GlobalTech Solutions',     'orders@globaltech.com',    '+34 93 111 222', 'Zona Franca, Barcelona',          15),
('AsiaImport Electronics',   'sales@asiaimport.es',      '963 333 444', 'Puerto de Valencia, Nave 5',         15),
('IberSuministros S.A.',     'compras@ibersuministros.es','914 555 666', 'Leganés, Madrid',                    15);

-- =============================================================================
-- PRODUCTO_PROVEEDOR (con historial)
-- =============================================================================
INSERT INTO producto_proveedor (id_producto, id_proveedor, precio_coste, plazo_entrega_dias, fecha_inicio, fecha_fin) VALUES
(1, 1, 1100.00, 7,  '2023-01-01', '2023-12-31'),
(1, 1,  980.00, 5,  '2024-01-01', NULL),
(1, 2, 1050.00, 10, '2023-06-01', NULL),
(2, 1,  850.00, 7,  '2023-01-01', NULL),
(3, 1,  580.00, 5,  '2023-01-01', NULL),
(4, 3,  560.00, 14, '2023-01-01', '2023-11-30'),
(4, 3,  510.00, 12, '2023-12-01', NULL),
(5, 2,  700.00, 10, '2023-09-01', NULL),
(7, 1,  380.00, 7,  '2023-01-01', NULL),
(8, 4,   90.00, 5,  '2022-01-01', NULL),
(9, 4,   40.00, 3,  '2022-01-01', NULL),
(10,3,  530.00, 14, '2023-01-01', NULL),
(11,4,   55.00, 4,  '2023-01-01', NULL),
(12,4,   75.00, 4,  '2023-06-01', NULL),
(15,1, 1700.00, 10, '2023-01-01', NULL);

-- =============================================================================
-- STOCK_UBICACION
-- =============================================================================
INSERT INTO stock_ubicacion (id_producto, id_sede, cantidad) VALUES
-- Almacén Central (id_sede=1)
(1,1,25),(2,1,30),(3,1,40),(4,1,60),(5,1,45),(6,1,20),
(7,1,15),(8,1,50),(9,1,80),(10,1,35),(11,1,100),(12,1,75),
(13,1,40),(14,1,30),(15,1,10),
-- Tienda Valencia (id_sede=2)
(1,2,5),(2,2,3),(3,2,8),(4,2,12),(5,2,8),(7,2,4),
(8,2,10),(9,2,15),(10,2,20),(14,2,5),
-- Tienda Madrid (id_sede=3)
(1,3,4),(2,3,6),(4,3,15),(5,3,10),(6,3,3),(7,3,2),
(9,3,20),(10,3,18),(13,3,8),(15,3,2),
-- Tienda Barcelona (id_sede=4)
(2,4,5),(3,4,10),(4,4,12),(5,4,7),(8,4,8),(9,4,22),
(11,4,30),(12,4,25),(14,4,6);

-- =============================================================================
-- PEDIDOS ONLINE
-- =============================================================================
INSERT INTO pedido_online (id_cliente, id_direccion_entrega, fecha_pedido, estado, total, puntos_canjeados) VALUES
(1, 1, '2024-01-15 10:30:00', 'entregado',       1499.99, 0),
(2, 3, '2024-02-10 14:00:00', 'entregado',       1049.98, 500),
(3, 4, '2024-03-05 09:15:00', 'entregado',        799.99, 0),
(1, 2, '2024-04-20 11:00:00', 'enviado',          849.99, 200),
(4, 5, '2024-05-12 16:30:00', 'en_preparacion',   219.98, 0),
(5, 6, '2024-06-01 08:45:00', 'pendiente',        999.99, 0),
(6, 7, '2024-06-10 13:00:00', 'cancelado',        699.99, 0),
(7, 8, '2024-06-15 10:00:00', 'confirmado',      2499.99, 1000),
(8, 9, '2024-06-18 15:30:00', 'entregado',        369.98, 0),
(2, 3, '2024-06-20 09:00:00', 'pendiente',        299.99, 0);

-- =============================================================================
-- LINEAS DE PEDIDO
-- =============================================================================
INSERT INTO linea_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento_aplicado) VALUES
-- Pedido 1: Laptop gaming
(1, 1, 1, 1499.99, 0),
-- Pedido 2: Laptop Dell + Ratón (con descuento Black Friday)
(2, 2, 1,  980.00, 10.00),
(2, 9, 1,   69.99, 0),
-- Pedido 3: Samsung S24
(3, 4, 1,  799.99, 0),
-- Pedido 4: HP EliteBook
(4, 3, 1,  849.99, 0),
-- Pedido 5: Teclado + Ratón
(5, 8, 1,  149.99, 8.00),
(5, 9, 1,   69.99, 0),
-- Pedido 6: iPhone 15
(6, 5, 1,  999.99, 0),
-- Pedido 7: iPad Air (cancelado)
(7, 6, 1,  699.99, 0),
-- Pedido 8: PC Gamer
(8, 15, 1, 2499.99, 0),
-- Pedido 9: Monitor + Webcam
(9, 7, 1,  549.99, 0),
(9, 13, 1,  79.99, 0),
-- Pedido 10: Auriculares Sony
(10, 14, 1, 299.99, 0);

-- =============================================================================
-- ENVIOS
-- =============================================================================
INSERT INTO envio (id_pedido, id_sede_origen, numero_seguimiento, transportista, fecha_estimada_entrega, fecha_entrega_real, estado) VALUES
(1, 2, 'NX-2024-001-VLC', 'MRW',     '2024-01-18', '2024-01-17', 'entregado'),
(2, 1, 'NX-2024-002-MAD', 'Correos', '2024-02-14', '2024-02-13', 'entregado'),
(3, 3, 'NX-2024-003-BCN', 'Seur',    '2024-03-09', '2024-03-08', 'entregado'),
(4, 1, 'NX-2024-004-VLC', 'DHL',     '2024-04-25', NULL,         'en_transito'),
(9, 1, 'NX-2024-009-BCN', 'MRW',     '2024-06-21', '2024-06-20', 'entregado');

-- =============================================================================
-- LINEAS_ENVIO
-- =============================================================================
INSERT INTO linea_envio (id_envio, id_linea_pedido, cantidad) VALUES
(1, 1, 1),   -- Envío 1 → Línea 1 (laptop gaming)
(2, 2, 1),   -- Envío 2 → Línea 2 (laptop Dell)
(2, 3, 1),   -- Envío 2 → Línea 3 (ratón)
(3, 4, 1),   -- Envío 3 → Línea 4 (S24)
(4, 5, 1),   -- Envío 4 → Línea 5 (HP EliteBook)
(5, 11, 1),  -- Envío 5 → Línea monitor
(5, 12, 1);  -- Envío 5 → Línea webcam

-- =============================================================================
-- VENTAS PRESENCIALES
-- =============================================================================
INSERT INTO venta_presencial (id_sede, id_empleado_vendedor, id_cliente, fecha_venta, total) VALUES
(2, 6, 1,    '2024-01-20 11:30:00', 149.99),  -- Cliente registrado
(2, 7, NULL, '2024-02-14 17:00:00',  69.99),  -- Cliente anónimo
(3, 10, 2,   '2024-03-08 12:00:00', 799.99),  -- Cliente registrado
(4, 12, 3,   '2024-04-01 16:00:00', 299.99),  -- Cliente registrado
(2, 6, NULL, '2024-05-10 10:00:00', 129.99),  -- Cliente anónimo
(3, 10, 5,   '2024-06-05 14:30:00', 549.99);

-- =============================================================================
-- LINEAS DE VENTA PRESENCIAL
-- =============================================================================
INSERT INTO linea_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES
(1, 8,  1, 149.99),   -- Venta 1: Teclado mecánico
(2, 9,  1,  69.99),   -- Venta 2: Ratón gaming
(3, 4,  1, 799.99),   -- Venta 3: Samsung S24
(4, 14, 1, 299.99),   -- Venta 4: Auriculares Sony
(5, 12, 1, 129.99),   -- Venta 5: SSD (anónimo)
(6, 7,  1, 549.99);   -- Venta 6: Monitor

-- =============================================================================
-- DEVOLUCIONES PRESENCIALES
-- =============================================================================
INSERT INTO devolucion_presencial (id_venta, fecha_devolucion, motivo, id_empleado) VALUES
(2, '2024-02-20 10:00:00', 'Producto defectuoso: doble clic en botones', 6),
(4, '2024-04-15 11:30:00', 'Cliente cambió de opinión, no ha abierto el producto', 11);

INSERT INTO linea_devolucion (id_devolucion, id_linea_venta, cantidad) VALUES
(1, 2, 1),   -- Devolución 1: ratón de venta 2
(2, 4, 1);   -- Devolución 2: auriculares de venta 4

-- =============================================================================
-- TICKETS DE INCIDENCIA
-- =============================================================================
INSERT INTO ticket_incidencia (id_cliente, id_pedido, id_agente, asunto, descripcion, estado, fecha_apertura, fecha_cierre, nota_resolucion) VALUES
(1, 1,    13, 'Retraso en entrega',           'El pedido llegó un día tarde pero en buen estado.',      'resuelto', '2024-01-19 09:00:00', '2024-01-19 10:00:00', 'Disculpa enviada al cliente, sin incidencia mayor.'),
(2, 2,    14, 'Laptop con pantalla dañada',   'Al abrir el embalaje la pantalla tenía una grieta.',     'resuelto', '2024-02-14 11:00:00', '2024-02-20 15:00:00', 'Enviado producto de sustitución, recogida del defectuoso.'),
(3, NULL, 13, 'Pregunta sobre garantía',      '¿Cuánto dura la garantía del Samsung S24?',              'resuelto', '2024-03-15 08:00:00', '2024-03-15 08:30:00', 'Informado: 2 años garantía oficial + 1 año NexShop.'),
(4, 5,    14, 'Teclado llegó sin manual',     'No venía el manual de usuario ni el cable USB.',         'en_gestion','2024-05-13 10:00:00', NULL,                  NULL),
(NULL,NULL,13, 'Consulta horario tiendas',    '¿Abren los domingos las tiendas de Madrid y Barcelona?', 'resuelto', '2024-05-20 12:00:00', '2024-05-20 12:10:00', 'Sí, de 11:00 a 20:00 los domingos.'),
(7, 8,    14, 'Falta un componente en PC',    'El PC llegó sin cables SATA incluidos en la descripción.','abierto',  '2024-06-16 09:30:00', NULL,                  NULL);

-- =============================================================================
-- TRANSFERENCIAS DE STOCK
-- =============================================================================
INSERT INTO transferencia_stock (id_producto, id_sede_origen, id_sede_destino, cantidad, fecha, id_empleado_autoriza) VALUES
(4,  1, 3, 10, '2024-03-01 08:00:00', 1),  -- Almacén → Madrid: 10 Samsung S24
(9,  1, 4, 15, '2024-03-15 09:00:00', 1),  -- Almacén → Barcelona: 15 ratones
(1,  1, 2,  3, '2024-04-05 10:00:00', 1),  -- Almacén → Valencia: 3 laptop gaming
(7,  3, 2,  2, '2024-05-10 11:00:00', 9),  -- Madrid → Valencia: 2 monitores
(8,  1, 3, 20, '2024-06-01 08:30:00', 1);  -- Almacén → Madrid: 20 teclados

-- =============================================================================
-- VALORACIONES
-- =============================================================================
INSERT INTO valoracion (id_cliente, id_producto, puntuacion, comentario, fecha, verificada) VALUES
(1, 1, 5, 'Excelente portátil gaming, rendimiento brutal y pantalla increíble.',    '2024-01-25 12:00:00', 1),
(2, 2, 4, 'Muy ligero y potente. El precio es alto pero se justifica.',             '2024-02-20 10:00:00', 1),
(3, 4, 5, 'El Samsung S24 es una pasada. Cámara top y muy fluido.',                '2024-03-20 09:00:00', 1),
(1, 8, 4, 'Buen teclado mecánico. El sonido de las teclas podría ser más suave.',  '2024-01-28 15:00:00', 1),
(4, 8, 5, 'Increíble teclado, muy cómodo para programar largas horas.',            '2024-05-20 11:00:00', 0),
(5, 5, 3, 'Buen móvil pero esperaba más por el precio. La batería decepciona.',     '2024-06-10 16:00:00', 0),
(8, 7, 5, 'Monitor espectacular para diseño. Los colores son fieles y el espacio ultrawide ideal.', '2024-06-22 14:00:00', 1);

-- =============================================================================
-- MOVIMIENTOS DE PUNTOS
-- =============================================================================
INSERT INTO movimiento_puntos (id_cliente, id_pedido, tipo, cantidad_puntos, fecha, descripcion) VALUES
-- Carlos (cliente 1)
(1, 1, 'ganado',   15000, '2024-01-15 10:30:00', 'Compra pedido #1 (1499.99€ × 10)'),
(1, 4, 'ganado',    8500, '2024-04-20 11:00:00', 'Compra pedido #4 (849.99€ × 10)'),
(1, 4, 'canjeado', -2000, '2024-04-20 11:00:00', 'Canje 200 puntos como descuento en pedido #4'),
-- María (cliente 2)
(2, 2, 'ganado',   10500, '2024-02-10 14:00:00', 'Compra pedido #2 (1049.98€ × 10)'),
(2, 2, 'canjeado', -5000, '2024-02-10 14:00:00', 'Canje 500 puntos como descuento en pedido #2'),
(2, 10,'ganado',    3000, '2024-06-20 09:00:00', 'Compra pedido #10 (299.99€ × 10)'),
-- Jorge (cliente 3)
(3, 3, 'ganado',    8000, '2024-03-05 09:15:00', 'Compra pedido #3 (799.99€ × 10)'),
-- Ana (cliente 4)
(4, 5, 'ganado',    2200, '2024-05-12 16:30:00', 'Compra pedido #5 (219.98€ × 10)'),
-- Luis (cliente 7)
(7, 8, 'ganado',   25000, '2024-06-15 10:00:00', 'Compra pedido #8 (2499.99€ × 10)'),
(7, 8, 'canjeado',-10000, '2024-06-15 10:00:00', 'Canje 1000 puntos como descuento en pedido #8'),
-- Elena (cliente 8)
(8, 9, 'ganado',    3700, '2024-06-18 15:30:00', 'Compra pedido #9 (369.98€ × 10)'),
-- Ajuste manual
(1, NULL, 'ajuste', 500, '2024-02-01 08:00:00', 'Puntos de bienvenida por ser cliente desde el inicio');
