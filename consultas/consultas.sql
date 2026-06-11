-- =============================================================================
--  NexShop Group S.A. — Batería de 14 Consultas MySQL
--  Autor: Sara
--  Cada consulta incluye un comentario explicando qué devuelve y para qué sirve.
-- =============================================================================

USE nexshop;

-- =============================================================================
-- CONSULTA 1: Mostrar todos los registros de una tabla relevante
-- Devuelve todos los empleados del sistema con todos sus datos.
-- Útil para el departamento de RRHH o para auditorías internas.
-- =============================================================================
SELECT * FROM empleado;


-- =============================================================================
-- CONSULTA 2: Seleccionar solo campos concretos de una tabla
-- Devuelve solo el nombre, apellidos y email de los clientes registrados.
-- Útil para marketing: lista de contactos para campañas de email.
-- =============================================================================
SELECT nombre, apellidos, email
FROM cliente
WHERE tipo = 'registrado';


-- =============================================================================
-- CONSULTA 3: Filtrar registros por un valor exacto con WHERE
-- Devuelve todos los pedidos online que están en estado 'pendiente'.
-- Útil para el equipo de logística para priorizar pedidos a procesar.
-- =============================================================================
SELECT id_pedido, id_cliente, fecha_pedido, total
FROM pedido_online
WHERE estado = 'pendiente';


-- =============================================================================
-- CONSULTA 4: Filtrar usando LIKE para buscar un patrón en un campo de texto
-- Busca todos los productos cuyo nombre contenga la palabra 'gaming' (sin distinguir mayúsculas).
-- Útil para el equipo de marketing al gestionar campañas de productos gaming.
-- =============================================================================
SELECT id_producto, nombre, pvp
FROM producto
WHERE nombre LIKE '%gaming%'
   OR nombre LIKE '%Gaming%';


-- =============================================================================
-- CONSULTA 5: Filtrar usando LIKE para registros que empiecen por una letra
-- Devuelve los clientes registrados cuyo nombre empiece por 'A'.
-- Útil para búsquedas alfabéticas en el sistema de atención al cliente.
-- =============================================================================
SELECT id_cliente, nombre, apellidos, email
FROM cliente
WHERE nombre LIKE 'A%'
  AND tipo = 'registrado';


-- =============================================================================
-- CONSULTA 6: Filtrar por un rango de fechas con BETWEEN
-- Devuelve todos los pedidos online realizados entre el 01/03/2024 y el 30/06/2024.
-- Útil para informes trimestrales de ventas online del Q2 2024.
-- =============================================================================
SELECT id_pedido, id_cliente, fecha_pedido, estado, total
FROM pedido_online
WHERE fecha_pedido BETWEEN '2024-03-01 00:00:00' AND '2024-06-30 23:59:59'
ORDER BY fecha_pedido;


-- =============================================================================
-- CONSULTA 7: Filtrar por un rango numérico con BETWEEN
-- Devuelve los productos cuyo precio de venta al público esté entre 100€ y 600€.
-- Útil para mostrar el catálogo de gama media al equipo comercial.
-- =============================================================================
SELECT id_producto, nombre, pvp, activo
FROM producto
WHERE pvp BETWEEN 100.00 AND 600.00
ORDER BY pvp;


-- =============================================================================
-- CONSULTA 8: Filtrar por una condición numérica mayor que un valor
-- Devuelve las líneas de pedido donde se compraron más de 1 unidad del mismo producto.
-- Útil para detectar compras en volumen y aplicar descuentos por cantidad.
-- =============================================================================
SELECT lp.id_linea, lp.id_pedido, p.nombre AS producto, lp.cantidad, lp.precio_unitario
FROM linea_pedido lp
JOIN producto p ON lp.id_producto = p.id_producto
WHERE lp.cantidad > 1;


-- =============================================================================
-- CONSULTA 9: Ordenar resultados de forma ascendente con ORDER BY
-- Devuelve todos los pedidos online ordenados del más antiguo al más reciente.
-- Útil para ver el histórico cronológico de pedidos en atención al cliente.
-- =============================================================================
SELECT id_pedido, id_cliente, fecha_pedido, estado, total
FROM pedido_online
ORDER BY fecha_pedido ASC;


-- =============================================================================
-- CONSULTA 10: Ordenar resultados de forma descendente con ORDER BY
-- Devuelve todos los productos ordenados de mayor a menor precio de venta.
-- Útil para la web: sección "Ordenar por precio: mayor a menor".
-- =============================================================================
SELECT id_producto, nombre, pvp
FROM producto
WHERE activo = 1
ORDER BY pvp DESC;


-- =============================================================================
-- CONSULTA 11: Ordenar alfabéticamente por un campo de texto
-- Devuelve los clientes registrados ordenados alfabéticamente por apellidos y luego por nombre.
-- Útil para listas impresas o exportaciones en atención al cliente.
-- =============================================================================
SELECT id_cliente, apellidos, nombre, email
FROM cliente
WHERE tipo = 'registrado'
ORDER BY apellidos ASC, nombre ASC;


-- =============================================================================
-- CONSULTA 12: Actualizar un campo de un registro concreto con UPDATE
-- Cambia el estado del pedido #4 a 'entregado' y registra la fecha de entrega real.
-- Útil cuando el sistema de transporte confirma la entrega de un pedido.
-- =============================================================================
UPDATE envio
SET estado             = 'entregado',
    fecha_entrega_real = CURDATE()
WHERE id_pedido = 4;

-- Verificación del cambio:
SELECT id_envio, id_pedido, estado, fecha_entrega_real FROM envio WHERE id_pedido = 4;


-- =============================================================================
-- CONSULTA 13: Actualizar un campo usando WHERE para identificar el registro
-- Modifica el rol del empleado con id_empleado = 6 a 'encargada'.
-- Útil cuando una vendedora asciende a encargada en una tienda física.
-- =============================================================================
UPDATE empleado
SET rol = 'encargada'
WHERE id_empleado = 6;

-- Verificación del cambio:
SELECT id_empleado, nombre, apellidos, rol FROM empleado WHERE id_empleado = 6;


-- =============================================================================
-- CONSULTA 14: Combinar dos tablas relacionadas con JOIN
-- Muestra el nombre completo del cliente junto con sus pedidos online:
-- número de pedido, fecha, estado y total de cada pedido.
-- Útil para atención al cliente cuando un agente busca el historial de un cliente.
-- =============================================================================
SELECT
    c.id_cliente,
    c.nombre,
    c.apellidos,
    c.email,
    po.id_pedido,
    po.fecha_pedido,
    po.estado,
    po.total
FROM cliente c
JOIN pedido_online po ON c.id_cliente = po.id_cliente
ORDER BY c.apellidos, po.fecha_pedido DESC;
