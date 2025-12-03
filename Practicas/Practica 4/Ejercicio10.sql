/*
Vehiculo = (patente, modelo, marca, peso, km)
Camion = (patente(fk), largo, max_toneladas, cant_ruedas, tiene_acoplado)
Auto = (patente(fk), es_electrico, tipo_motor)
Service = (fecha, patente(fk), km_service, descripcion, monto)
Parte = (cod_parte, nombre, precio_parte)
Service_Parte = ([fecha, patente](fk), cod_parte(fk), precio)
*/

/* 1. Listar todos los datos de aquellos camiones que tengan entre 4 y 8 ruedas, y que hayan
realizado algún service en los últimos 365 días. Ordenar por marca, modelo y patente. */

SELECT DISTINCT v.patente, v.modelo, v.marca, v.peso, v.km, c.largo, c.max_toneladas, c.cant_ruedas, c.tiene_acoplado
FROM Camion c 
INNER JOIN Vehiculo v ON (v.patente = c.patente)
INNER JOIN Service s ON (s.patente = c.patente)
WHERE (cant_ruedas BETWEEN 4 AND 8) AND (s.fecha > '2024-11-10') --No se como hacer para comparar con la fecha actual :'(
ORDER BY v.modelo, v.modelo, v.patente

/* 2. Listar los autos que hayan realizado el service “cambio de aceite” antes de los 13.000 km o
hayan realizado el service “inspección general” que incluya la parte “filtro de combustible”. */

(SELECT v.patente, v.modelo, v.marca, v.peso, v.km, a.es_electrico, a.tipo_motor
FROM Auto a
INNER JOIN Vehiculo v ON (a.patente = v.patente)
INNER JOIN Service s ON (s.patente = v.patente)
WHERE s.km_service < 13000 AND s.descripcion = 'cambio de aceite')
UNION
(SELECT v.patente, v.modelo, v.marca, v.peso, v.km, a.es_electrico, a.tipo_motor
FROM Auto a
INNER JOIN Vehiculo v ON (a.patente = v.patente)
INNER JOIN Service s ON (s.patente = v.patente)
WHERE s.descripcion = 'inspeccion general' AND EXISTS (SELECT * FROM Service_Parte sp2
                                                       NATURAL JOIN Parte p 
                                                       WHERE sp2.patente = s.patente AND sp2.fecha = s.fecha 
                                                       AND p.nombre = 'filtro de combustible'))
-- Perdi años de vida haciendo esto

/* 3. Listar nombre y precio de todas las partes que aparezcan en más de 30 services que hayan
salido (partes) más de $4.000. */

SELECT p.nombre, p.precio_parte
FROM Parte p
INNER JOIN Service_Parte sp ON (p.cod_parte = sp.cod_parte)
WHERE sp.precio > 4000
GROUP BY p.cod_parte, p.nombre, p.precio_parte
HAVING COUNT(*) > 30

/* 5. Listar el nombre y precio de aquellas partes que figuren en todos los service realizados en el año
actual. */

SELECT p.nombre, p.precio_parte
FROM Parte p
WHERE NOT EXISTS((SELECT s.fecha, s.patente FROM Service s WHERE YEAR(s.fecha) = 2025)
                  EXCEPT
                  (SELECT sp.fecha, sp.patente FROM Service_Parte sp
                   WHERE (sp.cod_parte = p.cod_parte)))



