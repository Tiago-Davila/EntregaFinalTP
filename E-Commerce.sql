-- MySQL dump 10.13  Distrib 8.0.42, for Linux (x86_64)
--
-- Host: 127.0.0.1    Database: temporal
-- ------------------------------------------------------
-- Server version	8.0.42-0ubuntu0.22.04.1

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
-- Table structure for table `Categoria`
--

DROP TABLE IF EXISTS `Categoria`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Categoria` (
  `idCategoria` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`idCategoria`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Categoria`
--

LOCK TABLES `Categoria` WRITE;
/*!40000 ALTER TABLE `Categoria` DISABLE KEYS */;
INSERT INTO `Categoria` VALUES (1,'Electrónica'),(2,'Ropa'),(3,'Hogar'),(4,'Deportes'),(5,'Juguetes');
/*!40000 ALTER TABLE `Categoria` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Compra`
--

DROP TABLE IF EXISTS `Compra`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Compra` (
  `idCompra` int NOT NULL AUTO_INCREMENT,
  `fecha` date DEFAULT NULL,
  `cantidad` int DEFAULT NULL,
  `VentaDirecta_idVentaDirecta` int NOT NULL,
  `calificacionComprador` int DEFAULT NULL,
  `calificacionVendedor` int DEFAULT NULL,
  `usuarioComprador` int DEFAULT NULL,
  PRIMARY KEY (`idCompra`),
  KEY `fk_Compra_1_idx` (`VentaDirecta_idVentaDirecta`),
  KEY `usuarioComprador` (`usuarioComprador`),
  CONSTRAINT `fk_Compra_1` FOREIGN KEY (`VentaDirecta_idVentaDirecta`) REFERENCES `VentaDirecta` (`idVentaDirecta`),
  CONSTRAINT `usuarioComprador` FOREIGN KEY (`usuarioComprador`) REFERENCES `Usuario` (`idUsuario`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Compra`
--

LOCK TABLES `Compra` WRITE;
/*!40000 ALTER TABLE `Compra` DISABLE KEYS */;
INSERT INTO `Compra` VALUES (1,'2025-06-10',1,1,5,4,1),(2,'2025-06-11',2,2,4,5,2),(3,'2025-06-12',1,3,5,5,3),(4,'2025-06-13',3,4,3,4,4),(5,'2025-06-14',1,5,4,4,5);
/*!40000 ALTER TABLE `Compra` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Envio`
--

DROP TABLE IF EXISTS `Envio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Envio` (
  `idEnvio` int NOT NULL,
  `proveedor` enum('OCA','Correo argentino') DEFAULT NULL,
  PRIMARY KEY (`idEnvio`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Envio`
--

LOCK TABLES `Envio` WRITE;
/*!40000 ALTER TABLE `Envio` DISABLE KEYS */;
INSERT INTO `Envio` VALUES (1,'OCA'),(2,'Correo argentino'),(3,'OCA'),(4,'Correo argentino'),(5,'OCA');
/*!40000 ALTER TABLE `Envio` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `MedioPago`
--

DROP TABLE IF EXISTS `MedioPago`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `MedioPago` (
  `idMedioPago` int NOT NULL,
  `Tipo` enum('Tarjeta de debito','Tarjeta de credito','Rapipago','Pago Fácil') DEFAULT NULL,
  PRIMARY KEY (`idMedioPago`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `MedioPago`
--

LOCK TABLES `MedioPago` WRITE;
/*!40000 ALTER TABLE `MedioPago` DISABLE KEYS */;
INSERT INTO `MedioPago` VALUES (1,'Tarjeta de debito'),(2,'Tarjeta de credito'),(3,'Rapipago'),(4,'Pago Fácil'),(5,'Tarjeta de debito');
/*!40000 ALTER TABLE `MedioPago` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Oferta`
--

DROP TABLE IF EXISTS `Oferta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Oferta` (
  `Usuario_idUsuario` int NOT NULL,
  `Subasta_idSubasta` int NOT NULL,
  `precioOfertado` int DEFAULT NULL,
  `fechaOferta` date DEFAULT NULL,
  PRIMARY KEY (`Usuario_idUsuario`,`Subasta_idSubasta`),
  KEY `fk_Usuario_has_Subasta_Subasta1_idx` (`Subasta_idSubasta`),
  KEY `fk_Usuario_has_Subasta_Usuario1_idx` (`Usuario_idUsuario`),
  CONSTRAINT `fk_Usuario_has_Subasta_Subasta1` FOREIGN KEY (`Subasta_idSubasta`) REFERENCES `Subasta` (`idSubasta`),
  CONSTRAINT `fk_Usuario_has_Subasta_Usuario1` FOREIGN KEY (`Usuario_idUsuario`) REFERENCES `Usuario` (`idUsuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Oferta`
--

LOCK TABLES `Oferta` WRITE;
/*!40000 ALTER TABLE `Oferta` DISABLE KEYS */;
INSERT INTO `Oferta` VALUES (1,101,460,'2025-06-04'),(2,102,630,'2025-06-06');
/*!40000 ALTER TABLE `Oferta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Pregunta`
--

DROP TABLE IF EXISTS `Pregunta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Pregunta` (
  `idPregunta` int NOT NULL AUTO_INCREMENT,
  `pregunta` varchar(45) DEFAULT NULL,
  `Publicacion_idPublicacion` int NOT NULL,
  `Respuesta_idRespuesta` int NOT NULL,
  `usuarioPregunta` int NOT NULL,
  PRIMARY KEY (`idPregunta`),
  KEY `fk_Pregunta_Publicacion1_idx` (`Publicacion_idPublicacion`),
  KEY `fk_Pregunta_Respuesta1_idx` (`Respuesta_idRespuesta`),
  KEY `fk_Pregunta_Usuario1_idx` (`usuarioPregunta`),
  CONSTRAINT `fk_Pregunta_Publicacion1` FOREIGN KEY (`Publicacion_idPublicacion`) REFERENCES `Publicacion` (`idPublicacion`),
  CONSTRAINT `fk_Pregunta_Respuesta1` FOREIGN KEY (`Respuesta_idRespuesta`) REFERENCES `Respuesta` (`idRespuesta`),
  CONSTRAINT `fk_Pregunta_Usuario1` FOREIGN KEY (`usuarioPregunta`) REFERENCES `Usuario` (`idUsuario`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Pregunta`
--

LOCK TABLES `Pregunta` WRITE;
/*!40000 ALTER TABLE `Pregunta` DISABLE KEYS */;
INSERT INTO `Pregunta` VALUES (1,'¿Tiene garantía?',1,1,1),(2,'¿Es resistente al agua?',2,2,2),(3,'¿Hay más colores?',3,3,3),(4,'¿Incluye accesorios?',4,4,4),(5,'¿Compatible con Android?',5,5,5);
/*!40000 ALTER TABLE `Pregunta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Producto`
--

DROP TABLE IF EXISTS `Producto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Producto` (
  `idProducto` int NOT NULL AUTO_INCREMENT,
  `Categoria_idCategoria` int NOT NULL,
  `descripcion` text NOT NULL,
  `nombre` text NOT NULL,
  PRIMARY KEY (`idProducto`),
  KEY `fk_Producto_Categoria1_idx` (`Categoria_idCategoria`),
  CONSTRAINT `fk_Producto_Categoria1` FOREIGN KEY (`Categoria_idCategoria`) REFERENCES `Categoria` (`idCategoria`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Producto`
--

LOCK TABLES `Producto` WRITE;
/*!40000 ALTER TABLE `Producto` DISABLE KEYS */;
INSERT INTO `Producto` VALUES (1,1,'Smartphone con pantalla AMOLED','Smartphone A1'),(2,2,'Campera de cuero sintético','Campera C2'),(3,3,'Mesa de comedor extensible','Mesa M3'),(4,4,'Bicicleta de montaña','Bici B4'),(5,5,'Muñeca articulada con accesorios','Muñeca M5');
/*!40000 ALTER TABLE `Producto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Publicacion`
--

DROP TABLE IF EXISTS `Publicacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Publicacion` (
  `idPublicacion` int NOT NULL AUTO_INCREMENT,
  `Tipo` enum('Venta directa','Subasta') DEFAULT NULL,
  `fechaInicio` date DEFAULT NULL,
  `estado` enum('Disponible','No disponible','Pausada') DEFAULT NULL,
  `nivel` enum('Bronce','Plata','Oro','Platino') DEFAULT NULL,
  `precio` int DEFAULT NULL,
  `Producto_idProducto` int NOT NULL,
  `usuarioVendedor` int NOT NULL,
  PRIMARY KEY (`idPublicacion`),
  KEY `fk_Publicacion_Producto1_idx` (`Producto_idProducto`),
  KEY `fk_Publicacion_Usuario1_idx` (`usuarioVendedor`),
  CONSTRAINT `fk_Publicacion_Producto1` FOREIGN KEY (`Producto_idProducto`) REFERENCES `Producto` (`idProducto`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_Publicacion_Usuario1` FOREIGN KEY (`usuarioVendedor`) REFERENCES `Usuario` (`idUsuario`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Publicacion`
--

LOCK TABLES `Publicacion` WRITE;
/*!40000 ALTER TABLE `Publicacion` DISABLE KEYS */;
INSERT INTO `Publicacion` VALUES (1,'Venta directa','2025-06-01','Disponible','Bronce',550,1,1),(2,'Venta directa','2025-06-02','Disponible','Plata',800,2,2),(3,'Subasta','2025-06-03','Disponible','Oro',400,3,3),(4,'Venta directa','2025-06-04','Disponible','Platino',1200,4,4),(5,'Subasta','2025-06-05','Disponible','Bronce',600,5,5);
/*!40000 ALTER TABLE `Publicacion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Respuesta`
--

DROP TABLE IF EXISTS `Respuesta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Respuesta` (
  `idRespuesta` int NOT NULL AUTO_INCREMENT,
  `respuesta` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`idRespuesta`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Respuesta`
--

LOCK TABLES `Respuesta` WRITE;
/*!40000 ALTER TABLE `Respuesta` DISABLE KEYS */;
INSERT INTO `Respuesta` VALUES (1,'Sí, tiene garantía de 1 año'),(2,'Sí, resistente a salpicaduras'),(3,'Colores disponibles: negro, azul'),(4,'Incluye todos los accesorios'),(5,'Compatible con iOS y Android');
/*!40000 ALTER TABLE `Respuesta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Subasta`
--

DROP TABLE IF EXISTS `Subasta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Subasta` (
  `idSubasta` int NOT NULL AUTO_INCREMENT,
  `fechaInicio` date DEFAULT NULL,
  `fechaFin` date DEFAULT NULL,
  `precioFinal` int DEFAULT NULL,
  `Publicacion_idPublicacion` int NOT NULL,
  PRIMARY KEY (`idSubasta`),
  KEY `fk_Subasta_Publicacion1_idx` (`Publicacion_idPublicacion`),
  CONSTRAINT `fk_Subasta_Publicacion1` FOREIGN KEY (`Publicacion_idPublicacion`) REFERENCES `Publicacion` (`idPublicacion`)
) ENGINE=InnoDB AUTO_INCREMENT=106 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Subasta`
--

LOCK TABLES `Subasta` WRITE;
/*!40000 ALTER TABLE `Subasta` DISABLE KEYS */;
INSERT INTO `Subasta` VALUES (101,'2025-06-03','2025-06-13',450,3),(102,'2025-06-05','2025-06-15',620,5);
/*!40000 ALTER TABLE `Subasta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `Top10cat`
--

DROP TABLE IF EXISTS `Top10cat`;
/*!50001 DROP VIEW IF EXISTS `Top10cat`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `Top10cat` AS SELECT 
 1 AS `nombre`,
 1 AS `d`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `TopPubli`
--

DROP TABLE IF EXISTS `TopPubli`;
/*!50001 DROP VIEW IF EXISTS `TopPubli`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `TopPubli` AS SELECT 
 1 AS `idPublicacion`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `Usuario`
--

DROP TABLE IF EXISTS `Usuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Usuario` (
  `idUsuario` int NOT NULL,
  `nombre` varchar(45) DEFAULT NULL,
  `apellido` varchar(45) DEFAULT NULL,
  `direccion` varchar(45) DEFAULT NULL,
  `nivel` enum('Normal','Platinum','Gold') DEFAULT NULL,
  `reputacion` varchar(45) DEFAULT NULL,
  `email` varchar(255) NOT NULL,
  PRIMARY KEY (`idUsuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Usuario`
--

LOCK TABLES `Usuario` WRITE;
/*!40000 ALTER TABLE `Usuario` DISABLE KEYS */;
INSERT INTO `Usuario` VALUES (1,'Juan','Pérez','Av. Siempre Viva 123','Normal','60','juan.perez@email.com'),(2,'Ana','Gómez','Calle Falsa 456','Platinum','70','ana.gomez@email.com'),(3,'Luis','Martínez','Calle Real 789','Gold','80','luis.martinez@email.com'),(4,'Marta','Díaz','Av. Libertador 101','Normal','90','marta.diaz@email.com'),(5,'Pedro','López','Calle Nueva 202','Platinum','100','pedro.lopez@email.com');
/*!40000 ALTER TABLE `Usuario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `Vendedor`
--

DROP TABLE IF EXISTS `Vendedor`;
/*!50001 DROP VIEW IF EXISTS `Vendedor`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `Vendedor` AS SELECT 
 1 AS `nombre`,
 1 AS `nombreC`,
 1 AS `idCategoria`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `VentaDirecta`
--

DROP TABLE IF EXISTS `VentaDirecta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `VentaDirecta` (
  `idVentaDirecta` int NOT NULL AUTO_INCREMENT,
  `direccionEnvio` varchar(45) DEFAULT NULL,
  `MedioPago_idMedioPago` int NOT NULL,
  `Envio_idEnvio` int NOT NULL,
  `Publicacion_idPublicacion` int NOT NULL,
  PRIMARY KEY (`idVentaDirecta`),
  KEY `fk_Venta directa_MedioPago1_idx` (`MedioPago_idMedioPago`),
  KEY `fk_Venta directa_Envio1_idx` (`Envio_idEnvio`),
  KEY `fk_VentaDirecta_Publicacion1_idx` (`Publicacion_idPublicacion`),
  CONSTRAINT `fk_Venta directa_Envio1` FOREIGN KEY (`Envio_idEnvio`) REFERENCES `Envio` (`idEnvio`),
  CONSTRAINT `fk_Venta directa_MedioPago1` FOREIGN KEY (`MedioPago_idMedioPago`) REFERENCES `MedioPago` (`idMedioPago`),
  CONSTRAINT `fk_VentaDirecta_Publicacion1` FOREIGN KEY (`Publicacion_idPublicacion`) REFERENCES `Publicacion` (`idPublicacion`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `VentaDirecta`
--

LOCK TABLES `VentaDirecta` WRITE;
/*!40000 ALTER TABLE `VentaDirecta` DISABLE KEYS */;
INSERT INTO `VentaDirecta` VALUES (1,'Av. Siempre Viva 123',1,1,1),(2,'Calle Falsa 456',2,2,2),(3,'Av. Libertador 101',3,4,4),(4,'Calle Nueva 202',4,5,5),(5,'Calle Real 789',5,3,3);
/*!40000 ALTER TABLE `VentaDirecta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `pregun`
--

DROP TABLE IF EXISTS `pregun`;
/*!50001 DROP VIEW IF EXISTS `pregun`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `pregun` AS SELECT 
 1 AS `idPregunta`,
 1 AS `pregunta`,
 1 AS `Publicacion_idPublicacion`,
 1 AS `nombre`,
 1 AS `nombreU`*/;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `Top10cat`
--

/*!50001 DROP VIEW IF EXISTS `Top10cat`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`alumno`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `Top10cat` AS select `Categoria`.`nombre` AS `nombre`,count(0) AS `d` from ((`Categoria` join `Producto` on((`Producto`.`Categoria_idCategoria` = `Categoria`.`idCategoria`))) join `Publicacion` on((`Publicacion`.`Producto_idProducto` = `Producto`.`idProducto`))) where (`Publicacion`.`fechaInicio` > (curdate() - interval 7 day)) group by `Categoria`.`nombre` order by `d` desc limit 10 */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `TopPubli`
--

/*!50001 DROP VIEW IF EXISTS `TopPubli`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`alumno`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `TopPubli` AS select `Publicacion`.`idPublicacion` AS `idPublicacion` from (`Publicacion` join `Pregunta` on((`Pregunta`.`Publicacion_idPublicacion` = `Publicacion`.`idPublicacion`))) where (`Publicacion`.`fechaInicio` = curdate()) group by `Publicacion`.`idPublicacion` order by count(0) desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `Vendedor`
--

/*!50001 DROP VIEW IF EXISTS `Vendedor`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`alumno`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `Vendedor` AS select `Usuario`.`nombre` AS `nombre`,`Categoria`.`nombre` AS `nombreC`,`Categoria`.`idCategoria` AS `idCategoria` from (((`Usuario` join `Publicacion` on((`Publicacion`.`usuarioVendedor` = `Usuario`.`idUsuario`))) join `Producto` on((`Producto`.`idProducto` = `Publicacion`.`Producto_idProducto`))) join `Categoria` on((`Producto`.`Categoria_idCategoria` = `Categoria`.`idCategoria`))) group by `Categoria`.`idCategoria`,`Usuario`.`idUsuario` having (0 <> max(`Usuario`.`reputacion`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `pregun`
--

/*!50001 DROP VIEW IF EXISTS `pregun`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`alumno`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `pregun` AS select `Pregunta`.`idPregunta` AS `idPregunta`,`Pregunta`.`pregunta` AS `pregunta`,`Pregunta`.`Publicacion_idPublicacion` AS `Publicacion_idPublicacion`,`Producto`.`nombre` AS `nombre`,`Usuario`.`nombre` AS `nombreU` from (((`Pregunta` join `Publicacion` on((`Pregunta`.`Publicacion_idPublicacion` = `Publicacion`.`idPublicacion`))) join `Usuario` on((`Pregunta`.`usuarioPregunta` = `Usuario`.`idUsuario`))) join `Producto` on((`Publicacion`.`Producto_idProducto` = `Producto`.`idProducto`))) where ((`Pregunta`.`Respuesta_idRespuesta` is null) and (`Publicacion`.`estado` = 'Disponible')) */;
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

-- Dump completed on 2025-07-17 11:04:38
