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
(3, 'Electrical Station', 'Un laberinto de pasillos oscuros con constantes descargas eléctricas.', 'http://example.com/nivel3.jpg');

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
(5, 'Skin-Stealers', 1, 'Extrema'),
(17'Crawler', 'Una criatura que se arrastra por los pasillos y ataca a sus víctimas desde abajo.', 2, 'http://example.com/crawler.jpg', 'Medio', 'Agresivo', '2024-02-20'),
(65'The Mannequin', 'Una figura humanoide que permanece inmóvil hasta que se le da la espalda.', 1, 'http://example.com/mannequin.jpg', 'Bajo', 'Pasivo', '2024-03-10'),
(8'Hounds', 'Entidades caninas que cazan en manada.', 3, 'http://example.com/hounds.jpg', 'Alto', 'Agresivo', '2024-04-05'),
(96'Watchers', 'Seres que observan desde las sombras, raramente interactúan directamente.', 2, 'http://example.com/watchers.jpg', 'Medio', 'Neutral', '2024-05-12');

select * from Entidades

-- Tabla Usuarios
CREATE TABLE Usuarios (
    UsuarioID INT AUTO_INCREMENT PRIMARY KEY,
    NombreUsuario VARCHAR(50) NOT NULL UNIQUE,
    Contraseña VARCHAR(255) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    Rol ENUM('administrador', 'usuario') NOT NULL DEFAULT 'usuario'
);


INSERT INTO Usuarios (NombreUsuario, Contraseña, Email, Rol) VALUES
('Usuario1', 'hashed_password_1', 'usuario1@example.com', 'usuario'),
('Usuario2', 'hashed_password_2', 'usuario2@example.com', 'usuario'),
('Usuario3', 'hashed_password_3', 'usuario3@example.com', 'administrador');

select * from Usuarios

-- 3. Objetos: Ítems encontrados (ej. Agua de Almendras)
CREATE TABLE Objetos (
    objeto_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100),
    rareza VARCHAR(50),
    efectos TEXT
);
INSERT INTO Objetos (NombreObjeto, Descripcion, NivelID, ImagenURL) VALUES
('Objeto1', 'Objeto misterioso encontrado en el Nivel 0.', 1, 'http://example.com/objeto1.jpg'),
('Objeto2', 'Herramienta extraña ubicada en el Nivel 1.', 2, 'http://example.com/objeto2.jpg'),
('Objeto3', 'Artefacto antiguo descubierto en el Nivel 0.', 1, 'http://example.com/objeto3.jpg'),
('Objeto4', 'Objeto peligroso en el Nivel 3.', 3, 'http://example.com/objeto4.jpg'),
('Objeto5', 'Objeto enigmático del Nivel 1.', 2, 'http://example.com/objeto5.jpg');

select * from Objetos

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

-- comando OR 

SELECT * FROM Entidades 
WHERE clase = 'Clase 5' OR nivel_peligro = 'Extremo';

SELECT nombre_nivel, tipo 
FROM Niveles 
WHERE tipo = 'Infinito' OR categoria = 'Subnivel';

SELECT * FROM Objetos 
WHERE propiedad = 'Seguro' 
AND (ubicacion = 'Nivel 0' OR ubicacion = 'Nivel 1');

SELECT * FROM Entidades 
WHERE nombre = 'Smiler' OR nombre = 'Skin-Stealer' OR nombre = 'Hound';
SELECT * FROM Entidades 
WHERE nombre IN ('Smiler', 'Skin-Stealer', 'Hound');

-- comando JOIN

CREATE DATABASE BackroomsDB;
USE BackroomsDB;

-- Tabla de Niveles
CREATE TABLE niveles (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100),
    clase_seguridad VARCHAR(50),
    descripcion TEXT
);

-- Tabla de Entidades
CREATE TABLE entidades (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100),
    tipo VARCHAR(50),
    nivel_id INT,
    FOREIGN KEY (nivel_id) REFERENCES niveles(id)
);

INSERT INTO niveles (nombre, clase_seguridad) VALUES 
('Nivel 0: El Lobby', 'Clase 1 (Seguro)'),
('Nivel 6: Luces Fuera', 'Clase 5 (Inhabitable)');

INSERT INTO entidades (nombre, tipo, nivel_id) VALUES 
('Bacteria', 'Humanoide', 1),
('Smiler', 'Hostil', 2),
('Skin-Stealer', 'Hostil', 2);

SELECT 
    niveles.nombre AS Nivel, 
    niveles.clase_seguridad AS Seguridad, 
    entidades.nombre AS Entidad, 
    entidades.tipo AS Tipo_Entidad
FROM niveles
JOIN entidades ON niveles.id = entidades.nivel_id;

-----
SELECT
    nombre_nivel,
    fecha_descubrimiento,
    CURDATE() AS fecha_actual,
    DATEDIFF(CURDATE(), fecha_descubrimiento) AS dias_desde_descubrimiento
FROM
    Niveles;

SELECT
    nombre_explorador,
    fecha_ingreso
FROM
    Exploradores
WHERE
    fecha_ingreso BETWEEN '2023-01-01' AND '2023-12-31';

SELECT
    nombre_nivel
FROM
    Niveles
WHERE
    fecha_descubrimiento IS NOT NULL; -- Niveles con fecha de descubrimiento conocida

SELECT
    nombre_nivel
FROM
    Niveles
WHERE
    fecha_descubrimiento IS NULL; -- Niveles sin fecha de descubrimiento conocida

SELECT DISTINCT
    nivel_peligro
FROM
    Entidades;

SELECT
    nombre_entidad,
    nivel_peligro,
    CASE
        WHEN nivel_peligro = 'Alto' THEN '¡Extremadamente peligroso!'
        WHEN nivel_peligro = 'Medio' THEN 'Peligroso, precaución.'
        ELSE 'Poco peligroso.'
    END AS advertencia
FROM
    Entidades;
