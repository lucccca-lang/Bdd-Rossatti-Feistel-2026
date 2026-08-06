-- MySQL dump 10.13  Distrib 8.0.46, for Linux (x86_64)
--
-- Host: 127.0.0.1    Database: mundial2026
-- ------------------------------------------------------
-- Server version	8.0.46-0ubuntu0.24.04.3

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `alineacion`
--

DROP TABLE IF EXISTS `alineacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `alineacion` (
  `jugador_id_jugador` int NOT NULL,
  `partido_id_partido` int NOT NULL,
  PRIMARY KEY (`jugador_id_jugador`,`partido_id_partido`),
  KEY `partido_id_partido` (`partido_id_partido`),
  CONSTRAINT `alineacion_ibfk_1` FOREIGN KEY (`jugador_id_jugador`) REFERENCES `jugador` (`id_jugador`),
  CONSTRAINT `alineacion_ibfk_2` FOREIGN KEY (`partido_id_partido`) REFERENCES `partido` (`id_partido`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alineacion`
--

LOCK TABLES `alineacion` WRITE;
/*!40000 ALTER TABLE `alineacion` DISABLE KEYS */;
INSERT INTO `alineacion` VALUES (3,2),(4,2),(5,3);
/*!40000 ALTER TABLE `alineacion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `estadio`
--

DROP TABLE IF EXISTS `estadio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `estadio` (
  `id_estadio` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(150) NOT NULL,
  `ciudad` varchar(100) DEFAULT NULL,
  `capacidad` int DEFAULT NULL,
  PRIMARY KEY (`id_estadio`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estadio`
--

LOCK TABLES `estadio` WRITE;
/*!40000 ALTER TABLE `estadio` DISABLE KEYS */;
INSERT INTO `estadio` VALUES (1,'MetLife Stadium','Nueva York',82500),(2,'Rose Bowl','Los Angeles',90888),(3,'AT&T Stadium','Dallas',80000),(4,'Estadio Azteca','Ciudad de Mexico',87523),(5,'Gillette Stadium','Boston',65878);
/*!40000 ALTER TABLE `estadio` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gol`
--

DROP TABLE IF EXISTS `gol`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gol` (
  `id_gol` int NOT NULL AUTO_INCREMENT,
  `minuto` int DEFAULT NULL,
  `es_penal` tinyint(1) DEFAULT '0',
  `jugador_id_jugador` int DEFAULT NULL,
  `partido_id_partido` int DEFAULT NULL,
  PRIMARY KEY (`id_gol`),
  KEY `jugador_id_jugador` (`jugador_id_jugador`),
  KEY `idx_gol_partido` (`partido_id_partido`),
  CONSTRAINT `gol_ibfk_1` FOREIGN KEY (`jugador_id_jugador`) REFERENCES `jugador` (`id_jugador`),
  CONSTRAINT `gol_ibfk_2` FOREIGN KEY (`partido_id_partido`) REFERENCES `partido` (`id_partido`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gol`
--

LOCK TABLES `gol` WRITE;
/*!40000 ALTER TABLE `gol` DISABLE KEYS */;
INSERT INTO `gol` VALUES (1,23,0,1,1),(2,45,0,2,1),(5,88,0,5,4),(6,75,0,4,1);
/*!40000 ALTER TABLE `gol` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `historial_entrenadores`
--

DROP TABLE IF EXISTS `historial_entrenadores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `historial_entrenadores` (
  `id` int NOT NULL AUTO_INCREMENT,
  `seleccion` varchar(100) DEFAULT NULL,
  `entrenador_anterior` varchar(150) DEFAULT NULL,
  `entrenador_nuevo` varchar(150) DEFAULT NULL,
  `fecha_cambio` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `historial_entrenadores`
--

LOCK TABLES `historial_entrenadores` WRITE;
/*!40000 ALTER TABLE `historial_entrenadores` DISABLE KEYS */;
/*!40000 ALTER TABLE `historial_entrenadores` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `jugador`
--

DROP TABLE IF EXISTS `jugador`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `jugador` (
  `id_jugador` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(150) NOT NULL,
  `posicion` varchar(50) DEFAULT NULL,
  `dorsal` int DEFAULT NULL,
  `activo` tinyint(1) DEFAULT '1',
  `seleccion_id_seleccion` int DEFAULT NULL,
  PRIMARY KEY (`id_jugador`),
  KEY `idx_jugador_seleccion` (`seleccion_id_seleccion`),
  CONSTRAINT `jugador_ibfk_1` FOREIGN KEY (`seleccion_id_seleccion`) REFERENCES `seleccion` (`id_seleccion`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jugador`
--

LOCK TABLES `jugador` WRITE;
/*!40000 ALTER TABLE `jugador` DISABLE KEYS */;
INSERT INTO `jugador` VALUES (1,'Lionel Messi','Delantero',10,1,1),(2,'Kylian Mbappe','Delantero',9,1,2),(3,'Vinicius Jr','Delantero',7,1,3),(4,'Pedri','Mediocampista',8,1,4),(5,'Felix Nmecha','Mediocampista',10,1,5);
/*!40000 ALTER TABLE `jugador` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `partido`
--

DROP TABLE IF EXISTS `partido`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `partido` (
  `id_partido` int NOT NULL AUTO_INCREMENT,
  `fecha` timestamp NULL DEFAULT NULL,
  `fase` varchar(50) DEFAULT NULL,
  `seleccion_local` int DEFAULT NULL,
  `seleccion_visitante` int DEFAULT NULL,
  `estadio_id_estadio` int DEFAULT NULL,
  PRIMARY KEY (`id_partido`),
  KEY `seleccion_local` (`seleccion_local`),
  KEY `seleccion_visitante` (`seleccion_visitante`),
  KEY `idx_partido_fase` (`fase`),
  KEY `idx_partido_estadio` (`estadio_id_estadio`),
  CONSTRAINT `partido_ibfk_1` FOREIGN KEY (`seleccion_local`) REFERENCES `seleccion` (`id_seleccion`),
  CONSTRAINT `partido_ibfk_2` FOREIGN KEY (`seleccion_visitante`) REFERENCES `seleccion` (`id_seleccion`),
  CONSTRAINT `partido_ibfk_3` FOREIGN KEY (`estadio_id_estadio`) REFERENCES `estadio` (`id_estadio`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `partido`
--

LOCK TABLES `partido` WRITE;
/*!40000 ALTER TABLE `partido` DISABLE KEYS */;
INSERT INTO `partido` VALUES (2,'2026-06-12 20:00:00','Grupos',3,4,2),(3,'2026-06-15 23:00:00','Grupos',5,1,3),(4,'2026-06-20 20:00:00','Cuartos',2,3,4),(5,'2026-06-25 23:00:00','Semifinal',4,5,5);
/*!40000 ALTER TABLE `partido` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reporte_goleadores`
--

DROP TABLE IF EXISTS `reporte_goleadores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reporte_goleadores` (
  `id_reporte` int NOT NULL AUTO_INCREMENT,
  `fecha_generacion` timestamp NULL DEFAULT NULL,
  `nombre_jugador` varchar(150) DEFAULT NULL,
  `seleccion` varchar(100) DEFAULT NULL,
  `cantidad_goles` int DEFAULT NULL,
  PRIMARY KEY (`id_reporte`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reporte_goleadores`
--

LOCK TABLES `reporte_goleadores` WRITE;
/*!40000 ALTER TABLE `reporte_goleadores` DISABLE KEYS */;
INSERT INTO `reporte_goleadores` VALUES (1,'2026-07-16 14:14:10','Lionel Messi','Argentina',1),(2,'2026-07-16 14:14:10','Kylian Mbappe','Francia',1),(3,'2026-07-16 14:14:10','Vinicius Jr','Brasil',1),(4,'2026-07-16 14:14:10','Pedri','España',1),(5,'2026-07-16 14:14:10','Felix Nmecha','Alemania',1);
/*!40000 ALTER TABLE `reporte_goleadores` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `seleccion`
--

DROP TABLE IF EXISTS `seleccion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `seleccion` (
  `id_seleccion` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `grupo` varchar(5) DEFAULT NULL,
  `entrenador` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`id_seleccion`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `seleccion`
--

LOCK TABLES `seleccion` WRITE;
/*!40000 ALTER TABLE `seleccion` DISABLE KEYS */;
INSERT INTO `seleccion` VALUES (1,'Argentina','C','Lionel Scaloni'),(2,'Francia','D','Didier Deschamps'),(3,'Brasil','E','Carletto Ancelotti'),(4,'España','B','Pep Guardiola'),(5,'Alemania','A','Julian Nagelsmann');
/*!40000 ALTER TABLE `seleccion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'mundial2026'
--
/*!50106 SET @save_time_zone= @@TIME_ZONE */ ;
/*!50106 DROP EVENT IF EXISTS `generar_reporte_goleadores` */;
DELIMITER ;;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;;
/*!50003 SET character_set_client  = utf8mb4 */ ;;
/*!50003 SET character_set_results = utf8mb4 */ ;;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;;
/*!50003 SET @saved_time_zone      = @@time_zone */ ;;
/*!50003 SET time_zone             = 'SYSTEM' */ ;;
/*!50106 CREATE*/ /*!50117 DEFINER=`alumno27.rossatti.lucca.santino`@`localhost`*/ /*!50106 EVENT `generar_reporte_goleadores` ON SCHEDULE EVERY 1 WEEK STARTS '2026-07-16 11:14:10' ON COMPLETION NOT PRESERVE ENABLE DO BEGIN
    DELETE FROM reporte_goleadores;
    INSERT INTO reporte_goleadores (fecha_generacion, nombre_jugador, seleccion, cantidad_goles)
    SELECT
        NOW(),
        j.nombre,
        s.nombre,
        COUNT(g.id_gol)
    FROM gol g
    JOIN jugador j ON g.jugador_id_jugador = j.id_jugador
    JOIN seleccion s ON j.seleccion_id_seleccion = s.id_seleccion
    GROUP BY j.id_jugador, j.nombre, s.nombre
    ORDER BY COUNT(g.id_gol) DESC;
END */ ;;
/*!50003 SET time_zone             = @saved_time_zone */ ;;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;;
/*!50003 SET character_set_client  = @saved_cs_client */ ;;
/*!50003 SET character_set_results = @saved_cs_results */ ;;
/*!50003 SET collation_connection  = @saved_col_connection */ ;;
/*!50106 DROP EVENT IF EXISTS `purgar_goles_fase_grupos` */;;
DELIMITER ;;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;;
/*!50003 SET character_set_client  = utf8mb4 */ ;;
/*!50003 SET character_set_results = utf8mb4 */ ;;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;;
/*!50003 SET @saved_time_zone      = @@time_zone */ ;;
/*!50003 SET time_zone             = 'SYSTEM' */ ;;
/*!50106 CREATE*/ /*!50117 DEFINER=`alumno27.rossatti.lucca.santino`@`localhost`*/ /*!50106 EVENT `purgar_goles_fase_grupos` ON SCHEDULE EVERY 6 MONTH STARTS '2027-01-16 11:51:56' ON COMPLETION NOT PRESERVE ENABLE DO BEGIN
	DELETE FROM gol
    WHERE partido_id_partido IN (
		SELECT id_partido FROM partido WHERE fase = 'Grupos'
        );
END */ ;;
/*!50003 SET time_zone             = @saved_time_zone */ ;;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;;
/*!50003 SET character_set_client  = @saved_cs_client */ ;;
/*!50003 SET character_set_results = @saved_cs_results */ ;;
/*!50003 SET collation_connection  = @saved_col_connection */ ;;
DELIMITER ;
/*!50106 SET TIME_ZONE= @save_time_zone */ ;

--
-- Dumping routines for database 'mundial2026'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-07-16 11:57:44
