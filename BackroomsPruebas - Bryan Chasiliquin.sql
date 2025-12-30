USE BackroomsDB;

-- ============================================
-- 1. Prueba de inserción válida en Niveles
-- ============================================
INSERT INTO Niveles (NumeroNivel, NombreNivel, Descripcion, ImagenURL) VALUES
('4', 'The Void', 'Un nivel oscuro e infinito sin características discernibles.', 'http://example.com/void.jpg');

-- ============================================
-- 2. Prueba de restricción UNIQUE en NumeroNivel (debe fallar)
-- ============================================
-- Intentar insertar un nivel con NumeroNivel duplicado ('0' ya existe)
INSERT INTO Niveles (NumeroNivel, NombreNivel) VALUES
('0', 'Duplicate Level');

-- ============================================
-- 3. Prueba de NOT NULL en NombreEntidad (debe fallar)
-- ============================================
-- Intentar insertar entidad sin nombre
INSERT INTO Entidades (Descripcion, NivelID, NivelPeligrosidad, TipoComportamiento, FechaAvistamiento) VALUES
('Entidad sin nombre', 1, 'Bajo', 'Pasivo', '2024-06-01');

-- ============================================
-- 4. Prueba de FK: NivelID inexistente en Entidades (debe fallar)
-- ============================================
INSERT INTO Entidades (NombreEntidad, Descripcion, NivelID, NivelPeligrosidad, TipoComportamiento, FechaAvistamiento) VALUES
('Ghost', 'Entidad fantasma en nivel inexistente.', 999, 'Medio', 'Neutral', '2024-06-01');

-- ============================================
-- 5. Prueba de ENUM inválido en NivelPeligrosidad (debe fallar)
-- ============================================
INSERT INTO Entidades (NombreEntidad, Descripcion, NivelID, NivelPeligrosidad, TipoComportamiento, FechaAvistamiento) VALUES
('WeirdEntity', 'Entidad con nivel de peligrosidad inválido.', 1, 'Muy Alto', 'Agresivo', '2024-06-01');

-- ============================================
-- 6. Prueba de inserción válida en Usuarios
-- ============================================
INSERT INTO Usuarios (NombreUsuario, Contraseña, Email, Rol) VALUES
('testuser', 'hashed_password_test', 'testuser@example.com', 'usuario');

-- ============================================
-- 7. Prueba de restricción UNIQUE en NombreUsuario (debe fallar)
-- ============================================
INSERT INTO Usuarios (NombreUsuario, Contraseña) VALUES
('testuser', 'another_password');

-- ============================================
-- 8. Prueba de FK en Encuentros: UsuarioID inexistente (debe fallar)
-- ============================================
INSERT INTO Encuentros (UsuarioID, NivelID, EntidadID, ObjetoID, FechaEncuentro, Descripcion) VALUES
(999, 1, 1, 1, NOW(), 'Encuentro con usuario inexistente.');

-- ============================================
-- 9. Prueba de inserción válida en Encuentros sin EntidadID y ObjetoID (debe funcionar)
-- ============================================
INSERT INTO Encuentros (UsuarioID, NivelID, FechaEncuentro, Descripcion) VALUES
((SELECT UsuarioID FROM Usuarios WHERE NombreUsuario='testuser'), 1, NOW(), 'Encuentro sin entidad ni objeto.');

-- ============================================
-- 10. Prueba de FK en Encuentros: EntidadID y ObjetoID con valor NULL (debe funcionar)
-- ============================================
INSERT INTO Encuentros (UsuarioID, NivelID, EntidadID, ObjetoID, FechaEncuentro, Descripcion) VALUES
((SELECT UsuarioID FROM Usuarios WHERE NombreUsuario='testuser'), 1, NULL, NULL, NOW(), 'Encuentro sin entidad ni objeto.');

-- ============================================
-- 11. Prueba de inserción válida en Objetos
-- ============================================
INSERT INTO Objetos (NombreObjeto, Descripcion, NivelID, ImagenURL) VALUES
('Mystic Orb', 'Una esfera que emite una luz tenue.', 2, 'http://example.com/mystic_orb.jpg');

-- ============================================
-- 12. Prueba de FK: NivelID inexistente en Objetos (debe fallar)
-- ============================================
INSERT INTO Objetos (NombreObjeto, NivelID) VALUES
('Phantom Key', 999);

-- ============================================
-- 13. Prueba de restricción UNIQUE en NombreObjeto (debe fallar)
-- ============================================
INSERT INTO Objetos (NombreObjeto, NivelID) VALUES
('Mystic Orb', 2);

-- ============================================
-- 14. Limpiar datos de prueba válidos para no afectar la base
-- ============================================
DELETE FROM Encuentros WHERE Descripcion LIKE '%testuser%';
DELETE FROM Usuarios WHERE NombreUsuario='testuser';
DELETE FROM Objetos WHERE NombreObjeto='Mystic Orb';
DELETE FROM Niveles WHERE NumeroNivel='4';