/*
Agencia = (razon_social, dirección, telef, email)
Ciudad = (codigo_postal, nombreCiudad, anioCreacion)
Cliente = (dni, nombre, apellido, telefono, direccion)
Viaje = (fecha, hora, dni (fk), cpOrigen(fk), cpDestino(fk), razon_social(fk), descripcion) //cpOrigen y
cpDestino corresponden a la ciudades origen y destino del viaje
*/

/* 1. Listar razón social, dirección y teléfono de agencias que realizaron viajes desde la ciudad de ‘La
Plata’ (ciudad origen) y que el cliente tenga apellido ‘Roma’. Ordenar por razón social y luego por
teléfono */

SELECT DISTINCT  a.razon_social, a.direccion, a.telef, co.nombre
FROM Agencia a
INNER JOIN Viaje v ON (v.razon_social = a.razon_social)
INNER JOIN Cliente c ON (v.dni = c.dni)
INNER JOIN Ciudad co ON (co.codigo_postal = v.cpOrigen)
WHERE cd.nombreCiudad = 'La Plata' AND c.apellido = 'Roma'
ORDER BY a.razon_social, a.telef

/* 2. Listar fecha, hora, datos personales del cliente, nombres de ciudades origen y destino de viajes
realizados en enero de 2019 donde la descripción del viaje contenga el String ‘demorado’. */

SELECT v.fecha, v.hora, c.dni, c.nombre, c.apellido, c.telefono, c.direccion, co.nombreCiudad AS nombre_origen, cd.nombreCiudad as nombre_destino
FROM Viaje v
INNER JOIN Cliente c ON (v.dni = c.dni)
INNER JOIN Ciudad co ON (co.codigo_postal = v.cpOrigen)
INNER JOIN Ciudad cd ON (cd.codigo_postal = v.cpDestino)
WHERE YEAR(v.fecha) = 2019 AND MONTH(v.fecha) = 1 AND v.descripcion LIKE "%demorado%"

/* 3. Reportar información de agencias que realizaron viajes durante 2019 o que tengan dirección de
mail que termine con ‘@jmail.com’. */

(SELECT a.razon_social, a.direccion, a.telef, a.email
FROM Agencia a
INNER JOIN Viaje v ON (v.razon_social = a.razon_social)
WHERE YEAR(v.fecha) = 2019)
UNION
(SELECT a.razon_social, a.direccion, a.telef, a.email
FROM Agencia a
WHERE a.email LIKE "%@jmail.com")

/* 4. Listar datos personales de clientes que viajaron solo con destino a la ciudad de ‘Coronel
Brandsen’ */

(SELECT c.dni, c.nombre, c.apellido, c.telefono, c.direccion
FROM Cliente c
INNER JOIN Viaje v ON (v.dni = c.dni)
INNER JOIN Ciudad cd ON (v.cpDestino = cd.codigo_postal)
WHERE cd.nombreCiudad = 'Coronel Brandsen')
EXCEPT
(SELECT c.dni, c.nombre, c.apellido, c.telefono, c.direccion
FROM Cliente c
INNER JOIN Viaje v ON (v.dni = c.dni)
INNER JOIN Ciudad cd ON (v.cpDestino = cd.codigo_postal)
WHERE cd.nombreCiudad <> 'Coronel Brandsen')

/* 5. Informar cantidad de viajes de la agencia con razón social ‘TAXI Y’ realizados a ‘Villa Elisa */

SELECT COUNT(*) as cant_viajes
FROM Agencia a
INNER JOIN Viaje v ON (v.razon_social = a.razon_social)
INNER JOIN Ciudad c ON (c.codigo_postal = v.cpDestino)
WHERE a.razon_social = 'TAXI Y' AND c.nombreCiudad = 'Villa Elisa'

/* 6. Listar nombre, apellido, dirección y teléfono de clientes que viajaron con todas las agencias. */

SELECT c.dni, c.nombre, c.apellido, c.telefono, c.direccion
FROM Cliente c
WHERE NOT EXISTS((SELECT razon_social FROM Agencia a)
                 EXCEPT
                 (SELECT razon_social FROM Viaje v
                  WHERE v.dni = c.dni))

/* 7. Modificar el cliente con DNI 38495444 actualizando el teléfono a ‘221-4400897’. */

UPDATE Cliente SET telefono = '221-4400897' WHERE dni = 38495444

/* 8. Listar razón social, dirección y teléfono de la/s agencias que tengan mayor cantidad de viajes
realizados. */

SELECT a.razon_social, a.direccion, a.telef
FROM Agencia a
INNER JOIN Viaje v ON (a.razon_social = v.razon_social)
GROUP BY a.razon_social, a.direccion, a.telef
HAVING COUNT(*) >= ALL (SELECT COUNT(*) FROM Viaje v2 GROUP BY v2.razon_social)

/* 9. Reportar nombre, apellido, dirección y teléfono de clientes con al menos 5 viajes. */

SELECT c.dni, c.nombre, c.apellido, c.telefono, c.direccion
FROM Cliente c
INNER JOIN Viaje v ON (c.dni = v.dni)
GROUP BY c.dni, c.nombre, c.apellido, c.telefono, c.direccion
HAVING COUNT(*) >= 5

/* 10. Borrar al cliente con DNI 40325692. */

DELETE FROM Viaje v WHERE v.dni = '40325692';
DELETE FROM Cliente c WHERE c.dni = '40325692'; 
