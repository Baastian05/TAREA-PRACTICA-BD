CREATE TABLE PROPIETARIO (
    id_propietario NUMBER PRIMARY KEY,
    cedula VARCHAR2(10) NOT NULL UNIQUE,
    nombres VARCHAR2(80) NOT NULL,
    telefono VARCHAR2(15),
    ciudad VARCHAR2(50) NOT NULL,
    correo VARCHAR2(100) UNIQUE
);

CREATE TABLE ESPECIE (
    id_especie NUMBER PRIMARY KEY,
    nombre_especie VARCHAR2(50) NOT NULL UNIQUE
);

CREATE TABLE MASCOTA (
    id_mascota NUMBER PRIMARY KEY,
    nombre_mascota VARCHAR2(60) NOT NULL,
    raza VARCHAR2(60),
    edad NUMBER(3) NOT NULL,
    peso NUMBER(5,2) NOT NULL,
    id_propietario NUMBER NOT NULL,
    id_especie NUMBER NOT NULL
);

CREATE TABLE ESPECIALIDAD (
    id_especialidad NUMBER PRIMARY KEY,
    nombre_especialidad VARCHAR2(80) NOT NULL UNIQUE
);

CREATE TABLE VETERINARIO (
    id_veterinario NUMBER PRIMARY KEY,
    nombres VARCHAR2(80) NOT NULL,
    cedula VARCHAR2(10) NOT NULL UNIQUE,
    sueldo NUMBER(8,2) NOT NULL
);

CREATE TABLE CONSULTA (
    id_consulta NUMBER PRIMARY KEY,
    fecha_consulta DATE NOT NULL,
    diagnostico VARCHAR2(150) NOT NULL,
    costo NUMBER(8,2) NOT NULL,
    estado VARCHAR2(30) NOT NULL,
    id_mascota NUMBER,
    id_veterinario NUMBER,
    id_especialidad NUMBER
);

INSERT INTO PROPIETARIO VALUES (1, '1801111111', 'Carlos Pérez', '0991111111', 'Ambato', 'carlos@mail.com');
INSERT INTO PROPIETARIO VALUES (2, '1802222222', 'María López', '0992222222', 'Quito', 'maria@mail.com');

INSERT INTO ESPECIE VALUES (1, 'Perro');
INSERT INTO ESPECIE VALUES (2, 'Gato');

INSERT INTO MASCOTA VALUES (1, 'Max', 'Labrador', 5, 28.5, 1, 1);
INSERT INTO MASCOTA VALUES (2, 'Luna', 'Siamés', 3, 5.2, 2, 2);

INSERT INTO ESPECIALIDAD VALUES (1, 'Medicina General');
INSERT INTO ESPECIALIDAD VALUES (2, 'Cirugía');

INSERT INTO VETERINARIO VALUES (1, 'Dr. Andrés Ramos', '1701111111', 1200);
INSERT INTO VETERINARIO VALUES (2, 'Dra. Paola Vega', '1702222222', 1500);

INSERT INTO CONSULTA VALUES (1, SYSDATE, 'Fiebre leve', 50, 'Atendido', 1, 1, 1);
INSERT INTO CONSULTA VALUES (2, SYSDATE, 'Infección', 80, 'Atendido', 2, 2, 2);
INSERT INTO CONSULTA VALUES (3, SYSDATE, 'Control general', 30, 'Pendiente', 1, 1, 1);

ALTER TABLE CONSULTA ADD tratamiento VARCHAR2(150);

UPDATE CONSULTA 
SET tratamiento = 'Antibióticos'
WHERE id_consulta = 1;

SELECT * FROM PROPIETARIO;

SELECT *
FROM MASCOTA
WHERE edad > 4;

SELECT *
FROM CONSULTA
ORDER BY costo;

SELECT m.nombre_mascota, p.nombres, p.ciudad
FROM MASCOTA m
INNER JOIN PROPIETARIO p 
ON m.id_propietario = p.id_propietario;

SELECT c.id_consulta, m.nombre_mascota, v.nombres, e.nombre_especialidad
FROM CONSULTA c
INNER JOIN MASCOTA m ON c.id_mascota = m.id_mascota
INNER JOIN VETERINARIO v ON c.id_veterinario = v.id_veterinario
INNER JOIN ESPECIALIDAD e ON c.id_especialidad = e.id_especialidad;

SELECT id_especie, COUNT(*) AS total
FROM MASCOTA
GROUP BY id_especie;

SELECT id_especie, COUNT(*) AS total
FROM MASCOTA
GROUP BY id_especie
HAVING COUNT(*) > 1;

SELECT *
FROM CONSULTA
WHERE costo > (SELECT AVG(costo) FROM CONSULTA);

SELECT v.nombres, SUM(c.costo) AS total
FROM CONSULTA c
INNER JOIN VETERINARIO v ON c.id_veterinario = v.id_veterinario
GROUP BY v.nombres;

SELECT v.nombres, SUM(c.costo) AS total_generado
FROM CONSULTA c
INNER JOIN VETERINARIO v 
ON c.id_veterinario = v.id_veterinario
GROUP BY v.nombres
HAVING SUM(c.costo) > (
    SELECT AVG(total)
    FROM (
        SELECT SUM(costo) AS total
        FROM CONSULTA
        GROUP BY id_veterinario
    )
);

SELECT p.nombres, m.nombre_mascota, e.nombre_especie, c.diagnostico, c.tratamiento
FROM CONSULTA c
INNER JOIN MASCOTA m ON c.id_mascota = m.id_mascota
INNER JOIN PROPIETARIO p ON m.id_propietario = p.id_propietario
INNER JOIN ESPECIE e ON m.id_especie = e.id_especie;

SELECT *
FROM MASCOTA
WHERE peso > 10;

SELECT *
FROM VETERINARIO
WHERE sueldo > 1300;

SELECT *
FROM MASCOTA
ORDER BY nombre_mascota;

SELECT *
FROM CONSULTA
WHERE costo BETWEEN 30 AND 100;

SELECT *
FROM PROPIETARIO
WHERE ciudad = 'Ambato';

SELECT AVG(costo) AS promedio
FROM CONSULTA;

SELECT MAX(costo) AS maximo, MIN(costo) AS minimo
FROM CONSULTA;

SELECT m.nombre_mascota, COUNT(c.id_consulta) AS total
FROM CONSULTA c
INNER JOIN MASCOTA m ON c.id_mascota = m.id_mascota
GROUP BY m.nombre_mascota;

SELECT v.nombres, SUM(c.costo) AS total
FROM CONSULTA c
INNER JOIN VETERINARIO v ON c.id_veterinario = v.id_veterinario
GROUP BY v.nombres
HAVING SUM(c.costo) > 100;

SELECT m.nombre_mascota, c.costo
FROM CONSULTA c
INNER JOIN MASCOTA m ON c.id_mascota = m.id_mascota
WHERE c.costo = (SELECT MAX(costo) FROM CONSULTA);

SELECT c.*
FROM CONSULTA c
INNER JOIN ESPECIALIDAD e ON c.id_especialidad = e.id_especialidad
WHERE e.nombre_especialidad = 'Medicina General';

SELECT p.nombres, COUNT(m.id_mascota) AS total_mascotas
FROM PROPIETARIO p
INNER JOIN MASCOTA m ON p.id_propietario = m.id_propietario
GROUP BY p.nombres;

SELECT c.id_consulta, m.nombre_mascota, c.tratamiento
FROM CONSULTA c
INNER JOIN MASCOTA m ON c.id_mascota = m.id_mascota;

SELECT *
FROM CONSULTA
WHERE costo < (SELECT AVG(costo) FROM CONSULTA);

SELECT SUM(costo) AS total_general
FROM CONSULTA;

SELECT p.nombres, SUM(c.costo) AS total_gastado
FROM PROPIETARIO p
INNER JOIN MASCOTA m ON p.id_propietario = m.id_propietario
INNER JOIN CONSULTA c ON m.id_mascota = c.id_mascota
GROUP BY p.nombres;

SELECT m.nombre_mascota, COUNT(c.id_consulta) AS total_consultas
FROM MASCOTA m
INNER JOIN CONSULTA c ON m.id_mascota = c.id_mascota
GROUP BY m.nombre_mascota
HAVING COUNT(c.id_consulta) > (
    SELECT AVG(total)
    FROM (
        SELECT COUNT(id_consulta) AS total
        FROM CONSULTA
        GROUP BY id_mascota
    )
);

SELECT v.nombres, SUM(c.costo) AS total_generado
FROM VETERINARIO v
INNER JOIN CONSULTA c ON v.id_veterinario = c.id_veterinario
GROUP BY v.nombres
HAVING SUM(c.costo) = (
    SELECT MAX(total)
    FROM (
        SELECT SUM(costo) AS total
        FROM CONSULTA
        GROUP BY id_veterinario
    )
);

SELECT p.nombres, COUNT(m.id_mascota) AS total_mascotas
FROM PROPIETARIO p
INNER JOIN MASCOTA m ON p.id_propietario = m.id_propietario
GROUP BY p.nombres
HAVING COUNT(m.id_mascota) > 1;

SELECT e.nombre_especie, AVG(c.costo) AS promedio_costo
FROM ESPECIE e
INNER JOIN MASCOTA m ON e.id_especie = m.id_especie
INNER JOIN CONSULTA c ON m.id_mascota = c.id_mascota
GROUP BY e.nombre_especie;