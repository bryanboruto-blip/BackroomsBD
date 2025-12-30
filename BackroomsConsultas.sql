CREATE DATABASE BackroomsDB;
USE BackroomsDB;

-- Tabla de Niveles
CREATE TABLE Niveles (
    id_nivel INT PRIMARY KEY,
    nombre VARCHAR(100),
    clase_supervivencia INT, -- Escala de 0 a 5
    descripcion TEXT
);

-- Tabla de Entidades
CREATE TABLE Entidades (
    id_entidad INT PRIMARY KEY,
    nombre VARCHAR(100),
    nivel_amenaza INT, -- Escala de 0 a 7
    habitat_principal INT,
    FOREIGN KEY (habitat_principal) REFERENCES Niveles(id_nivel)
);

-- Tabla de Objetos
CREATE TABLE Objetos (
    id_objeto INT PRIMARY KEY,
    nombre VARCHAR(100),
    rareza VARCHAR(50),
    propiedades TEXT
);

INSERT INTO Niveles VALUES (0, 'Nivel Tutorial', 1, 'Espacio lineal infinito de paredes amarillas');
INSERT INTO Entidades VALUES (3, 'Smilers', 4, 0);
INSERT INTO Objetos VALUES (99, 'Hermes Device', 'Muy Raro', 'Permite glitchear entre niveles');

SELECT nombre FROM Entidades WHERE habitat_principal = 0;
SELECT * FROM Objetos WHERE rareza = 'Muy Raro';
SELECT nombre, clase_supervivencia FROM Niveles WHERE clase_supervivencia > 3;
