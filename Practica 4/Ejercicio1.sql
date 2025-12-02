/*
Cliente = (idCliente, nombre, apellido, DNI, telefono, direccion)
Factura = (nroTicket, total, fecha, hora, idCliente (fk))
Detalle = (nroTicket (fk), idProducto (fk), cantidad, preciounitario)
Producto = (idProducto, nombreP, descripcion, precio, stock)
*/


/* 1. Listar datos personales de clientes cuyo apellido comience con el string ‘Pe’. Ordenar por DNI */

SELECT nombre, apellido, dni, telefono, direccion
FROM Cliente 
WHERE apellido LIKE "Pe%" 
ORDER BY DNI 

/* 2. Listar nombre, apellido, DNI, teléfono y dirección de clientes que realizaron compras solamente
durante 2024. */


(SELECT nombre, apellido, dni, telefono, direccion
FROM Cliente NATURAL JOIN Factura
WHERE Factura.fecha BETWEEN 2024-01-01 AND 2024-12-31)
EXCEPT
(SELECT nombre, apellido, dni, telefono, direccion
FROM Cliente NATURAL JOIN Factura
WHERE ((Factura.fecha <= 2023-12-31) and (Factura.fecha >= 2025-01-01)))

/* 3. Listar nombre, descripción, precio y stock de productos vendidos al cliente con DNI 45789456,
pero que no fueron vendidos a clientes de apellido ‘Garcia’. */

(SELECT nombreP, precio, descripcion, stock
FROM Cliente NATURAL JOIN Factura NATURAL JOIN Detalle NATURAL JOIN Producto
WHERE dni = "45789456")
EXCEPT
(SELECT nombreP, precio, descripcion, stock
FROM Cliente NATURAL JOIN Factura NATURAL JOIN Detalle NATURAL JOIN Producto
WHERE apellido = "Garcia")

/* 4. Listar nombre, descripción, precio y stock de productos no vendidos a clientes que tengan
teléfono con característica 221 (la característica está al comienzo del teléfono). Ordenar por
nombre. */

(SELECT nombreP, precio, descripcion, stock
FROM Producto)
EXCEPT
(SELECT nombreP, precio, descripcion, stock
FROM Cliente NATURAL JOIN Factura NATURAL JOIN Detalle NATURAL JOIN Producto
WHERE telefono LIKE "221%");

/* 5. Listar para cada producto nombre, descripción, precio y cuantas veces fue vendido. Tenga en
cuenta que puede no haberse vendido nunca el producto. */

SELECT nombreP, precioUnitario, descripcion, SUM(cantidad) as cantVendida
FROM Producto LEFT JOIN Detalle ON (Producto.idProducto = Detalle.idProducto)
GROUP BY nombreP, precioUnitario, descripcion

/* 6. Listar nombre, apellido, DNI, teléfono y dirección de clientes que compraron los productos con
nombre ‘prod1’ y ‘prod2’ pero nunca compraron el producto con nombre ‘prod3’. */

SELECT nombre, apellido, DNI, direccion
FROM Cliente NATURAL JOIN Factura NATURAL JOIN Detalle NATURAL JOIN Producto
WHERE nombreP IN ('prod1','prod2')
AND DNI NOT IN (SELECT c.DNI
                FROM Cliente c NATURAL JOIN Factura NATURAL JOIN Detalle NATURAL JOIN Producto paux
                WHERE paux.nombreP = 'prod3')

/* 7. Listar nroTicket, total, fecha, hora y DNI del cliente, de aquellas facturas donde se haya
comprado el producto ‘prod38’ o la factura tenga fecha de 2023. */

SELECT f.nroTicket, f.total, f.fecha, f.hora, c.idCliente
FROM Cliente c NATURAL JOIN Factura f NATURAL JOIN Detalle d NATURAL JOIN Producto p
WHERE p.nombreP = 'prod38' OR f.fecha BETWEEN '2025-01-01' AND '2025-12-31'

/* 8. Agregar un cliente con los siguientes datos: nombre:’Jorge Luis’, apellido:’Castor’, DNI:
40578999, teléfono: ‘221-4400789’, dirección:’11 entre 500 y 501 nro:2587’ y el id de cliente:
500002. Se supone que el idCliente 500002 no existe. */

INSERT INTO Cliente (idCliente, nombre, apellido, DNI, telefono, direccion) 
VALUES (500002, 'Jorge Luis', 'Castor', 40578999, '221-4400789', '11 entre 500 y 501 nro:2587')

/* 9. Listar nroTicket, total, fecha, hora para las facturas del cliente ´Jorge Pérez´ donde no haya
comprado el producto ´Z´. */

(SELECT f.nroTicket, f.total, f.fecha, f.hora
FROM Cliente c NATURAL JOIN Factura f NATURAL JOIN Detalle d NATURAL JOIN Producto p
WHERE c.nombre ='Jorge' AND c.apellido = 'Perez')
EXCEPT
(SELECT f.nroTicket, f.total, f.fecha, f.hora
FROM Cliente c NATURAL JOIN Factura f NATURAL JOIN Detalle d NATURAL JOIN Producto p
WHERE p.nombreP = 'Z' AND c.nombre ='Jorge' AND c.apellido = 'Perez')

/* 10. Listar DNI, apellido y nombre de clientes donde el monto total comprado, teniendo en cuenta
todas sus facturas, supere $100000. */

SELECT DNI, nombre, apellido
FROM Cliente c INNER JOIN Factura f
GROUP BY c.idCliente
HAVING SUM(f.total) > 100000