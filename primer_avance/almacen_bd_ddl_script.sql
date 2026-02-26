-- =============================================
-- SCRIPT DDL - SISTEMA DE INVENTARIO
-- Base de datos: Mi Almacén Web HN
-- Versión básica para MySQL
-- =============================================

-- Eliminar base de datos si existe
DROP DATABASE IF EXISTS almacen_hn;

-- 1. CREAR BASE DE DATOS
CREATE DATABASE almacen_hn;
USE almacen_hn;

-- =============================================
-- 2. CREAR TABLAS PRINCIPALES
-- =============================================

-- TABLA CATEGORIAS
CREATE TABLE categorias (
    categoria_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion TEXT
);

-- TABLA PROVEEDORES
CREATE TABLE proveedores (
    proveedor_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    telefono VARCHAR(20),
    email VARCHAR(100),
    direccion VARCHAR(200),
    ciudad VARCHAR(50)
);

-- TABLA USUARIOS
CREATE TABLE usuarios (
    usuario_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre_completo VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    username VARCHAR(50) NOT NULL UNIQUE,
    rol VARCHAR(50) DEFAULT 'Vendedor',
    estado BOOLEAN DEFAULT TRUE
);

-- TABLA PRODUCTOS
CREATE TABLE productos (
    producto_id INT AUTO_INCREMENT PRIMARY KEY,
    sku VARCHAR(20) NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio_compra DECIMAL(10,2) NOT NULL,
    precio_venta DECIMAL(10,2) NOT NULL,
    stock_minimo INT DEFAULT 5,
    estado VARCHAR(20) DEFAULT 'activo',
    categoria_id INT NOT NULL,
    proveedor_id INT,
    FOREIGN KEY (categoria_id) REFERENCES categorias(categoria_id),
    FOREIGN KEY (proveedor_id) REFERENCES proveedores(proveedor_id),
    CHECK (precio_compra > 0),
    CHECK (precio_venta > 0)
);

-- TABLA MOVIMIENTOS
CREATE TABLE movimientos (
    movimiento_id INT AUTO_INCREMENT PRIMARY KEY,
    producto_id INT NOT NULL,
    usuario_id INT NOT NULL,
    tipo_movimiento VARCHAR(10) NOT NULL,
    cantidad INT NOT NULL,
    fecha_movimiento DATETIME DEFAULT CURRENT_TIMESTAMP,
    observaciones TEXT,
    FOREIGN KEY (producto_id) REFERENCES productos(producto_id),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(usuario_id),
    CHECK (tipo_movimiento IN ('entrada', 'salida')),
    CHECK (cantidad > 0)
);

-- =============================================
-- 3. INSERTAR DATOS DE PRUEBA 
-- =============================================

-- CATEGORIAS
INSERT INTO categorias (nombre, descripcion) VALUES
('Abarrotes', 'Productos básicos de despensa'),
('Lácteos', 'Leche, quesos y derivados'),
('Bebidas', 'Gaseosas, jugos y aguas'),
('Limpieza', 'Productos para el hogar'),
('Carnes', 'Carnes frías y embutidos');

-- PROVEEDORES 
INSERT INTO proveedores (nombre, telefono, email, direccion, ciudad) VALUES
('Lacthosa', '2230-5678', 'ventas@lacthosa.hn', 'Boulevard del Norte', 'San Pedro Sula'),
('Embotelladora de Sula', '2550-4321', 'pedidos@sula.hn', 'Carretera a Puerto Cortés', 'San Pedro Sula'),
('Cargill Honduras', '2235-7890', 'ventas@cargill.hn', 'ZIP Choloma', 'Choloma'),
('Dos Pinos Honduras', '2239-4567', 'info@dospinos.hn', 'Residencial Los Álamos', 'Tegucigalpa'),
('Bimbo Honduras', '2240-1234', 'ventas@bimbo.hn', 'Boulevard Kuwait', 'Tegucigalpa');

-- USUARIOS DEL SISTEMA
INSERT INTO usuarios (nombre_completo, email, username, rol, estado) VALUES
('Carlos Mendoza', 'carlos.mendoza@almacen.hn', 'cmendoza', 'Administrador', TRUE),
('Ana Rivera', 'ana.rivera@almacen.hn', 'arivera', 'Vendedor', TRUE),
('Pedro Santos', 'pedro.santos@almacen.hn', 'psantos', 'Vendedor', TRUE),
('Marta Flores', 'marta.flores@almacen.hn', 'mflores', 'Almacenista', TRUE);

-- PRODUCTOS
INSERT INTO productos (sku, nombre, descripcion, precio_compra, precio_venta, stock_minimo, categoria_id, proveedor_id) VALUES
('LAC001', 'Leche Sula 1L', 'Lecha entera Sula bolsa 1 litro', 18.50, 25.00, 20, 2, 2),
('LAC002', 'Queso Crema Lacthosa 500g', 'Queso crema para untar', 45.00, 65.00, 10, 2, 1),
('BEB001', 'Coca Cola 2L', 'Gaseosa Coca Cola 2 litros', 22.00, 32.00, 15, 3, 2),
('BEB002', 'Jugos Del Valle 1L', 'Jugo de naranja Del Valle', 28.00, 40.00, 12, 3, 2),
('ABA001', 'Arroz HonduArroz 5lb', 'Arroz grano mediano 5 libras', 55.00, 78.00, 25, 1, 3),
('ABA002', 'Frijoles Rancho Grande 2lb', 'Frijoles rojos 2 libras', 42.00, 60.00, 20, 1, 3),
('LIM001', 'Cloro Pato 1L', 'Cloro para limpieza galón', 25.00, 38.00, 15, 4, NULL),
('CAR001', 'Salchichas Z Menu 500g', 'Salchichas de pavo Z Menu', 65.00, 89.00, 8, 5, 3);

-- MOVIMIENTOS DE INVENTARIO
INSERT INTO movimientos (producto_id, usuario_id, tipo_movimiento, cantidad, observaciones) VALUES
(1, 1, 'entrada', 100, 'Compra inicial a Embotelladora Sula'),
(2, 1, 'entrada', 50, 'Compra a Lacthosa'),
(3, 2, 'entrada', 150, 'Compra de bebidas'),
(1, 2, 'salida', 15, 'Venta mostrador'),
(3, 2, 'salida', 20, 'Venta mayorista'),
(2, 3, 'salida', 5, 'Venta a cliente'),
(4, 1, 'entrada', 30, 'Nuevo producto Del Valle'),
(5, 4, 'entrada', 200, 'Compra de arroz'),
(5, 3, 'salida', 50, 'Venta a pulpería'),
(6, 2, 'entrada', 100, 'Compra de frijoles');

