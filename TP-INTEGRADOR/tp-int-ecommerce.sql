CREATE DATABASE ecommerce;
USE ecommerce;

/*Usuarios*/
CREATE TABLE usuario (
    idUsuario INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    password VARCHAR(50) NOT NULL,
    tipoUsuario VARCHAR(20) DEFAULT NULL, /* Normal, Platinum, Gold */
    cantidadVentas INT DEFAULT 0,
    facturacion DECIMAL(10,2) DEFAULT 0,
    reputacion INT DEFAULT 0 /* 0 a 100 */
);

/*Categorías de productos*/
CREATE TABLE categoria (
    idCategoria INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL
);

/*Productos creados por los usuarios*/
CREATE TABLE producto (
    idProducto INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(255) NOT NULL,
    idUsuario INT NOT NULL,
    FOREIGN KEY (idUsuario) REFERENCES usuario(idUsuario)
);

/*Medios de pago*/
CREATE TABLE medioPago (
    idMedioPago INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL /* Tarjeta crédito, débito, Pago Fácil, Rapipago */
);

/*Medios de envío disponibles*/
CREATE TABLE medioEnvio (
    idMedioEnvio INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL /* Oca, Correo Argentino */
);

/*Publicaciones*/
CREATE TABLE publicacion (
    idPublicacion INT PRIMARY KEY AUTO_INCREMENT,
    idProducto INT NOT NULL,
    idCategoria INT NOT NULL,
    idUsuarioVendedor INT NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    tipoPublicacion VARCHAR(20) NOT NULL, /* Venta directa, Subasta */
    nivelPublicacion VARCHAR(20) DEFAULT 'Bronce', /* Bronce, Plata, Oro, Platino */
    estado VARCHAR(20) DEFAULT 'Activa', /* Activa, Finalizada */
    fechaPublicacion DATE NOT NULL,
    observada BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (idProducto) REFERENCES producto(idProducto),
    FOREIGN KEY (idCategoria) REFERENCES categoria(idCategoria),
    FOREIGN KEY (idUsuarioVendedor) REFERENCES usuario(idUsuario)
);

/* Medios de pago aceptados por cada publicación de venta dir */
CREATE TABLE publicacionMedioPago (
    idPublicacion INT NOT NULL,
    idMedioPago INT NOT NULL,
    PRIMARY KEY (idPublicacion, idMedioPago),
    FOREIGN KEY (idPublicacion) REFERENCES publicacion(idPublicacion),
    FOREIGN KEY (idMedioPago) REFERENCES medioPago(idMedioPago)
);

/* Medios de envío aceptados por cada publicación de venta dir */
CREATE TABLE publicacionMedioEnvio (
    idPublicacion INT NOT NULL,
    idMedioEnvio INT NOT NULL,
    PRIMARY KEY (idPublicacion, idMedioEnvio),
    FOREIGN KEY (idPublicacion) REFERENCES publicacion(idPublicacion),
    FOREIGN KEY (idMedioEnvio) REFERENCES medioEnvio(idMedioEnvio)
);

/* Ofertas sobre publicaciones tipo subasta */
CREATE TABLE oferta (
    idOferta INT PRIMARY KEY AUTO_INCREMENT,
    idPublicacion INT NOT NULL,
    idUsuario INT NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    fechaOferta DATETIME NOT NULL,
    FOREIGN KEY (idPublicacion) REFERENCES publicacion(idPublicacion),
    FOREIGN KEY (idUsuario) REFERENCES usuario(idUsuario)
);

/* Preguntas en publicaciones activas */
CREATE TABLE pregunta (
    idPregunta INT PRIMARY KEY AUTO_INCREMENT,
    idPublicacion INT NOT NULL,
    idUsuario INT NOT NULL,
    textoPregunta VARCHAR(255) NOT NULL,
    fechaPregunta DATETIME NOT NULL,
    FOREIGN KEY (idPublicacion) REFERENCES publicacion(idPublicacion),
    FOREIGN KEY (idUsuario) REFERENCES usuario(idUsuario)
);

/* Respuestas  vendedor a cada pregunta */
CREATE TABLE respuesta (
    idRespuesta INT PRIMARY KEY AUTO_INCREMENT,
    idPregunta INT NOT NULL,
    textoRespuesta VARCHAR(255) NOT NULL,
    fechaRespuesta DATETIME NOT NULL,
    FOREIGN KEY (idPregunta) REFERENCES pregunta(idPregunta)
);

/* Ventas */
CREATE TABLE venta (
    idVenta INT PRIMARY KEY AUTO_INCREMENT,
    idPublicacion INT NOT NULL,
    idUsuarioComprador INT NOT NULL,
    fechaVenta DATETIME NOT NULL,
    calificacionComprador INT,
    calificacionVendedor INT,
    FOREIGN KEY (idPublicacion) REFERENCES publicacion(idPublicacion),
    FOREIGN KEY (idUsuarioComprador) REFERENCES usuario(idUsuario)
);

/* Noti para preg sin responder */
CREATE TABLE notificacion (
    idNotificacion INT PRIMARY KEY AUTO_INCREMENT,
    idUsuario INT NOT NULL,
    mensaje VARCHAR(255) NOT NULL,
    fechaNotificacion DATETIME NOT NULL,
    FOREIGN KEY (idUsuario) REFERENCES usuario(idUsuario)
);

/* estadisticas */
CREATE TABLE estadisticaDiaria (
    idEstadistica INT PRIMARY KEY AUTO_INCREMENT,
    fecha DATE NOT NULL,
    cantidadVendedores INT,
    cantidadCompradores INT,
    cantidadProductos INT
);


INSERT INTO usuario (nombre, email, password, tipoUsuario, cantidadVentas, facturacion, reputacion) VALUES
('Juan Pérez', 'juan.perez@mail.com', 'pass123', 'Normal', 3, 45000, 85),
('Sofía Gómez', 'sofia.gomez@mail.com', 'pass123', 'Normal', 0, 0, 0),
('Martín González', 'martin.gonzalez@mail.com', 'pass123', 'Platinum', 7, 150000, 90),
('Julieta Martínez', 'julieta.martinez@mail.com', 'pass123', 'Gold', 15, 1200000, 95),
('Lucas Fernández', 'lucas.fernandez@mail.com', 'pass123', 'Normal', 2, 20000, 80),
('Camila Torres', 'camila.torres@mail.com', 'pass123', 'Normal', 0, 0, 0),
('Diego Ramírez', 'diego.ramirez@mail.com', 'pass123', 'Normal', 1, 8000, 75),
('Valentina Díaz', 'valentina.diaz@mail.com', 'pass123', 'Normal', 0, 0, 0);

INSERT INTO categoria (nombre) VALUES
('Tecnología'), ('Hogar'), ('Indumentaria'), ('Deportes'), ('Juguetes');

INSERT INTO producto (nombre, descripcion, idUsuario) VALUES
('Notebook Lenovo IdeaPad', 'Notebook 15.6", 8GB RAM, 256GB SSD, poco uso', 1),
('Auriculares Bluetooth JBL', 'Auriculares inalámbricos con estuche de carga', 1),
('Mesa ratona de madera', 'Mesa ratona de madera maciza, estilo rústico', 3),
('Zapatillas Nike Air', 'Zapatillas Nike Air talle 42, nuevas', 4),
('Pelota de fútbol Adidas', 'Pelota N°5 para uso profesional', 5),
('Bicicleta rodado 26', 'Bicicleta mountain bike rodado 26, 21 velocidades', 4),
('Cafetera eléctrica', 'Cafetera de goteo, capacidad 12 tazas', 3),
('Campera de jean', 'Campera de jean unisex, talle M', 7),
('Consola PlayStation 5', 'PS5 con un joystick, poco uso', 4),
('Muñeca articulada', 'Muñeca articulada de colección, nueva', 5);

INSERT INTO medioPago (nombre) VALUES
('Tarjeta de crédito'), ('Tarjeta de débito'), ('Pago Fácil'), ('Rapipago');

INSERT INTO medioEnvio (nombre) VALUES
('OCA'), ('Correo Argentino');

INSERT INTO publicacion (idProducto, idCategoria, idUsuarioVendedor, precio, tipoPublicacion, nivelPublicacion, estado, fechaPublicacion) VALUES
(1, 1, 1, 350000, 'Venta directa', 'Oro', 'Activa', '2026-07-20'),
(2, 1, 1, 45000, 'Venta directa', 'Bronce', 'Activa', '2026-08-01'),
(3, 2, 3, 60000, 'Venta directa', 'Plata', 'Finalizada', '2026-06-01'),
(4, 3, 4, 120000, 'Subasta', 'Platino', 'Activa', '2026-08-05'),
(5, 4, 5, 15000, 'Venta directa', 'Bronce', 'Pausada', '2026-04-01'),
(6, 4, 4, 200000, 'Subasta', 'Oro', 'Finalizada', '2026-07-01'),
(7, 2, 3, 30000, 'Venta directa', 'Bronce', 'Activa', '2026-08-10'),
(8, 3, 7, 25000, 'Venta directa', 'Bronce', 'Activa', '2026-08-11'),
(9, 1, 4, 500000, 'Subasta', 'Platino', 'Activa', '2026-08-08'),
(10, 5, 5, 18000, 'Venta directa', 'Bronce', 'Pausada', '2026-08-01');

INSERT INTO publicacionMedioPago (idPublicacion, idMedioPago) VALUES
(1, 1), (1, 2),
(3, 1), (3, 3),
(5, 1),
(7, 1), (7, 2), (7, 4),
(8, 2), (8, 3),
(10, 2);

INSERT INTO publicacionMedioEnvio (idPublicacion, idMedioEnvio) VALUES
(1, 1), (1, 2),
(2, 1),
(3, 2),
(5, 2),
(7, 1),
(8, 1), (8, 2),
(10, 1);

INSERT INTO oferta (idPublicacion, idUsuario, monto, fechaOferta) VALUES
(4, 2, 125000, '2026-08-06 10:00:00'),
(4, 5, 130000, '2026-08-06 15:30:00'),
(4, 6, 135000, '2026-08-07 09:00:00'),
(9, 1, 510000, '2026-08-09 11:00:00'),
(9, 3, 520000, '2026-08-09 18:00:00'),
(6, 6, 210000, '2026-07-02 10:00:00'),
(6, 2, 220000, '2026-07-02 12:00:00');

INSERT INTO pregunta (idPublicacion, idUsuario, textoPregunta, fechaPregunta) VALUES
(1, 2, '¿Tiene garantía oficial?', '2026-08-11 09:00:00'),
(1, 5, '¿Aceptás envío a Córdoba?', '2026-08-12 10:00:00'),
(7, 6, '¿La cafetera es nueva o usada?', '2026-08-11 14:00:00'),
(8, 2, '¿Qué talle tiene la campera?', '2026-08-12 08:00:00'),
(2, 5, '¿Hace cuánto la usás?', '2026-08-12 16:00:00');

INSERT INTO respuesta (idPregunta, textoRespuesta, fechaRespuesta) VALUES
(3, 'Es nueva, sin uso', '2026-08-11 18:00:00');

INSERT INTO venta (idPublicacion, idUsuarioComprador, fechaVenta) VALUES
(3, 6, '2026-06-02 12:00:00'),
(6, 2, '2026-07-02 13:00:00');
