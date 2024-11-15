-- MySQL dump 10.14  Distrib 5.5.68-MariaDB, for Win32 (AMD64)
--
-- Host: localhost    Database: raja-laundry
-- ------------------------------------------------------
-- Server version	5.5.68-MariaDB
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO,POSTGRESQL' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table "customer"
--

DROP TABLE IF EXISTS "customer";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "customer" (
  "ID_CUSTOMER" int(11) NOT NULL,
  "NAMA_CUSTOMER" varchar(50) NOT NULL,
  "ALAMAT_CUSTOMER" varchar(100) DEFAULT NULL,
  "TELEPON_CUSTOMER" varchar(16) DEFAULT NULL,
  PRIMARY KEY ("ID_CUSTOMER")
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table "customer"
--

LOCK TABLES "customer" WRITE;
/*!40000 ALTER TABLE "customer" DISABLE KEYS */;
INSERT INTO "customer" VALUES (1,'??',NULL,NULL),(2,'Aan',NULL,NULL),(3,'Adiu',NULL,NULL),(4,'AE9',NULL,NULL),(5,'Agus',NULL,NULL),(6,'Ailis',NULL,NULL),(7,'Aji',NULL,NULL),(8,'Akbar',NULL,NULL),(9,'Aldi',NULL,NULL),(10,'Ali',NULL,NULL),(11,'Alsi',NULL,NULL),(12,'Ambar',NULL,NULL),(13,'Amel',NULL,NULL),(14,'Amil',NULL,NULL),(15,'Amin',NULL,NULL),(16,'Aminah',NULL,NULL),(17,'Amira',NULL,NULL),(18,'Ana',NULL,NULL),(19,'Andre',NULL,NULL),(20,'Ani',NULL,NULL),(21,'Anies',NULL,NULL),(22,'Anik',NULL,NULL),(23,'Anin',NULL,NULL),(24,'Anis',NULL,NULL),(25,'Ansri',NULL,NULL),(26,'Antho',NULL,NULL),(27,'Arina',NULL,NULL),(28,'Asad',NULL,NULL),(29,'Atik',NULL,NULL),(30,'Aulia',NULL,NULL),(31,'Bambang',NULL,NULL),(32,'Boneka',NULL,NULL),(33,'Brei',NULL,NULL),(34,'Budiarso',NULL,NULL),(35,'Caca',NULL,NULL),(36,'Celsi',NULL,NULL),(37,'Cili',NULL,NULL),(38,'D116',NULL,NULL),(39,'Dani',NULL,NULL),(40,'Dava',NULL,NULL),(41,'Debi',NULL,NULL),(42,'Dedi',NULL,NULL),(43,'Dedy',NULL,NULL),(44,'Deni',NULL,NULL),(45,'Denis',NULL,NULL),(46,'Deri',NULL,NULL),(47,'Devi',NULL,NULL),(48,'Devita',NULL,NULL),(49,'Dewi',NULL,NULL),(50,'Dias',NULL,NULL),(51,'Didin',NULL,NULL),(52,'Didit',NULL,NULL),(53,'Dika',NULL,NULL),(54,'Dimin',NULL,NULL),(55,'Dina',NULL,NULL),(56,'Disnin',NULL,NULL),(57,'Duwi',NULL,NULL),(58,'E',NULL,NULL),(59,'Elis',NULL,NULL),(60,'Elok',NULL,NULL),(61,'Emi',NULL,NULL),(62,'Enis',NULL,NULL),(63,'Enum',NULL,NULL),(64,'Epani',NULL,NULL),(65,'Erlin',NULL,NULL),(66,'Eruni',NULL,NULL),(67,'Erwin',NULL,NULL),(68,'Etik',NULL,NULL),(69,'Falent',NULL,NULL),(70,'Fani',NULL,NULL),(71,'Feni',NULL,NULL),(72,'Feri',NULL,NULL),(73,'Fitri',NULL,NULL),(74,'Frida',NULL,NULL),(75,'Haito',NULL,NULL),(76,'Hana',NULL,NULL),(77,'Haris',NULL,NULL),(78,'Harto',NULL,NULL),(79,'Hen',NULL,NULL),(80,'Hendra',NULL,NULL),(81,'Hendrik',NULL,NULL),(82,'Heri',NULL,NULL),(83,'Hestia',NULL,NULL),(84,'Hidayat',NULL,NULL),(85,'Ida',NULL,NULL),(86,'Iin',NULL,NULL),(87,'Iis',NULL,NULL),(88,'Ika',NULL,NULL),(89,'Ilis',NULL,NULL),(90,'Ima',NULL,NULL),(91,'Imran',NULL,NULL),(92,'Ina',NULL,NULL),(93,'Indah',NULL,NULL),(94,'Ipul',NULL,NULL),(95,'Ita',NULL,NULL),(96,'Iwan',NULL,NULL),(97,'Jani',NULL,NULL),(98,'Jeli',NULL,NULL),(99,'Joko',NULL,NULL),(100,'K10',NULL,NULL),(101,'K4',NULL,NULL),(102,'Kaban',NULL,NULL),(103,'Karpet',NULL,NULL),(104,'Keizi',NULL,NULL),(105,'Kinan',NULL,NULL),(106,'KLbu',NULL,NULL),(107,'Kondan',NULL,NULL),(108,'Koyum',NULL,NULL),(109,'Leli',NULL,NULL),(110,'Lia',NULL,NULL),(111,'Lili',NULL,NULL),(112,'Ling',NULL,NULL),(113,'Malika',NULL,NULL),(114,'Malka',NULL,NULL),(115,'Maria',NULL,NULL),(116,'Maula',NULL,NULL),(117,'Maulana',NULL,NULL),(118,'Mega',NULL,NULL),(119,'Melinda',NULL,NULL),(120,'Micel',NULL,NULL),(121,'Miya',NULL,NULL),(122,'Mulyana',NULL,NULL),(123,'Nadi',NULL,NULL),(124,'Nam',NULL,NULL),(125,'Nama lupa',NULL,NULL),(126,'Nanda',NULL,NULL),(127,'Nasya',NULL,NULL),(128,'Nia',NULL,NULL),(129,'Nikfuk',NULL,NULL),(130,'Nita',NULL,NULL),(131,'Nur',NULL,NULL),(132,'Nyata',NULL,NULL),(133,'Padi',NULL,NULL),(134,'Pipit',NULL,NULL),(135,'Priska',NULL,NULL),(136,'Putri',NULL,NULL),(137,'R 10',NULL,NULL),(138,'Ramli',NULL,NULL),(139,'Rani',NULL,NULL),(140,'RI4',NULL,NULL),(141,'Riadi',NULL,NULL),(142,'Rifa',NULL,NULL),(143,'Rin',NULL,NULL),(144,'Rizal',NULL,NULL),(145,'Rudi',NULL,NULL),(146,'Saiji',NULL,NULL),(147,'Salma',NULL,NULL),(148,'Samsi',NULL,NULL),(149,'Sandi',NULL,NULL),(150,'Santi',NULL,NULL),(151,'Sari',NULL,NULL),(152,'Sate',NULL,NULL),(153,'Sausi',NULL,NULL),(154,'SI Ktuk',NULL,NULL),(155,'Silir',NULL,NULL),(156,'Sinta',NULL,NULL),(157,'Siva',NULL,NULL),(158,'Sofa',NULL,NULL),(159,'Suisa?',NULL,NULL),(160,'Sukina',NULL,NULL),(161,'Sukma',NULL,NULL),(162,'Sum',NULL,NULL),(163,'Susi',NULL,NULL),(164,'Tabita',NULL,NULL),(165,'Tanto',NULL,NULL),(166,'Tarno',NULL,NULL),(167,'Taso',NULL,NULL),(168,'Teli',NULL,NULL),(169,'Tias',NULL,NULL),(170,'Tiko',NULL,NULL),(171,'Tina',NULL,NULL),(172,'Tito',NULL,NULL),(173,'Tiwo',NULL,NULL),(174,'Toluk',NULL,NULL),(175,'Tono',NULL,NULL),(176,'Totok',NULL,NULL),(177,'Vidi',NULL,NULL),(178,'Viktor',NULL,NULL),(179,'Vin',NULL,NULL),(180,'Vita',NULL,NULL),(181,'Vivi',NULL,NULL),(182,'W',NULL,NULL),(183,'Webi',NULL,NULL),(184,'Wedi',NULL,NULL),(185,'Weni',NULL,NULL),(186,'Widi',NULL,NULL),(187,'Wili',NULL,NULL),(188,'Wito',NULL,NULL),(189,'Wiwin',NULL,NULL),(190,'Wuri',NULL,NULL),(191,'Yanti',NULL,NULL),(192,'Yeni',NULL,NULL),(193,'Yogi',NULL,NULL),(194,'Yuni',NULL,NULL),(195,'Yusuf',NULL,NULL);
/*!40000 ALTER TABLE "customer" ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table "item_kupon"
--

DROP TABLE IF EXISTS "item_kupon";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "item_kupon" (
  "ID_PESANAN" int(11) NOT NULL,
  "ID_KUPON" int(11) NOT NULL,
  PRIMARY KEY ("ID_PESANAN"),
  KEY "FK_ITEM_KUP_RELATIONS_KUPON" ("ID_KUPON"),
  CONSTRAINT "FK_ITEM_KUP_MERUPAKAN_PESANAN" FOREIGN KEY ("ID_PESANAN") REFERENCES "pesanan" ("ID_PESANAN"),
  CONSTRAINT "FK_ITEM_KUP_RELATIONS_KUPON" FOREIGN KEY ("ID_KUPON") REFERENCES "kupon" ("ID_KUPON")
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table "item_kupon"
--

LOCK TABLES "item_kupon" WRITE;
/*!40000 ALTER TABLE "item_kupon" DISABLE KEYS */;
/*!40000 ALTER TABLE "item_kupon" ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `ON_INSERT_ITEM_KUPON` BEFORE INSERT ON `item_kupon` FOR EACH ROW BEGIN
	IF EXISTS(
		SELECT TRUE 
		FROM pesanan P, kupon K 
		WHERE P.ID_PESANAN=K.ID_PESANAN
			AND P.ID_PESANAN=NEW.ID_PESANAN
			AND K.ID_KUPON=NEW.ID_KUPON) THEN
		SIGNAL SQLSTATE '45000' SET message_text = "Pesanan tidak boleh menjadi kupon pesanan itu sendiri";
	END IF;
	IF NOT EXISTS(
		SELECT TRUE 
		FROM pesanan P
		WHERE P.ID_PESANAN=NEW.ID_PESANAN
			AND P.TANGGAL_LUNAS IS NOT NULL) THEN
		SIGNAL SQLSTATE '45000' SET message_text = "Kwitansi tidak ditemukan";
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
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `ON_INSERT_KUPON` AFTER INSERT ON `item_kupon` FOR EACH ROW begin
    CALL RECALCULATE_TOTAL_ITEM(NEW.ID_PESANAN);
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `ON_UPDATE_ITEM_KUPON` BEFORE UPDATE ON `item_kupon` FOR EACH ROW BEGIN
	IF EXISTS(
		SELECT TRUE 
		FROM pesanan P, kupon K 
		WHERE P.ID_PESANAN=K.ID_PESANAN
			AND P.ID_PESANAN=NEW.ID_PESANAN
			AND K.ID_KUPON=NEW.ID_KUPON) THEN
		SIGNAL SQLSTATE '45000' SET message_text = "Pesanan tidak boleh menjadi kupon pesanan itu sendiri";
	END IF;
	IF NOT EXISTS(
		SELECT TRUE 
		FROM pesanan P
		WHERE P.ID_PESANAN=NEW.ID_PESANAN
			AND P.TANGGAL_LUNAS IS NOT NULL) THEN
		SIGNAL SQLSTATE '45000' SET message_text = "Kwitansi tidak ditemukan";
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
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `ON_UPDATE_KUPON` AFTER UPDATE ON `item_kupon` FOR EACH ROW begin
    CALL RECALCULATE_TOTAL_ITEM(NEW.ID_PESANAN);
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `ON_DELETE_KUPON` AFTER DELETE ON `item_kupon` FOR EACH ROW begin
    CALL RECALCULATE_TOTAL_ITEM(OLD.ID_PESANAN);
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table "item_pesanan"
--

DROP TABLE IF EXISTS "item_pesanan";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "item_pesanan" (
  "ID_ITEM" int(11) NOT NULL,
  "ID_PESANAN" int(11) NOT NULL,
  "ID_PAKET" int(16) NOT NULL,
  "ID_UNIT" int(16) DEFAULT '10',
  "QTY" int(11) DEFAULT '1',
  "HARGA" int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY ("ID_ITEM"),
  KEY "FK_ITEM_PES_MEMILIKI__PESANAN" ("ID_PESANAN"),
  KEY "FK_PAKET" ("ID_PAKET"),
  KEY "FK_UNIT" ("ID_UNIT"),
  CONSTRAINT "FK_ITEM_PES_MEMILIKI__PESANAN" FOREIGN KEY ("ID_PESANAN") REFERENCES "pesanan" ("ID_PESANAN"),
  CONSTRAINT "FK_PAKET" FOREIGN KEY ("ID_PAKET") REFERENCES "paket" ("ID_PAKET"),
  CONSTRAINT "FK_UNIT" FOREIGN KEY ("ID_UNIT") REFERENCES "unit" ("ID_UNIT")
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table "item_pesanan"
--

LOCK TABLES "item_pesanan" WRITE;
/*!40000 ALTER TABLE "item_pesanan" DISABLE KEYS */;
INSERT INTO "item_pesanan" VALUES (1,1,6,10,1,0),(2,2,7,17,1,0),(3,3,6,10,1,0),(4,4,9,10,9,0),(5,5,4,10,9,0),(6,6,6,7,1,5000),(7,7,5,10,4,20000),(8,8,6,10,9,45000),(9,9,9,10,14,54000),(10,10,6,10,7,50000),(11,10,6,15,1,0),(12,11,9,10,3,12000),(13,12,6,10,6,15000),(14,13,11,16,1,0),(15,14,6,10,6,30000),(16,15,6,10,7,40000),(17,15,6,15,1,0),(18,16,9,10,10,40000),(19,17,9,10,7,28000),(20,18,6,15,1,10000),(21,19,5,10,11,44000),(22,20,7,4,2,0),(23,21,9,10,6,22000),(24,22,6,10,10,47500),(25,23,4,10,9,25500),(26,24,6,15,1,10000),(27,25,4,10,5,15000),(28,26,6,1,2,40000),(29,27,6,10,12,60000),(30,28,6,15,1,55000),(31,29,6,10,5,25000),(32,30,6,1,1,25000),(33,31,5,10,6,34000),(34,31,5,15,2,0),(35,32,6,15,1,10000),(36,33,4,10,1,0),(37,34,5,10,4,20000),(38,35,6,10,8,40000),(39,36,9,10,7,26000),(40,37,9,10,6,24000),(41,38,9,10,2,10000),(42,39,9,10,6,24000),(43,40,6,10,6,30000),(44,41,6,15,1,10000),(45,42,6,10,1,26000),(46,42,9,10,1,0),(47,43,5,10,7,26000),(48,44,6,10,6,30000),(49,45,9,10,15,60000),(50,46,11,14,1,0),(51,47,5,10,3,20000),(52,48,11,14,3,0),(53,49,6,10,5,35000),(54,49,6,15,1,0),(55,50,5,10,25,100000),(56,51,11,14,5,0),(57,52,5,10,8,32000),(58,53,6,10,1,75000),(59,54,5,10,6,24000),(60,55,11,14,1,0),(61,56,9,10,1,85000),(62,56,6,10,1,0),(63,57,5,10,4,14000),(64,58,6,10,10,0),(65,59,6,10,6,30000),(66,60,9,10,4,18000),(67,61,6,10,8,40000),(68,62,9,10,1,0),(69,63,6,10,8,40000),(70,64,11,14,1,0),(71,65,6,15,1,10000),(72,65,10,10,2,0),(73,66,6,10,5,25000),(74,67,6,10,13,65000),(75,68,5,8,1,15000),(76,69,9,10,20,78000),(77,70,7,9,1,0),(78,71,9,10,7,28000),(79,72,9,10,5,20000),(80,73,5,10,4,28000),(81,74,4,10,10,28500),(82,75,5,10,4,20000),(83,76,6,10,1,25000),(84,77,9,10,6,24000),(85,78,9,10,1,0),(86,79,6,10,7,35000),(87,80,6,10,7,32500),(88,81,6,10,8,40000),(89,82,9,10,10,40000),(90,83,9,10,3,12000),(91,84,6,10,1,50000),(92,85,5,10,7,20000),(93,86,5,10,5,20000),(94,87,6,10,4,25000),(95,88,9,10,6,24000),(96,89,9,10,2,10000),(97,90,9,10,6,30000),(98,91,9,10,10,40000),(99,92,5,10,4,20000),(100,93,11,14,1,0),(101,94,6,10,4,25000),(102,95,5,10,6,22000),(103,96,6,1,2,30000),(104,97,9,10,8,30000),(105,98,5,10,1,50000),(106,99,5,10,6,25000),(107,100,6,10,9,45000),(108,101,6,10,1,25000),(109,101,6,15,1,0),(110,102,6,1,1,15000),(111,103,6,15,1,35000),(112,103,6,1,1,0),(113,104,9,10,6,24000),(114,105,6,10,7,32500),(115,106,6,15,1,10000),(116,107,9,10,2,0),(117,108,4,10,9,27000),(118,109,5,10,6,24000),(119,110,9,10,5,25000),(120,111,6,10,7,35000),(121,112,6,10,8,37000),(122,113,5,10,6,22000),(123,114,6,15,1,10000),(124,115,7,10,4,0),(125,116,9,10,4,18000),(126,117,9,10,7,28000),(127,118,5,10,3,20000),(128,119,9,10,6,22000),(129,120,6,10,10,50000),(130,121,5,10,12,48000),(131,122,6,10,5,25000),(132,123,6,10,3,12500),(133,124,6,10,7,35000),(134,125,6,10,1,70000),(135,126,4,10,12,36000),(136,127,9,10,6,24000),(137,128,5,10,5,20000),(138,129,6,10,6,30000),(139,130,6,1,1,30000),(140,131,5,10,38,152000),(141,132,6,10,8,40000),(142,133,9,10,8,32000),(143,134,5,10,7,28000),(144,135,6,10,9,45000),(145,136,6,10,8,50000),(146,136,6,15,1,0),(147,137,7,15,1,0),(148,138,5,10,6,40000),(149,139,6,10,5,25000),(150,140,7,7,1,0),(151,141,6,10,4,25000),(152,142,6,10,5,25000),(153,143,6,10,6,27500),(154,144,6,10,8,40000),(155,145,5,10,1,30000),(156,146,4,10,8,20000),(157,147,9,10,11,44000),(158,148,6,10,5,0),(159,149,9,10,5,15000),(160,150,4,10,5,15000),(161,151,5,10,8,32000),(162,152,6,10,3,15000),(163,153,6,15,1,45000),(164,153,6,1,1,0),(165,154,5,12,1,20000),(166,155,9,10,15,60000),(167,156,5,10,6,24000),(168,157,6,10,7,35000),(169,158,6,10,7,32000),(170,159,6,10,6,30000),(171,160,5,10,4,20000),(172,161,6,15,1,40000),(173,161,6,10,6,0),(174,162,11,14,3,0),(175,163,9,10,11,42500),(176,164,6,10,10,50000),(177,165,5,10,8,32000),(178,166,9,10,10,40000),(179,167,6,1,2,60000),(180,167,6,15,2,0),(181,168,9,10,1,0),(182,169,6,10,8,40000),(183,170,5,10,15,60000),(184,171,5,10,22,0),(185,172,6,10,1,55000),(186,173,11,14,1,0),(187,174,6,10,7,37000),(188,174,9,10,1,0),(189,175,6,10,6,30000),(190,176,6,1,1,60000),(191,177,4,10,5,15000),(192,178,6,10,6,27500),(193,179,6,10,3,20000),(194,180,6,10,5,25000),(195,181,11,14,1,0),(196,182,6,15,2,20000),(197,183,9,10,6,34000),(198,184,6,10,8,40000),(199,185,9,10,13,52000),(200,186,6,10,4,20000),(201,187,5,10,3,20000),(202,188,6,10,9,45000),(203,189,6,9,1,0),(204,190,9,10,12,48000),(205,191,6,15,2,40000),(206,191,6,13,1,0),(207,192,9,10,9,36000),(208,193,6,10,6,30000),(209,194,6,10,6,30000),(210,195,6,10,6,30000),(211,196,9,10,7,28000),(212,197,6,15,2,20000),(213,198,5,10,6,24000),(214,199,5,10,7,28000),(215,200,6,10,8,40000),(216,201,6,10,6,40000),(217,201,6,15,1,0),(218,202,6,15,4,50000),(219,202,6,5,2,0),(220,203,6,11,4,0),(221,204,6,10,4,25000),(222,205,11,14,1,0),(223,206,5,10,16,0),(224,207,6,10,9,45000),(225,208,5,10,5,20000),(226,209,6,10,4,25000),(227,210,5,10,11,42000),(228,211,6,1,1,25000),(229,212,4,10,8,24000),(230,213,6,10,9,42500),(231,214,6,10,8,40000),(232,215,6,10,4,25000),(233,216,6,1,2,40000),(234,217,11,14,1,60000),(235,217,6,1,1,0),(236,218,6,10,13,65000),(237,219,5,10,8,30000),(238,220,6,10,4,25000),(239,221,6,10,4,20000),(240,222,5,10,7,28000),(241,223,6,10,6,30000),(242,224,5,10,5,20000),(243,225,6,15,1,100000),(244,226,6,1,1,20000),(245,227,9,10,7,28000),(246,228,6,10,6,30000),(247,229,9,10,15,58000),(248,230,6,15,1,35000),(249,231,5,10,6,24000),(250,232,9,10,9,36000),(251,233,6,15,2,20000),(252,234,6,10,12,57500),(253,235,6,15,1,15000),(254,236,6,10,4,20000),(255,237,4,10,10,30000),(256,238,6,10,3,25000),(257,239,9,10,9,30000),(258,240,9,10,10,40000);
/*!40000 ALTER TABLE "item_pesanan" ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `ON_INSERT_ITEM_PESANAN` AFTER INSERT ON `item_pesanan` FOR EACH ROW begin
    CALL RECALCULATE_TOTAL_ITEM(NEW.ID_PESANAN);
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `ON_UPDATE_ITEM_PESANAN` AFTER UPDATE ON `item_pesanan` FOR EACH ROW begin
    CALL RECALCULATE_TOTAL_ITEM(NEW.ID_PESANAN);
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `ON_DELETE_ITEM_PESANAN` AFTER DELETE ON `item_pesanan` FOR EACH ROW begin
    CALL RECALCULATE_TOTAL_ITEM(OLD.ID_PESANAN);
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table "kupon"
--

DROP TABLE IF EXISTS "kupon";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "kupon" (
  "ID_KUPON" int(11) NOT NULL,
  "ID_PESANAN" int(11) DEFAULT NULL,
  "ID_CUSTOMER" int(11) DEFAULT NULL,
  "POTONGAN" int(11) NOT NULL,
  PRIMARY KEY ("ID_KUPON"),
  KEY "FK_KUPON_DIPAKAI_P_PESANAN" ("ID_PESANAN"),
  KEY "FK_KUPON_MEMILIKI__CUSTOMER" ("ID_CUSTOMER"),
  CONSTRAINT "FK_KUPON_DIPAKAI_P_PESANAN" FOREIGN KEY ("ID_PESANAN") REFERENCES "pesanan" ("ID_PESANAN"),
  CONSTRAINT "FK_KUPON_MEMILIKI__CUSTOMER" FOREIGN KEY ("ID_CUSTOMER") REFERENCES "customer" ("ID_CUSTOMER")
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table "kupon"
--

LOCK TABLES "kupon" WRITE;
/*!40000 ALTER TABLE "kupon" DISABLE KEYS */;
/*!40000 ALTER TABLE "kupon" ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view "monthly_pemasukan_stats"
--

DROP TABLE IF EXISTS "monthly_pemasukan_stats";
/*!50001 DROP VIEW IF EXISTS "monthly_pemasukan_stats"*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE "monthly_pemasukan_stats" (
  "TAHUN" tinyint NOT NULL,
  "BULAN" tinyint NOT NULL,
  "JUMLAH" tinyint NOT NULL,
  "TOTAL" tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view "monthly_pengeluaran_stats"
--

DROP TABLE IF EXISTS "monthly_pengeluaran_stats";
/*!50001 DROP VIEW IF EXISTS "monthly_pengeluaran_stats"*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE "monthly_pengeluaran_stats" (
  "TAHUN" tinyint NOT NULL,
  "BULAN" tinyint NOT NULL,
  "JUMLAH" tinyint NOT NULL,
  "TOTAL" tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table "paket"
--

DROP TABLE IF EXISTS "paket";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "paket" (
  "ID_PAKET" int(11) NOT NULL,
  "PAKET" varchar(16) NOT NULL,
  PRIMARY KEY ("ID_PAKET"),
  UNIQUE KEY "UNIQUE_PAKET" ("PAKET")
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table "paket"
--

LOCK TABLES "paket" WRITE;
/*!40000 ALTER TABLE "paket" DISABLE KEYS */;
INSERT INTO "paket" VALUES (2,'3X/EX'),(3,'9S'),(1,'?'),(4,'Cuci Basah'),(5,'Cuci Kering'),(6,'Cuci Setrika'),(7,'Dry Clean'),(8,'LTA'),(9,'Setrika'),(10,'SL'),(11,'Toe n Tas');
/*!40000 ALTER TABLE "paket" ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table "pengeluaran"
--

DROP TABLE IF EXISTS "pengeluaran";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "pengeluaran" (
  "ID_PENGELUARAN" int(11) NOT NULL,
  "TANGGAL_PENGELUARAN" date NOT NULL,
  "ITEM_PENGELUARAN" varchar(50) NOT NULL,
  "JUMLAH_PENGELUARAN" int(11) NOT NULL,
  PRIMARY KEY ("ID_PENGELUARAN")
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table "pengeluaran"
--

LOCK TABLES "pengeluaran" WRITE;
/*!40000 ALTER TABLE "pengeluaran" DISABLE KEYS */;
INSERT INTO "pengeluaran" VALUES (1,'2019-10-01','Elpiji? + aqua',37000),(2,'2019-10-01','Dry clean',77000),(3,'2019-10-02','Proklin',20000),(4,'2019-10-02','Iuran RT',40000),(5,'2019-10-03','Dry Clean',70000),(6,'2019-10-04','Elpiji',18000),(7,'2019-10-05','Sepatu',160000),(8,'2019-10-06','Proklin + Sunlight',19500),(9,'2019-10-08','Parfum + Sabun',140000),(10,'2019-10-08','Elpiji?',18000),(11,'2019-10-08','Dry Clean',40000),(12,'2019-10-09','Gaji Mbak Nis',1120000),(13,'2019-10-09','Pro/Sukeni?',48000),(14,'2019-10-10','Bayar Tas',45000),(15,'2019-10-10','Dry clean',130000),(16,'2019-10-11','Sepatu',400000),(17,'2019-10-12','Beli token',102500),(18,'2019-10-12','Beli sabun',142000),(19,'2019-10-13','Elpiji/galon',37000),(20,'2019-10-14','Proklin + Sunlight',38000),(21,'2019-10-15','Plastik',51000),(22,'2019-10-17','5 Pak Kemeja? Keresek?',75000),(23,'2019-10-17','Dry clean',44000),(24,'2019-10-17','Elpiji',18000),(25,'2019-10-18','B. TS',100000),(26,'2019-10-21','Dry clean',57000),(27,'2019-10-21','Proklin + Sunlight',28000),(28,'2019-10-22','Elpiji',18000),(29,'2019-10-22','Sabun',77000),(30,'2019-10-24','Byr Mesin?',417000),(31,'2019-10-24','Byr Sepatu',64000),(32,'2019-10-25','2 Proclin',30000),(33,'2019-10-25','Dry Clean',60000),(34,'2019-10-25','Elpiji',17500),(35,'2019-10-25','Isolasi',5500),(36,'2019-10-26','Sabun',60000),(37,'2019-10-28','Dry clean',28000),(38,'2019-10-29','Plastik 2 pak',47000),(39,'2019-10-29','Aqua & Elpiji',37000),(40,'2019-11-01','Dry clean',115000),(41,'2019-11-02','Elpiji',18000),(42,'2019-11-02','Isolasi',11000),(43,'2019-11-02','Kresek?',75000),(44,'2019-11-03','Proklin + Sunlight',25000);
/*!40000 ALTER TABLE "pengeluaran" ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `pengeluaran_default_date` BEFORE INSERT ON `pengeluaran` FOR EACH ROW 
if ( isnull(new.TANGGAL_PENGELUARAN) ) then
 set new.TANGGAL_PENGELUARAN=curdate();
end if */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table "pesanan"
--

DROP TABLE IF EXISTS "pesanan";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "pesanan" (
  "ID_PESANAN" int(11) NOT NULL,
  "ID_CUSTOMER" int(11) NOT NULL,
  "NOTA" int(11) DEFAULT NULL,
  "TANGGAL_PESANAN" date DEFAULT NULL,
  "TANGGAL_LUNAS" date DEFAULT NULL,
  "TANGGAL_AMBIL" date DEFAULT NULL,
  "SUBTOTAL" int(11) NOT NULL DEFAULT '0',
  "TOTAL" int(11) NOT NULL DEFAULT '0',
  "KETERANGAN" varchar(255) DEFAULT NULL,
  PRIMARY KEY ("ID_PESANAN"),
  KEY "FK_PESANAN_MEMILIKI__CUSTOMER" ("ID_CUSTOMER"),
  CONSTRAINT "FK_PESANAN_MEMILIKI__CUSTOMER" FOREIGN KEY ("ID_CUSTOMER") REFERENCES "customer" ("ID_CUSTOMER")
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table "pesanan"
--

LOCK TABLES "pesanan" WRITE;
/*!40000 ALTER TABLE "pesanan" DISABLE KEYS */;
INSERT INTO "pesanan" VALUES (1,79,NULL,'2019-10-01','2019-10-04','2019-10-04',0,0,''),(2,90,NULL,'2019-10-01','2019-10-14','2019-10-14',0,0,''),(3,4,NULL,'2019-10-01','2019-10-10','2019-10-10',0,0,''),(4,171,NULL,'2019-10-01','2019-10-16','2019-10-16',0,0,''),(5,22,NULL,'2019-10-01','2019-10-05','2019-10-05',0,0,''),(6,172,NULL,'2019-10-02','2019-11-02','2019-11-02',5000,5000,''),(7,188,NULL,'2019-10-02','2019-10-29','2019-10-29',20000,20000,''),(8,72,NULL,'2019-10-02','2019-10-05','2019-10-05',45000,45000,''),(9,139,NULL,'2019-10-02','2019-10-16','2019-10-16',54000,54000,''),(10,84,NULL,'2019-10-02','2019-10-20','2019-10-20',50000,50000,''),(11,74,NULL,'2019-10-02','2019-10-05','2019-10-05',12000,12000,''),(12,160,NULL,'2019-10-03','2019-10-06','2019-10-06',15000,15000,''),(13,92,NULL,'2019-10-03','2019-11-04','2019-11-04',0,0,''),(14,102,NULL,'2019-10-03','2019-10-07','2019-10-07',30000,30000,''),(15,132,NULL,'2019-10-03','2019-10-03','2019-10-06',40000,40000,''),(16,93,NULL,'2019-10-04','2019-10-04','2019-10-07',40000,40000,''),(17,128,NULL,'2019-10-04','2019-10-07','2019-10-07',28000,28000,''),(18,152,NULL,'2019-10-04','2019-10-07','2019-10-07',10000,10000,''),(19,101,NULL,'2019-10-04','2019-10-07','2019-10-07',44000,44000,''),(20,162,NULL,'2019-10-04','2019-10-07','2019-10-07',0,0,''),(21,93,NULL,'2019-10-04','2019-10-07','2019-10-07',22000,22000,''),(22,33,NULL,'2019-10-04','2019-10-07','2019-10-07',47500,47500,''),(23,22,NULL,'2019-10-05','2019-10-17','2019-10-17',25500,25500,''),(24,51,NULL,'2019-10-05','2019-10-06','2019-10-06',10000,10000,''),(25,62,NULL,'2019-10-05','2019-10-08','2019-10-08',15000,15000,''),(26,64,NULL,'2019-10-05','2019-10-08','2019-10-08',40000,40000,''),(27,130,NULL,'2019-10-05','2019-10-10','2019-10-10',60000,60000,''),(28,110,NULL,'2019-10-05','2019-10-17','2019-10-17',55000,55000,''),(29,77,NULL,'2019-10-05','2019-10-06','2019-10-06',25000,25000,''),(30,61,NULL,'2019-10-06','2019-10-09','2019-10-09',25000,25000,'Diantar'),(31,158,NULL,'2019-10-06','2019-10-09','2019-10-09',34000,34000,''),(32,51,NULL,'2019-10-06','2019-10-09','2019-10-09',10000,10000,''),(33,77,NULL,'2019-10-06','2019-10-07','2019-10-07',0,0,''),(34,117,NULL,'2019-10-06','2019-10-01','2019-10-01',20000,20000,''),(35,105,NULL,'2019-10-06','2019-10-09','2019-10-09',40000,40000,''),(36,70,NULL,'2019-10-06','2019-10-09','2019-10-09',26000,26000,''),(37,151,NULL,'2019-10-06','2019-10-09','2019-10-09',24000,24000,''),(38,36,NULL,'2019-10-06','2019-10-13','2019-10-13',10000,10000,''),(39,113,NULL,'2019-10-06','2019-10-11','2019-10-11',24000,24000,''),(40,129,NULL,'2019-10-06','2019-10-09','2019-10-09',30000,30000,''),(41,121,NULL,'2019-10-07','2019-10-27','2019-10-27',10000,10000,''),(42,77,NULL,'2019-10-07','2019-10-07','2019-10-10',26000,26000,''),(43,101,NULL,'2019-10-07','2019-10-12','2019-10-12',26000,26000,''),(44,187,NULL,'2019-10-07','2019-10-10','2019-10-10',30000,30000,''),(45,108,NULL,'2019-10-07','2019-10-12','2019-10-12',60000,60000,''),(46,128,NULL,'2019-10-07','2019-10-18','2019-10-18',0,0,''),(47,156,NULL,'2019-10-07','2019-10-18','2019-10-18',20000,20000,''),(48,174,NULL,'2019-10-07','2019-10-10','2019-10-10',0,0,''),(49,124,NULL,'2019-10-07','2019-10-10','2019-10-10',35000,35000,''),(50,16,NULL,'2019-10-07','2019-10-27','2019-10-27',100000,100000,''),(51,180,NULL,'2019-10-08','2019-10-11','2019-10-11',0,0,''),(52,69,NULL,'2019-10-08','2019-10-11','2019-10-11',32000,32000,''),(53,54,NULL,'2019-10-08','2019-10-11','2019-10-11',75000,75000,''),(54,14,NULL,'2019-10-08','2019-10-11','2019-10-11',24000,24000,''),(55,170,NULL,'2019-10-08','2019-10-11','2019-10-11',0,0,''),(56,50,NULL,'2019-10-09','2019-10-09','2019-10-12',85000,85000,''),(57,194,NULL,'2019-10-09','2019-10-12','2019-10-12',14000,14000,''),(58,60,NULL,'2019-10-10','2019-10-25','2019-10-25',0,0,''),(59,147,NULL,'2019-10-10','2019-10-13','2019-10-13',30000,30000,''),(60,93,NULL,'2019-10-10','2019-10-12','2019-10-12',18000,18000,''),(61,86,NULL,'2019-10-10','2019-10-16','2019-10-16',40000,40000,''),(62,96,NULL,'2019-10-10','2019-10-29','2019-10-29',0,0,''),(63,130,NULL,'2019-10-10','2019-10-12','2019-10-12',40000,40000,''),(64,6,NULL,'2019-10-10','2019-10-13','2019-10-13',0,0,''),(65,31,NULL,'2019-10-10','2019-10-18','2019-10-18',10000,10000,''),(66,187,NULL,'2019-10-10','2019-10-19','2019-10-19',25000,25000,''),(67,4,NULL,'2019-10-10','2019-10-10','2019-10-13',65000,65000,''),(68,163,NULL,'2019-10-11','2019-10-13','2019-10-13',15000,15000,''),(69,192,NULL,'2019-10-11','2019-10-14','2019-10-14',78000,78000,''),(70,191,NULL,'2019-10-11','2019-10-14','2019-10-14',0,0,''),(71,12,NULL,'2019-10-11','2019-10-14','2019-10-14',28000,28000,''),(72,113,NULL,'2019-10-11','2019-10-12','2019-10-12',20000,20000,''),(73,73,NULL,'2019-10-12','2019-10-26','2019-10-26',28000,28000,''),(74,82,NULL,'2019-10-12','2019-10-12','2019-10-15',28500,28500,''),(75,47,NULL,'2019-10-12','2019-10-17','2019-10-17',20000,20000,''),(76,182,NULL,'2019-10-12','2019-10-15','2019-10-15',25000,25000,''),(77,49,NULL,'2019-10-12','2019-10-15','2019-10-15',24000,24000,''),(78,4,NULL,'2019-10-12','2019-10-17','2019-10-17',0,0,''),(79,95,NULL,'2019-10-12','2019-10-15','2019-10-15',35000,35000,''),(80,81,NULL,'2019-10-12','2019-10-16','2019-10-16',32500,32500,''),(81,141,NULL,'2019-10-12','2019-10-30','2019-10-30',40000,40000,''),(82,93,NULL,'2019-10-12','2019-10-04','2019-10-04',40000,40000,''),(83,69,NULL,'2019-10-12','2019-10-17','2019-10-17',12000,12000,''),(84,132,NULL,'2019-10-13','2019-10-22','2019-10-22',50000,50000,''),(85,181,NULL,'2019-10-13','2019-10-20','2019-10-20',20000,20000,''),(86,117,NULL,'2019-10-13','2019-10-01','2019-10-01',20000,20000,''),(87,67,NULL,'2019-10-13','2019-10-13','2019-10-16',25000,25000,''),(88,146,NULL,'2019-10-13','2019-10-16','2019-10-16',24000,24000,''),(89,37,NULL,'2019-10-13','2019-10-16','2019-10-16',10000,10000,''),(90,98,NULL,'2019-10-14','2019-10-17','2019-10-17',30000,30000,''),(91,70,NULL,'2019-10-14','2019-10-24','2019-10-24',40000,40000,''),(92,38,NULL,'2019-10-14','2019-10-17','2019-10-17',20000,20000,''),(93,90,NULL,'2019-10-14','2019-10-27','2019-10-27',0,0,''),(94,77,NULL,'2019-10-14','2019-10-21','2019-10-21',25000,25000,''),(95,101,NULL,'2019-10-14','2019-10-16','2019-10-16',22000,22000,''),(96,29,NULL,'2019-10-01','2019-10-04','2019-10-04',30000,30000,''),(97,116,NULL,'2019-10-16','2019-10-16','2019-10-19',30000,30000,''),(98,35,NULL,'2019-10-16','2019-10-19','2019-10-19',50000,50000,''),(99,101,NULL,'2019-10-16','2019-10-21','2019-10-21',25000,25000,''),(100,86,NULL,'2019-10-16','2019-10-23','2019-10-23',45000,45000,''),(101,139,NULL,'2019-10-16','2019-10-29','2019-10-29',25000,25000,''),(102,116,NULL,'2019-10-16','2019-10-19','2019-10-19',15000,15000,''),(103,87,NULL,'2019-10-16','2019-10-29','2019-10-29',35000,35000,''),(104,97,NULL,'2019-10-16','2019-10-19','2019-10-19',24000,24000,''),(105,130,NULL,'2019-10-16','2019-10-28','2019-10-28',32500,32500,''),(106,126,NULL,'2019-10-16','2019-10-23','2019-10-23',10000,10000,''),(107,171,NULL,'2019-10-16','2019-10-19','2019-10-19',0,0,''),(108,22,NULL,'2019-10-17','2019-10-24','2019-10-24',27000,27000,''),(109,195,NULL,'2019-10-17','2019-10-22','2019-10-22',24000,24000,''),(110,109,NULL,'2019-10-17','2019-10-23','2019-10-23',25000,25000,''),(111,4,NULL,'2019-10-17','2019-10-27','2019-10-27',35000,35000,''),(112,69,NULL,'2019-10-17','2019-10-20','2019-10-20',37000,37000,''),(113,186,NULL,'2019-10-17','2019-10-20','2019-10-20',22000,22000,''),(114,110,NULL,'2019-10-17','2019-10-20','2019-10-20',10000,10000,''),(115,47,NULL,'2019-10-17','2019-10-20','2019-10-20',0,0,''),(116,128,NULL,'2019-10-18','2019-10-21','2019-10-21',18000,18000,''),(117,134,NULL,'2019-10-18','2019-10-21','2019-10-21',28000,28000,''),(118,159,NULL,'2019-10-18','2019-10-21','2019-10-21',20000,20000,''),(119,93,NULL,'2019-10-18','2019-10-07','2019-10-07',22000,22000,''),(120,31,NULL,'2019-10-18','2019-10-27','2019-10-27',50000,50000,''),(121,164,NULL,'2019-10-18','2019-10-21','2019-10-21',48000,48000,''),(122,190,NULL,'2019-10-19','2019-10-03','2019-10-03',25000,25000,''),(123,187,NULL,'2019-10-19','2019-11-01','2019-11-01',12500,12500,''),(124,165,NULL,'2019-10-19','2019-10-21','2019-10-21',35000,35000,''),(125,167,NULL,'2019-10-19','2019-10-22','2019-10-22',70000,70000,''),(126,8,NULL,'2019-10-19','2019-10-19','2019-10-22',36000,36000,''),(127,113,NULL,'2019-10-19','2019-10-22','2019-10-22',24000,24000,''),(128,117,NULL,'2019-10-20','2019-10-01','2019-10-01',20000,20000,''),(129,181,NULL,'2019-10-20','2019-11-03','2019-11-03',30000,30000,''),(130,131,NULL,'2019-10-20','2019-10-23','2019-10-23',30000,30000,''),(131,17,NULL,'2019-10-20','2019-10-23','2019-10-23',152000,152000,''),(132,69,NULL,'2019-10-20','2019-10-20','2019-10-23',40000,40000,''),(133,112,NULL,'2019-10-21','2019-10-24','2019-10-24',32000,32000,''),(134,101,NULL,'2019-10-21','2019-10-22','2019-10-22',28000,28000,''),(135,193,NULL,'2019-10-21','2019-10-24','2019-10-24',45000,45000,''),(136,165,NULL,'2019-10-21','2019-11-01','2019-11-01',50000,50000,''),(137,117,NULL,'2019-10-21','2019-11-03','2019-11-03',0,0,''),(138,100,NULL,'2019-10-21','2019-10-24','2019-10-24',40000,40000,''),(139,128,NULL,'2019-10-21','2019-10-24','2019-10-24',25000,25000,''),(140,77,NULL,'2019-10-21','2019-10-25','2019-10-25',0,0,''),(141,40,NULL,'2019-10-22','2019-10-22','2019-10-25',25000,25000,''),(142,57,NULL,'2019-10-22','2019-10-25','2019-10-25',25000,25000,''),(143,41,NULL,'2019-10-22','2019-10-25','2019-10-25',27500,27500,''),(144,86,NULL,'2019-10-23','2019-10-29','2019-10-29',40000,40000,''),(145,84,NULL,'2019-10-23','2019-10-25','2019-10-25',30000,30000,''),(146,22,NULL,'2019-10-24','2019-10-27','2019-10-27',20000,20000,'2?'),(147,70,NULL,'2019-10-24','2019-10-28','2019-10-28',44000,44000,''),(148,60,NULL,'2019-10-25','2019-10-28','2019-10-28',0,0,''),(149,123,NULL,'2019-10-25','2019-10-28','2019-10-28',15000,15000,''),(150,77,NULL,'2019-10-25','2019-10-25','2019-10-28',15000,15000,''),(151,101,NULL,'2019-10-25','2019-10-27','2019-10-27',32000,32000,''),(152,186,NULL,'2019-10-25','2019-10-28','2019-10-28',15000,15000,''),(153,56,NULL,'2019-10-25','2019-10-28','2019-10-28',45000,45000,''),(154,104,NULL,'2019-10-25','2019-10-28','2019-10-28',20000,20000,''),(155,145,NULL,'2019-10-25','2019-10-27','2019-10-27',60000,60000,''),(156,177,NULL,'2019-10-25','2019-10-28','2019-10-28',24000,24000,''),(157,69,NULL,'2019-10-25','2019-11-01','2019-11-01',35000,35000,''),(158,77,NULL,'2019-10-25','2019-10-27','2019-10-27',32000,32000,''),(159,132,NULL,'2019-10-25','2019-11-01','2019-11-01',30000,30000,''),(160,73,NULL,'2019-10-26','2019-10-13','2019-10-13',20000,20000,''),(161,99,NULL,'2019-10-26','2019-10-29','2019-10-29',40000,40000,''),(162,88,NULL,'2019-10-26','2019-10-29','2019-10-29',0,0,''),(163,144,NULL,'2019-10-26','2019-11-03','2019-11-03',42500,42500,''),(164,31,NULL,'2019-10-26','2019-10-27','2019-10-27',50000,50000,''),(165,164,NULL,'2019-10-26','2019-10-28','2019-10-28',32000,32000,''),(166,184,NULL,'2019-10-26','2019-11-01','2019-11-01',40000,40000,''),(167,155,NULL,'2019-10-26','2019-10-26','2019-10-29',60000,60000,''),(168,4,NULL,'2019-10-27','2019-10-30','2019-10-30',0,0,''),(169,39,NULL,'2019-10-27','2019-10-30','2019-10-30',40000,40000,''),(170,127,NULL,'2019-10-27','2019-10-29','2019-10-29',60000,60000,''),(171,16,NULL,'2019-10-27','2019-10-30','2019-10-30',0,0,''),(172,121,NULL,'2019-10-27','2019-10-30','2019-10-30',55000,55000,''),(173,58,NULL,'2019-10-27','2019-10-30','2019-10-30',0,0,''),(174,77,NULL,'2019-10-27','2019-11-03','2019-11-03',37000,37000,''),(175,134,NULL,'2019-10-27','2019-10-27','2019-10-30',30000,30000,''),(176,134,NULL,'2019-10-27','2019-10-30','2019-10-30',60000,60000,''),(177,90,NULL,'2019-10-27','2019-10-30','2019-10-30',15000,15000,''),(178,83,NULL,'2019-10-28','2019-10-31','2019-10-31',27500,27500,''),(179,163,NULL,'2019-10-28','2019-10-31','2019-10-31',20000,20000,''),(180,154,NULL,'2019-10-28','2019-10-31','2019-10-31',25000,25000,''),(181,130,NULL,'2019-10-28','2019-10-30','2019-10-30',0,0,''),(182,106,NULL,'2019-10-28','2019-10-31','2019-10-31',20000,20000,''),(183,75,NULL,'2019-10-28','2019-10-31','2019-10-31',34000,34000,''),(184,34,NULL,'2019-10-28','2019-10-31','2019-10-31',40000,40000,''),(185,93,NULL,'2019-10-28','2019-10-31','2019-10-31',52000,52000,''),(186,139,NULL,'2019-10-29','2019-10-08','2019-10-08',20000,20000,''),(187,53,NULL,'2019-10-29','2019-10-16','2019-10-16',20000,20000,''),(188,86,NULL,'2019-10-29','2019-11-01','2019-11-01',45000,45000,''),(189,87,NULL,'2019-10-29','2019-11-01','2019-11-01',0,0,''),(190,96,NULL,'2019-10-29','2019-11-03','2019-11-03',48000,48000,''),(191,188,NULL,'2019-10-29','2019-11-01','2019-11-01',40000,40000,''),(192,70,1,'2019-10-30','2019-11-05','2019-11-05',36000,36000,''),(193,130,2,'2019-10-30','2019-11-02','2019-11-02',30000,30000,''),(194,69,8,'2019-11-01','2019-11-04','2019-11-04',30000,30000,''),(195,187,9,'2019-11-01','2019-11-04','2019-11-04',30000,30000,''),(196,12,10,'2019-11-01','2019-11-05','2019-11-05',28000,28000,''),(197,31,11,'2019-11-01','2019-11-02','2019-11-02',20000,20000,''),(198,177,12,'2019-11-01','2019-11-03','2019-11-03',24000,24000,''),(199,2,13,'2019-11-01','2019-11-04','2019-11-04',28000,28000,''),(200,165,14,'2019-11-01','2019-11-01','2019-11-04',40000,40000,''),(201,132,15,'2019-11-01','2019-11-01','2019-11-04',40000,40000,''),(202,165,16,'2019-11-01','2019-11-04','2019-11-04',50000,50000,''),(203,184,17,'2019-11-01','2019-11-04','2019-11-04',0,0,''),(204,28,18,'2019-11-01','2019-11-01','2019-11-04',25000,25000,''),(205,18,NULL,'2019-11-01','2019-11-02','2019-11-02',0,0,''),(206,27,19,'2019-11-02','2019-11-05','2019-11-05',0,0,''),(207,31,20,'2019-11-02','2019-11-05','2019-11-05',45000,45000,''),(208,73,21,'2019-11-02','2019-10-13','2019-10-13',20000,20000,''),(209,139,22,'2019-11-02','2019-11-05','2019-11-05',25000,25000,''),(210,101,23,'2019-11-02','2019-11-05','2019-11-05',42000,42000,''),(211,18,24,'2019-11-02','2019-11-05','2019-11-05',25000,25000,''),(212,59,25,'2019-11-02','2019-11-02','2019-11-05',24000,24000,''),(213,135,26,'2019-11-02','2019-11-05','2019-11-05',42500,42500,''),(214,157,27,'2019-11-02','2019-11-05','2019-11-05',40000,40000,''),(215,172,28,'2019-11-02','2019-10-03','2019-10-03',25000,25000,''),(216,66,29,'2019-11-02','2019-11-05','2019-11-05',40000,40000,''),(217,111,30,'2019-11-02','2019-11-05','2019-11-05',60000,60000,''),(218,45,31,'2019-11-02','2019-11-05','2019-11-05',65000,65000,''),(219,21,32,'2019-11-02','2019-11-02','2019-11-05',30000,30000,''),(220,115,33,'2019-11-02','2019-11-05','2019-11-05',25000,25000,''),(221,178,34,'2019-11-03','2019-11-06','2019-11-06',20000,20000,''),(222,181,35,'2019-11-03','2019-10-20','2019-10-20',28000,28000,''),(223,77,36,'2019-11-03','2019-11-06','2019-11-06',30000,30000,''),(224,117,37,'2019-11-03','2019-10-01','2019-10-01',20000,20000,''),(225,96,38,'2019-11-03','2019-11-05','2019-11-05',100000,100000,''),(226,144,39,'2019-11-03','2019-11-06','2019-11-06',20000,20000,''),(227,148,NULL,'2019-11-03','2019-11-06','2019-11-06',28000,28000,''),(228,138,40,'2019-11-04','2019-11-07','2019-11-07',30000,30000,''),(229,92,41,'2019-11-04','2019-11-07','2019-11-07',58000,58000,''),(230,42,42,'2019-11-04','2019-11-07','2019-11-07',35000,35000,''),(231,195,43,'2019-11-04','2019-10-22','2019-10-22',24000,24000,''),(232,114,44,'2019-11-04','2019-11-07','2019-11-07',36000,36000,''),(233,161,45,'2019-11-04','2019-11-07','2019-11-07',20000,20000,''),(234,69,46,'2019-11-04','2019-11-07','2019-11-07',57500,57500,''),(235,55,47,'2019-11-04','2019-11-07','2019-11-07',15000,15000,''),(236,13,48,'2019-11-04','2019-11-07','2019-11-07',20000,20000,''),(237,82,49,'2019-11-04','2019-11-04','2019-11-07',30000,30000,''),(238,126,50,'2019-11-04','2019-11-07','2019-11-07',25000,25000,''),(239,70,51,'2019-11-05','2019-11-08','2019-11-08',30000,30000,''),(240,96,52,'2019-11-05','2019-11-08','2019-11-08',40000,40000,'');
/*!40000 ALTER TABLE "pesanan" ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `pesanan_default_date` BEFORE INSERT ON `pesanan` FOR EACH ROW 
if ( isnull(new.TANGGAL_PESANAN) ) then
 set new.TANGGAL_PESANAN=curdate();
end if */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Temporary table structure for view "pesanan_customer"
--

DROP TABLE IF EXISTS "pesanan_customer";
/*!50001 DROP VIEW IF EXISTS "pesanan_customer"*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE "pesanan_customer" (
  "ID_PESANAN" tinyint NOT NULL,
  "ID_CUSTOMER" tinyint NOT NULL,
  "TANGGAL_PESANAN" tinyint NOT NULL,
  "TANGGAL_LUNAS" tinyint NOT NULL,
  "TANGGAL_AMBIL" tinyint NOT NULL,
  "SUBTOTAL" tinyint NOT NULL,
  "TOTAL" tinyint NOT NULL,
  "KETERANGAN" tinyint NOT NULL,
  "NAMA_CUSTOMER" tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table "unit"
--

DROP TABLE IF EXISTS "unit";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "unit" (
  "ID_UNIT" int(11) NOT NULL,
  "UNIT" varchar(16) NOT NULL,
  PRIMARY KEY ("ID_UNIT"),
  UNIQUE KEY "UNIQUE_UNIT" ("UNIT")
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table "unit"
--

LOCK TABLES "unit" WRITE;
/*!40000 ALTER TABLE "unit" DISABLE KEYS */;
INSERT INTO "unit" VALUES (1,'Bed Cover'),(2,'CPR'),(3,'Da'),(4,'Gorden'),(5,'HD'),(6,'Jaket'),(7,'Jas'),(8,'Kambal'),(9,'Karpet'),(10,'Kg'),(11,'Melar'),(12,'RSE'),(13,'Selimut'),(14,'Sepatu'),(15,'Seprai'),(16,'Tas'),(17,'Tikar');
/*!40000 ALTER TABLE "unit" ENABLE KEYS */;
UNLOCK TABLES;

--
-- Final view structure for view "monthly_pemasukan_stats"
--

/*!50001 DROP TABLE IF EXISTS "monthly_pemasukan_stats"*/;
/*!50001 DROP VIEW IF EXISTS "monthly_pemasukan_stats"*/;
/*!50001 CREATE VIEW "monthly_pemasukan_stats" AS (select year("p"."TANGGAL_LUNAS") AS "TAHUN",month("p"."TANGGAL_LUNAS") AS "BULAN",count(0) AS "JUMLAH",sum("p"."TOTAL") AS "TOTAL" from "pesanan" "p" where ("p"."TANGGAL_LUNAS" is not null) group by year("p"."TANGGAL_LUNAS"),month("p"."TANGGAL_LUNAS") order by year("p"."TANGGAL_LUNAS") desc,month("p"."TANGGAL_LUNAS") desc) */;

--
-- Final view structure for view "monthly_pengeluaran_stats"
--

/*!50001 DROP TABLE IF EXISTS "monthly_pengeluaran_stats"*/;
/*!50001 DROP VIEW IF EXISTS "monthly_pengeluaran_stats"*/;
/*!50001 CREATE VIEW "monthly_pengeluaran_stats" AS (select year("pl"."TANGGAL_PENGELUARAN") AS "TAHUN",month("pl"."TANGGAL_PENGELUARAN") AS "BULAN",count(0) AS "JUMLAH",sum("pl"."JUMLAH_PENGELUARAN") AS "TOTAL" from "pengeluaran" "pl" group by year("pl"."TANGGAL_PENGELUARAN"),month("pl"."TANGGAL_PENGELUARAN") order by year("pl"."TANGGAL_PENGELUARAN") desc,month("pl"."TANGGAL_PENGELUARAN") desc) */;

--
-- Final view structure for view "pesanan_customer"
--

/*!50001 DROP TABLE IF EXISTS "pesanan_customer"*/;
/*!50001 DROP VIEW IF EXISTS "pesanan_customer"*/;
/*!50001 CREATE VIEW "pesanan_customer" AS (select "p"."ID_PESANAN" AS "ID_PESANAN","p"."ID_CUSTOMER" AS "ID_CUSTOMER","p"."TANGGAL_PESANAN" AS "TANGGAL_PESANAN","p"."TANGGAL_LUNAS" AS "TANGGAL_LUNAS","p"."TANGGAL_AMBIL" AS "TANGGAL_AMBIL","p"."SUBTOTAL" AS "SUBTOTAL","p"."TOTAL" AS "TOTAL","p"."KETERANGAN" AS "KETERANGAN","c"."NAMA_CUSTOMER" AS "NAMA_CUSTOMER" from ("pesanan" "p" join "customer" "c") where ("p"."ID_CUSTOMER" = "c"."ID_CUSTOMER")) */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-11-14 11:05:53
