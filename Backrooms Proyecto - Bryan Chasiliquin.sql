CREATE DATABASE IF NOT EXISTS BackroomsDB;
USE BackroomsDB;

-- 1. Niveles: Almacena la información principal de cada plano
CREATE TABLE Niveles (
    nivel_id INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    clase_supervivencia INT CHECK (clase_supervivencia BETWEEN 0 AND 5), -- Escala 0-5
    descripcion TEXT,
    clima_definido BOOLEAN DEFAULT FALSE
);

INSERT INTO Niveles (nivel_id, nombre, clase_supervivencia, descripcion) VALUES
(0, 'The Lobby', 1, 'Laberinto infinito de oficinas amarillas y luces fluorescentes.'),
(1, 'Habitable Zone', 1, 'Almacén masivo con suministros básicos.'),
(2, 'Pipe Dreams', 2, 'Túneles de mantenimiento largos y calurosos.');

select * from Niveles

-- 2. Entidades: Criaturas que habitan los niveles
CREATE TABLE Entidades (
    entidad_id INT PRIMARY KEY AUTO_INCREMENT,
    numero_entidad INT UNIQUE,
    nombre VARCHAR(100),
    habitat_principal INT,
    peligrosidad VARCHAR(50),
    FOREIGN KEY (habitat_principal) REFERENCES Niveles(nivel_id)
);

INSERT INTO Entidades (numero_entidad, nombre, habitat_principal, peligrosidad) VALUES
(3, 'Smilers', 0, 'Alta'),
(5, 'Skin-Stealers', 1, 'Extrema');

select * from Entidades

-- 3. Objetos: Ítems encontrados (ej. Agua de Almendras)
CREATE TABLE Objetos (
    objeto_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100),
    rareza VARCHAR(50),
    efectos TEXT
);

-- 4. Conexiones: Define entradas y salidas entre niveles
CREATE TABLE Conexiones (
    origen_id INT,
    destino_id INT,
    metodo_acceso VARCHAR(100), -- Ej: "No-clipping"
    PRIMARY KEY (origen_id, destino_id),
    FOREIGN KEY (origen_id) REFERENCES Niveles(nivel_id),
    FOREIGN KEY (destino_id) REFERENCES Niveles(nivel_id)
);

NSERT INTO Conexiones (origen_id, destino_id, metodo_acceso) VALUES
(0, 1, 'Hacer no-clip en una pared más oscura'),
(1, 2, 'Caminar por un pasillo extenso');

select * from Conexiones 