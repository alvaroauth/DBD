/*
Banda = (codigoB, nombreBanda, genero_musical, anio_creacion)
Integrante = (DNI, nombre, apellido, dirección, email, fecha_nacimiento, codigoB(fk))
Escenario = (nroEscenario, nombre_escenario, ubicación, cubierto, m2, descripción)
Recital = (fecha, hora, nroEscenario (fk), codigoB (fk))
*/

/* 1. Listar DNI, nombre, apellido, dirección y email de integrantes nacidos entre 1980 y 1990 y que
hayan realizado algún recital durante 2023. */

SELECT DISTINCT i.DNI, i.nombre, i.apellido, i.direccion, i.email
FROM Integrante i
INNER JOIN Recital r ON i.codigoB = r.codigoB
WHERE i.fecha_nacimiento BETWEEN '1980-01-01' AND '1990-12-31'
  AND r.fecha BETWEEN '2023-01-01' AND '2023-12-31'

/* 2. Reportar nombre, género musical y año de creación de bandas que hayan realizado recitales
durante 2023, pero no hayan tocado durante 2022 . */

(SELECT b.nombreBanda, b.genero_musical, b.anio_creacion
FROM Banda b INNER JOIN Recital r ON (r.codigoB = b.codigoB)
WHERE YEAR(r.fecha) = 2023)
EXCEPT
(SELECT b.nombreBanda, b.genero_musical, b.anio_creacion
FROM Banda b INNER JOIN Recital r ON (r.codigoB = b.codigoB)
WHERE YEAR(r.fecha) = 2022)

/* 3. Listar el cronograma de recitales del día 04/12/2023. Se deberá listar nombre de la banda que
ejecutará el recital, fecha, hora, y el nombre y ubicación del escenario correspondiente. */

SELECT b.nombreBanda, r.fecha, r.hora, e.nombre_escenario, e.ubicacion
FROM Banda b INNER JOIN Recital r ON (b.codigoB = r.codigoB)
INNER JOIN Escenario e ON (e.nroEscenario = r.nroEscenario)
WHERE r.fecha = '2023-12-04'

/* 4. Listar DNI, nombre, apellido,email de integrantes que hayan tocado en el escenario con nombre
‘Gustavo Cerati’ y en el escenario con nombre ‘Carlos Gardel’. */

(SELECT i.DNI, i.nombre, i.apellido, i.email
FROM Integrante i
INNER JOIN Recital r ON (i.codigoB = r.codigoB)
INNER JOIN Escenario e ON (e.nroEscenario = r.nroEscenario)
WHERE e.nombre_escenario = 'Gustavo Cerati')
INTERSECT
(SELECT i.DNI, i.nombre, i.apellido, i.email
FROM Integrante i
INNER JOIN Recital r ON (i.codigoB = r.codigoB)
INNER JOIN Escenario e ON (e.nroEscenario = r.nroEscenario)
WHERE e.nombre_escenario = 'Carlos Gardel')

/* 5. Reportar nombre, género musical y año de creación de bandas que tengan más de 5 integrantes. */

SELECT b.nombreBanda, b.genero_musical, b.anio_creacion
FROM Banda b INNER JOIN Integrante i ON (i.codigoB = b.codigoB)
GROUP BY b.codigoB, b.nombreBanda, b.genero_musical, b.anio_creacion
HAVING COUNT(i.DNI)>5

/* 6. Listar nombre de escenario, ubicación y descripción de escenarios que solo tuvieron recitales
con el género musical rock and roll. Ordenar por nombre de escenario */

(SELECT e.nombre_escenario, e.ubicacion, e.descripcion
FROM Escenario e
INNER JOIN Recital r ON (r.nroEscenario = e.nroEscenario)
INNER JOIN Banda b ON (r.codigoB = b.codigoB)
WHERE b.genero_musical = 'Rock And Roll')
EXCEPT
(SELECT e.nombre_escenario, e.ubicacion, e.descripcion
FROM Escenario e
INNER JOIN Recital r ON (r.nroEscenario = e.nroEscenario)
INNER JOIN Banda b ON (r.codigoB = b.codigoB)
WHERE b.genero_musical <> 'Rock And Roll')
ORDER BY nombre_escenario

/* 7. Listar nombre, género musical y año de creación de bandas que hayan realizado recitales en
escenarios cubiertos durante 2023. */

SELECT DISTINCT b.nombreBanda, b.genero_musical, b.anio_creacion
FROM Banda b 
INNER JOIN Recital r ON (b.codigoB = r.codigoB)
INNER JOIN Escenario e ON (r.nroEscenario = e.nroEscenario)
WHERE YEAR(r.fecha) = 2023 AND e.cubierto = true

/* 8. Reportar para cada escenario, nombre del escenario y cantidad de recitales durante 2024. */

SELECT e.nombre_escenario, e.ubicacion, e.descripcion, COUNT(r.fecha) AS cant_recitales
FROM Escenario e LEFT JOIN Recital r ON (e.nroEscenario = r.nroEscenario)
WHERE YEAR(r.fecha) = 2024
GROUP BY e.nroEscenario, e.nombre_escenario, e.ubicacion, e.descripcion

/* 9. Modificar el nombre de la banda ‘Mempis la Blusera’ a: ‘Memphis la Blusera’. */

UPDATE Banda SET nombreBanda = 'Mempihs la Blusera' WHERE nombreBanda = 'Mempis la Blusera'