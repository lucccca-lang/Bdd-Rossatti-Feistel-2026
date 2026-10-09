-- MySQL dump 10.13  Distrib 8.0.46, for Linux (x86_64)
--
-- Host: localhost    Database: ecommerce
-- ------------------------------------------------------
-- Server version	8.0.46-0ubuntu0.24.04.3

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `categoria`
--

DROP TABLE IF EXISTS `categoria`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categoria` (
  `idCategoria` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  PRIMARY KEY (`idCategoria`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categoria`
--

LOCK TABLES `categoria` WRITE;
/*!40000 ALTER TABLE `categoria` DISABLE KEYS */;
INSERT INTO `categoria` VALUES (1,'Tecnología'),(2,'Hogar'),(3,'Indumentaria'),(4,'Deportes'),(5,'Juguetes');
/*!40000 ALTER TABLE `categoria` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `estadisticaDiaria`
--

DROP TABLE IF EXISTS `estadisticaDiaria`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `estadisticaDiaria` (
  `idEstadistica` int NOT NULL AUTO_INCREMENT,
  `fecha` date NOT NULL,
  `cantidadVendedores` int DEFAULT NULL,
  `cantidadCompradores` int DEFAULT NULL,
  `cantidadProductos` int DEFAULT NULL,
  PRIMARY KEY (`idEstadistica`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estadisticaDiaria`
--

LOCK TABLES `estadisticaDiaria` WRITE;
/*!40000 ALTER TABLE `estadisticaDiaria` DISABLE KEYS */;
/*!40000 ALTER TABLE `estadisticaDiaria` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `medioEnvio`
--

DROP TABLE IF EXISTS `medioEnvio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `medioEnvio` (
  `idMedioEnvio` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  PRIMARY KEY (`idMedioEnvio`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `medioEnvio`
--

LOCK TABLES `medioEnvio` WRITE;
/*!40000 ALTER TABLE `medioEnvio` DISABLE KEYS */;
INSERT INTO `medioEnvio` VALUES (1,'OCA'),(2,'Correo Argentino');
/*!40000 ALTER TABLE `medioEnvio` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `medioPago`
--

DROP TABLE IF EXISTS `medioPago`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `medioPago` (
  `idMedioPago` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  PRIMARY KEY (`idMedioPago`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `medioPago`
--

LOCK TABLES `medioPago` WRITE;
/*!40000 ALTER TABLE `medioPago` DISABLE KEYS */;
INSERT INTO `medioPago` VALUES (1,'Tarjeta de crédito'),(2,'Tarjeta de débito'),(3,'Pago Fácil'),(4,'Rapipago');
/*!40000 ALTER TABLE `medioPago` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notificacion`
--

DROP TABLE IF EXISTS `notificacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notificacion` (
  `idNotificacion` int NOT NULL AUTO_INCREMENT,
  `idUsuario` int NOT NULL,
  `mensaje` varchar(255) NOT NULL,
  `fechaNotificacion` datetime NOT NULL,
  PRIMARY KEY (`idNotificacion`),
  KEY `idUsuario` (`idUsuario`),
  CONSTRAINT `notificacion_ibfk_1` FOREIGN KEY (`idUsuario`) REFERENCES `usuario` (`idUsuario`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notificacion`
--

LOCK TABLES `notificacion` WRITE;
/*!40000 ALTER TABLE `notificacion` DISABLE KEYS */;
INSERT INTO `notificacion` VALUES (1,1,'La publicación sobre Notebook Lenovo IdeaPad tiene 2 preguntas sin responder','2026-08-20 10:00:01'),(2,1,'La publicación sobre Auriculares Bluetooth JBL tiene 1 preguntas sin responder','2026-08-20 10:00:01'),(3,7,'La publicación sobre Campera de jean tiene 1 preguntas sin responder','2026-08-20 10:00:01'),(4,4,'La publicación sobre Consola PlayStation 5 tiene 1 preguntas sin responder','2026-08-20 10:00:01');
/*!40000 ALTER TABLE `notificacion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oferta`
--

DROP TABLE IF EXISTS `oferta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `oferta` (
  `idOferta` int NOT NULL AUTO_INCREMENT,
  `idPublicacion` int NOT NULL,
  `idUsuario` int NOT NULL,
  `monto` decimal(10,2) NOT NULL,
  `fechaOferta` datetime NOT NULL,
  PRIMARY KEY (`idOferta`),
  KEY `idPublicacion` (`idPublicacion`),
  KEY `idUsuario` (`idUsuario`),
  CONSTRAINT `oferta_ibfk_1` FOREIGN KEY (`idPublicacion`) REFERENCES `publicacion` (`idPublicacion`),
  CONSTRAINT `oferta_ibfk_2` FOREIGN KEY (`idUsuario`) REFERENCES `usuario` (`idUsuario`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oferta`
--

LOCK TABLES `oferta` WRITE;
/*!40000 ALTER TABLE `oferta` DISABLE KEYS */;
INSERT INTO `oferta` VALUES (1,4,2,125000.00,'2026-08-06 10:00:00'),(2,4,5,130000.00,'2026-08-06 15:30:00'),(3,4,6,135000.00,'2026-08-07 09:00:00'),(4,9,1,510000.00,'2026-08-09 11:00:00'),(5,9,3,520000.00,'2026-08-09 18:00:00'),(6,6,6,210000.00,'2026-07-02 10:00:00'),(7,6,2,220000.00,'2026-07-02 12:00:00'),(8,4,8,145000.00,'2026-08-13 11:29:10'),(9,9,5,530000.00,'2026-08-20 10:10:18');
/*!40000 ALTER TABLE `oferta` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`alumno27.rossatti.lucca.santino`@`localhost`*/ /*!50003 TRIGGER `verificar_puja` BEFORE INSERT ON `oferta` FOR EACH ROW BEGIN
    DECLARE estadoPub VARCHAR(20);
    DECLARE vendedorPub INT;
    DECLARE maxOferta DECIMAL(10,2);

    SELECT estado, idUsuarioVendedor INTO estadoPub, vendedorPub
    FROM publicacion WHERE idPublicacion = NEW.idPublicacion;

    IF estadoPub = 'Finalizada' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La publicación ya está finalizada';
    END IF;

    IF NEW.idUsuario = vendedorPub THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El vendedor no puede pujar en su propia publicación';
    END IF;

    SELECT MAX(monto) INTO maxOferta FROM oferta WHERE idPublicacion = NEW.idPublicacion;

    IF maxOferta IS NOT NULL AND NEW.monto <= maxOferta THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El monto debe ser mayor a la oferta actual';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `pregunta`
--

DROP TABLE IF EXISTS `pregunta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pregunta` (
  `idPregunta` int NOT NULL AUTO_INCREMENT,
  `idPublicacion` int NOT NULL,
  `idUsuario` int NOT NULL,
  `textoPregunta` varchar(255) NOT NULL,
  `fechaPregunta` datetime NOT NULL,
  PRIMARY KEY (`idPregunta`),
  KEY `idPublicacion` (`idPublicacion`),
  KEY `idUsuario` (`idUsuario`),
  CONSTRAINT `pregunta_ibfk_1` FOREIGN KEY (`idPublicacion`) REFERENCES `publicacion` (`idPublicacion`),
  CONSTRAINT `pregunta_ibfk_2` FOREIGN KEY (`idUsuario`) REFERENCES `usuario` (`idUsuario`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pregunta`
--

LOCK TABLES `pregunta` WRITE;
/*!40000 ALTER TABLE `pregunta` DISABLE KEYS */;
INSERT INTO `pregunta` VALUES (1,1,2,'¿Tiene garantía oficial?','2026-08-11 09:00:00'),(2,1,5,'¿Aceptás envío a Córdoba?','2026-08-12 10:00:00'),(4,8,2,'¿Qué talle tiene la campera?','2026-08-12 08:00:00'),(5,2,5,'¿Hace cuánto la usás?','2026-08-12 16:00:00'),(6,9,2,'¿Incluye caja original?','2026-08-20 08:21:55'),(7,9,2,'¿Incluye caja original?','2026-08-20 11:09:18');
/*!40000 ALTER TABLE `pregunta` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`alumno27.rossatti.lucca.santino`@`localhost`*/ /*!50003 TRIGGER `antes_eliminar_pregunta` BEFORE DELETE ON `pregunta` FOR EACH ROW BEGIN
    DELETE FROM respuesta WHERE idPregunta = OLD.idPregunta;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `producto`
--

DROP TABLE IF EXISTS `producto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `producto` (
  `idProducto` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `descripcion` varchar(255) NOT NULL,
  `idUsuario` int NOT NULL,
  PRIMARY KEY (`idProducto`),
  KEY `idUsuario` (`idUsuario`),
  KEY `idx_nombreProducto` (`nombre`),
  CONSTRAINT `producto_ibfk_1` FOREIGN KEY (`idUsuario`) REFERENCES `usuario` (`idUsuario`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `producto`
--

LOCK TABLES `producto` WRITE;
/*!40000 ALTER TABLE `producto` DISABLE KEYS */;
INSERT INTO `producto` VALUES (1,'Notebook Lenovo IdeaPad','Notebook 15.6\", 8GB RAM, 256GB SSD, poco uso',1),(2,'Auriculares Bluetooth JBL','Auriculares inalámbricos con estuche de carga',1),(3,'Mesa ratona de madera','Mesa ratona de madera maciza, estilo rústico',3),(4,'Zapatillas Nike Air','Zapatillas Nike Air talle 42, nuevas',4),(5,'Pelota de fútbol Adidas','Pelota N°5 para uso profesional',5),(6,'Bicicleta rodado 26','Bicicleta mountain bike rodado 26, 21 velocidades',4),(7,'Cafetera eléctrica','Cafetera de goteo, capacidad 12 tazas',3),(8,'Campera de jean','Campera de jean unisex, talle M',7),(9,'Consola PlayStation 5','PS5 con un joystick, poco uso',4),(10,'Muñeca articulada','Muñeca articulada de colección, nueva',5);
/*!40000 ALTER TABLE `producto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `publicacion`
--

DROP TABLE IF EXISTS `publicacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `publicacion` (
  `idPublicacion` int NOT NULL AUTO_INCREMENT,
  `idProducto` int NOT NULL,
  `idCategoria` int NOT NULL,
  `idUsuarioVendedor` int NOT NULL,
  `precio` decimal(10,2) NOT NULL,
  `tipoPublicacion` varchar(20) NOT NULL,
  `nivelPublicacion` varchar(20) DEFAULT 'Bronce',
  `estado` varchar(20) DEFAULT 'Activa',
  `fechaPublicacion` date NOT NULL,
  `observada` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`idPublicacion`),
  KEY `idProducto` (`idProducto`),
  KEY `idCategoria` (`idCategoria`),
  KEY `idUsuarioVendedor` (`idUsuarioVendedor`),
  CONSTRAINT `publicacion_ibfk_1` FOREIGN KEY (`idProducto`) REFERENCES `producto` (`idProducto`),
  CONSTRAINT `publicacion_ibfk_2` FOREIGN KEY (`idCategoria`) REFERENCES `categoria` (`idCategoria`),
  CONSTRAINT `publicacion_ibfk_3` FOREIGN KEY (`idUsuarioVendedor`) REFERENCES `usuario` (`idUsuario`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `publicacion`
--

LOCK TABLES `publicacion` WRITE;
/*!40000 ALTER TABLE `publicacion` DISABLE KEYS */;
INSERT INTO `publicacion` VALUES (1,1,1,1,350000.00,'Venta directa','Oro','Pausada','2026-07-20',0),(2,2,1,1,45000.00,'Venta directa','Bronce','Activa','2026-08-01',1),(3,3,2,3,60000.00,'Venta directa','Plata','Finalizada','2026-06-01',0),(4,4,3,4,120000.00,'Subasta','Platino','Activa','2026-08-05',0),(5,5,4,5,15000.00,'Venta directa','Bronce','Pausada','2026-04-01',0),(6,6,4,4,200000.00,'Subasta','Oro','Finalizada','2026-07-01',0),(7,7,2,3,30000.00,'Venta directa','Bronce','Finalizada','2026-08-10',0),(8,8,3,7,25000.00,'Venta directa','Bronce','Finalizada','2026-08-11',0),(9,9,1,4,500000.00,'Subasta','Platino','Activa','2026-08-08',0),(10,10,5,5,18000.00,'Venta directa','Bronce','Pausada','2026-08-01',0),(11,2,1,1,45000.00,'Venta directa','Bronce','Activa','2026-08-20',0),(12,2,1,1,45000.00,'Venta directa','Bronce','Activa','2026-08-20',0);
/*!40000 ALTER TABLE `publicacion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `publicacionMedioEnvio`
--

DROP TABLE IF EXISTS `publicacionMedioEnvio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `publicacionMedioEnvio` (
  `idPublicacion` int NOT NULL,
  `idMedioEnvio` int NOT NULL,
  PRIMARY KEY (`idPublicacion`,`idMedioEnvio`),
  KEY `idMedioEnvio` (`idMedioEnvio`),
  CONSTRAINT `publicacionMedioEnvio_ibfk_1` FOREIGN KEY (`idPublicacion`) REFERENCES `publicacion` (`idPublicacion`),
  CONSTRAINT `publicacionMedioEnvio_ibfk_2` FOREIGN KEY (`idMedioEnvio`) REFERENCES `medioEnvio` (`idMedioEnvio`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `publicacionMedioEnvio`
--

LOCK TABLES `publicacionMedioEnvio` WRITE;
/*!40000 ALTER TABLE `publicacionMedioEnvio` DISABLE KEYS */;
INSERT INTO `publicacionMedioEnvio` VALUES (1,1),(2,1),(7,1),(8,1),(10,1),(11,1),(12,1),(1,2),(3,2),(5,2),(8,2);
/*!40000 ALTER TABLE `publicacionMedioEnvio` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `publicacionMedioPago`
--

DROP TABLE IF EXISTS `publicacionMedioPago`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `publicacionMedioPago` (
  `idPublicacion` int NOT NULL,
  `idMedioPago` int NOT NULL,
  PRIMARY KEY (`idPublicacion`,`idMedioPago`),
  KEY `idMedioPago` (`idMedioPago`),
  CONSTRAINT `publicacionMedioPago_ibfk_1` FOREIGN KEY (`idPublicacion`) REFERENCES `publicacion` (`idPublicacion`),
  CONSTRAINT `publicacionMedioPago_ibfk_2` FOREIGN KEY (`idMedioPago`) REFERENCES `medioPago` (`idMedioPago`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `publicacionMedioPago`
--

LOCK TABLES `publicacionMedioPago` WRITE;
/*!40000 ALTER TABLE `publicacionMedioPago` DISABLE KEYS */;
INSERT INTO `publicacionMedioPago` VALUES (1,1),(3,1),(5,1),(7,1),(11,1),(12,1),(1,2),(7,2),(8,2),(10,2),(3,3),(8,3),(7,4);
/*!40000 ALTER TABLE `publicacionMedioPago` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `respuesta`
--

DROP TABLE IF EXISTS `respuesta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `respuesta` (
  `idRespuesta` int NOT NULL AUTO_INCREMENT,
  `idPregunta` int NOT NULL,
  `textoRespuesta` varchar(255) NOT NULL,
  `fechaRespuesta` datetime NOT NULL,
  PRIMARY KEY (`idRespuesta`),
  KEY `idPregunta` (`idPregunta`),
  CONSTRAINT `respuesta_ibfk_1` FOREIGN KEY (`idPregunta`) REFERENCES `pregunta` (`idPregunta`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `respuesta`
--

LOCK TABLES `respuesta` WRITE;
/*!40000 ALTER TABLE `respuesta` DISABLE KEYS */;
/*!40000 ALTER TABLE `respuesta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuario`
--

DROP TABLE IF EXISTS `usuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuario` (
  `idUsuario` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(50) NOT NULL,
  `tipoUsuario` varchar(20) DEFAULT NULL,
  `cantidadVentas` int DEFAULT '0',
  `facturacion` decimal(10,2) DEFAULT '0.00',
  `reputacion` int DEFAULT '0',
  PRIMARY KEY (`idUsuario`),
  UNIQUE KEY `uidx_emailUsuario` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuario`
--

LOCK TABLES `usuario` WRITE;
/*!40000 ALTER TABLE `usuario` DISABLE KEYS */;
INSERT INTO `usuario` VALUES (1,'Juan Pérez','juan.perez@mail.com','pass123','Normal',3,45000.00,85),(2,'Sofía Gómez','sofia.gomez@mail.com','pass123','Normal',0,0.00,0),(3,'Martín González','martin.gonzalez@mail.com','pass123','Platinum',8,180000.00,84),(4,'Julieta Martínez','julieta.martinez@mail.com','pass123','Gold',15,1200000.00,95),(5,'Lucas Fernández','lucas.fernandez@mail.com','pass123','Normal',2,20000.00,80),(6,'Camila Torres','camila.torres@mail.com','pass123','Normal',0,0.00,0),(7,'Diego Ramírez','diego.ramirez@mail.com','pass123','Normal',1,8000.00,75),(8,'Valentina Díaz','valentina.diaz@mail.com','pass123','Normal',0,0.00,0);
/*!40000 ALTER TABLE `usuario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `venta`
--

DROP TABLE IF EXISTS `venta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `venta` (
  `idVenta` int NOT NULL AUTO_INCREMENT,
  `idPublicacion` int NOT NULL,
  `idUsuarioComprador` int NOT NULL,
  `fechaVenta` datetime NOT NULL,
  `calificacionComprador` int DEFAULT NULL,
  `calificacionVendedor` int DEFAULT NULL,
  PRIMARY KEY (`idVenta`),
  KEY `idPublicacion` (`idPublicacion`),
  KEY `idUsuarioComprador` (`idUsuarioComprador`),
  CONSTRAINT `venta_ibfk_1` FOREIGN KEY (`idPublicacion`) REFERENCES `publicacion` (`idPublicacion`),
  CONSTRAINT `venta_ibfk_2` FOREIGN KEY (`idUsuarioComprador`) REFERENCES `usuario` (`idUsuario`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `venta`
--

LOCK TABLES `venta` WRITE;
/*!40000 ALTER TABLE `venta` DISABLE KEYS */;
INSERT INTO `venta` VALUES (1,3,6,'2026-06-02 12:00:00',92,88),(2,6,2,'2026-07-02 13:00:00',NULL,NULL),(3,7,8,'2026-08-20 09:07:29',NULL,80);
/*!40000 ALTER TABLE `venta` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`alumno27.rossatti.lucca.santino`@`localhost`*/ /*!50003 TRIGGER `despues_actualizar_nivel` AFTER INSERT ON `venta` FOR EACH ROW BEGIN
    DECLARE idVendedor INT;
    DECLARE montoVenta DECIMAL(10,2);
    DECLARE ventasVendedor INT;
    DECLARE facturacionVendedor DECIMAL(10,2);

    SELECT idUsuarioVendedor, precio INTO idVendedor, montoVenta
    FROM publicacion WHERE idPublicacion = NEW.idPublicacion;

    UPDATE usuario
    SET cantidadVentas = cantidadVentas + 1,
        facturacion = facturacion + montoVenta
    WHERE idUsuario = idVendedor;

    SELECT cantidadVentas, facturacion INTO ventasVendedor, facturacionVendedor
    FROM usuario WHERE idUsuario = idVendedor;

    IF ventasVendedor >= 11 OR facturacionVendedor >= 1000000 THEN
        UPDATE usuario SET tipoUsuario = 'Gold' WHERE idUsuario = idVendedor;
    ELSEIF ventasVendedor >= 6 OR facturacionVendedor >= 100000 THEN
        UPDATE usuario SET tipoUsuario = 'Platinum' WHERE idUsuario = idVendedor;
    ELSE
        UPDATE usuario SET tipoUsuario = 'Normal' WHERE idUsuario = idVendedor;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`alumno27.rossatti.lucca.santino`@`localhost`*/ /*!50003 TRIGGER `actualizar_reputacion` AFTER UPDATE ON `venta` FOR EACH ROW BEGIN
    DECLARE idVendedor INT;
    DECLARE promedioVendedor DECIMAL(5,2);
    DECLARE promedioComprador DECIMAL(5,2);

    SELECT idUsuarioVendedor INTO idVendedor
    FROM publicacion WHERE idPublicacion = NEW.idPublicacion;

    IF NEW.calificacionVendedor IS NOT NULL AND (OLD.calificacionVendedor IS NULL OR NEW.calificacionVendedor <> OLD.calificacionVendedor) THEN
        SELECT AVG(v.calificacionVendedor) INTO promedioVendedor
        FROM venta v
        JOIN publicacion p ON v.idPublicacion = p.idPublicacion
        WHERE p.idUsuarioVendedor = idVendedor AND v.calificacionVendedor IS NOT NULL;

        UPDATE usuario SET reputacion = promedioVendedor WHERE idUsuario = idVendedor;
    END IF;

    IF NEW.calificacionComprador IS NOT NULL AND (OLD.calificacionComprador IS NULL OR NEW.calificacionComprador <> OLD.calificacionComprador) THEN
        SELECT AVG(calificacionComprador) INTO promedioComprador
        FROM venta
        WHERE idUsuarioComprador = NEW.idUsuarioComprador AND calificacionComprador IS NOT NULL;

        UPDATE usuario SET reputacion = promedioComprador WHERE idUsuario = NEW.idUsuarioComprador;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Temporary view structure for view `vistaMejorReputacionPorCategoria`
--

DROP TABLE IF EXISTS `vistaMejorReputacionPorCategoria`;
/*!50001 DROP VIEW IF EXISTS `vistaMejorReputacionPorCategoria`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vistaMejorReputacionPorCategoria` AS SELECT 
 1 AS `categoria`,
 1 AS `vendedor`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vistaPreguntasSinResponder`
--

DROP TABLE IF EXISTS `vistaPreguntasSinResponder`;
/*!50001 DROP VIEW IF EXISTS `vistaPreguntasSinResponder`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vistaPreguntasSinResponder` AS SELECT 
 1 AS `idPregunta`,
 1 AS `descripcion`,
 1 AS `idPublicacion`,
 1 AS `nombreProducto`,
 1 AS `nombreVendedor`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vistaTendenciasHoy`
--

DROP TABLE IF EXISTS `vistaTendenciasHoy`;
/*!50001 DROP VIEW IF EXISTS `vistaTendenciasHoy`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vistaTendenciasHoy` AS SELECT 
 1 AS `idPublicacion`,
 1 AS `producto`,
 1 AS `cantidadPreguntas`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vistaTopCategoriasSemana`
--

DROP TABLE IF EXISTS `vistaTopCategoriasSemana`;
/*!50001 DROP VIEW IF EXISTS `vistaTopCategoriasSemana`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vistaTopCategoriasSemana` AS SELECT 
 1 AS `categoria`,
 1 AS `cantidadPublicaciones`*/;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `vistaMejorReputacionPorCategoria`
--

/*!50001 DROP VIEW IF EXISTS `vistaMejorReputacionPorCategoria`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`alumno27.rossatti.lucca.santino`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vistaMejorReputacionPorCategoria` AS select `c`.`nombre` AS `categoria`,`u`.`nombre` AS `vendedor` from ((`usuario` `u` join `publicacion` `p` on((`u`.`idUsuario` = `p`.`idUsuarioVendedor`))) join `categoria` `c` on((`p`.`idCategoria` = `c`.`idCategoria`))) where (`u`.`reputacion` = (select max(`u2`.`reputacion`) from (`usuario` `u2` join `publicacion` `p2` on((`u2`.`idUsuario` = `p2`.`idUsuarioVendedor`))) where (`p2`.`idCategoria` = `c`.`idCategoria`))) group by `c`.`nombre`,`u`.`nombre` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vistaPreguntasSinResponder`
--

/*!50001 DROP VIEW IF EXISTS `vistaPreguntasSinResponder`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`alumno27.rossatti.lucca.santino`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vistaPreguntasSinResponder` AS select `preg`.`idPregunta` AS `idPregunta`,`preg`.`textoPregunta` AS `descripcion`,`preg`.`idPublicacion` AS `idPublicacion`,`pr`.`nombre` AS `nombreProducto`,`u`.`nombre` AS `nombreVendedor` from ((((`pregunta` `preg` join `publicacion` `pu` on((`preg`.`idPublicacion` = `pu`.`idPublicacion`))) join `producto` `pr` on((`pu`.`idProducto` = `pr`.`idProducto`))) join `usuario` `u` on((`pu`.`idUsuarioVendedor` = `u`.`idUsuario`))) left join `respuesta` `r` on((`r`.`idPregunta` = `preg`.`idPregunta`))) where ((`pu`.`estado` = 'Activa') and (`r`.`idRespuesta` is null)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vistaTendenciasHoy`
--

/*!50001 DROP VIEW IF EXISTS `vistaTendenciasHoy`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`alumno27.rossatti.lucca.santino`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vistaTendenciasHoy` AS select `p`.`idPublicacion` AS `idPublicacion`,`pr`.`nombre` AS `producto`,count(`preg`.`idPregunta`) AS `cantidadPreguntas` from ((`publicacion` `p` join `producto` `pr` on((`p`.`idProducto` = `pr`.`idProducto`))) join `pregunta` `preg` on((`preg`.`idPublicacion` = `p`.`idPublicacion`))) where (cast(`preg`.`fechaPregunta` as date) = curdate()) group by `p`.`idPublicacion`,`pr`.`nombre` order by `cantidadPreguntas` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vistaTopCategoriasSemana`
--

/*!50001 DROP VIEW IF EXISTS `vistaTopCategoriasSemana`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`alumno27.rossatti.lucca.santino`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vistaTopCategoriasSemana` AS select `c`.`nombre` AS `categoria`,count(0) AS `cantidadPublicaciones` from (`publicacion` `p` join `categoria` `c` on((`p`.`idCategoria` = `c`.`idCategoria`))) where (`p`.`fechaPublicacion` >= (curdate() - interval 7 day)) group by `c`.`nombre` order by `cantidadPublicaciones` desc limit 10 */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-08-20 11:14:39
