-- MariaDB dump 10.19  Distrib 10.4.32-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: crate
-- ------------------------------------------------------
-- Server version	10.4.32-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `albums`
--

DROP TABLE IF EXISTS `albums`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `albums` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(150) NOT NULL,
  `artist` varchar(150) NOT NULL,
  `year` int(11) NOT NULL,
  `genre` varchar(50) NOT NULL,
  `label` varchar(150) DEFAULT NULL,
  `producer` varchar(150) DEFAULT NULL,
  `track_count` int(11) DEFAULT 0,
  `duration_min` int(11) DEFAULT 0,
  `description` text DEFAULT NULL,
  `cover_color_1` varchar(20) DEFAULT '#6d5df0',
  `cover_color_2` varchar(20) DEFAULT '#8f7bf5',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `albums`
--

LOCK TABLES `albums` WRITE;
/*!40000 ALTER TABLE `albums` DISABLE KEYS */;
INSERT INTO `albums` VALUES (1,'Midnight Tape','Aria Vale',2024,'Indie Pop','Lunar Records','K. Mori',11,38,'A hazy, late-night record blending dream-pop guitars with warm analog synths.','#ff6b6b','#ff9f7f','2026-07-19 05:32:16'),(2,'Golden Static','The Wash',2023,'Rock','Fuzzbox','D. Reyes',10,41,'Distorted riffs and driving drums with a nostalgic 90s alt-rock edge.','#4d7dff','#7fb2ff','2026-07-19 05:32:16'),(3,'Paper Moons','Cassette',2022,'Electronic','Nightowl','S. Iyer',9,34,'Soft synth textures and gentle beats built for late-night listening.','#1fbf9f','#5fe0c4','2026-07-19 05:32:16'),(4,'Slow Bloom','June Halo',2024,'Pop','Halo Sound','T. Park',12,44,'Bright, hook-driven pop with layered vocal harmonies.','#ffb020','#ffd27a','2026-07-19 05:32:16'),(5,'Concrete Garden','Nova Bloc',2021,'Hip-Hop','Bloc Records','R. James',14,47,'Boom-bap drums with jazzy samples and sharp, reflective verses.','#8f5bff','#b98bff','2026-07-19 05:32:16'),(6,'Wavelength','Echo Parlour',2020,'Jazz','Blue Salt','M. Abara',8,52,'Improvisational jazz trio recordings with a modern production polish.','#00b3b3','#4fe0e0','2026-07-19 05:32:16'),(7,'Static Bloom','Faye West',2023,'Electronic','Nightowl','S. Iyer',10,39,'Ambient electronica with shimmering pads and slow-building drops.','#ff5c8a','#ff9cb8','2026-07-19 05:32:16'),(8,'Field Recordings','The Low Hills',2019,'Folk','Wren House','A. Doyle',13,49,'Acoustic folk stories recorded live with minimal overdubs.','#7a9e5b','#a8c98a','2026-07-19 05:32:16'),(9,'Neon Aisle','Kilo Youth',2024,'Pop','Halo Sound','T. Park',11,36,'Synth-pop with driving basslines and glossy production.','#ff8f1f','#ffbf6b','2026-07-19 05:32:16'),(10,'Broken Radio','Static Choir',2022,'Rock','Fuzzbox','D. Reyes',9,40,'Raw, guitar-forward rock with layered vocal harmonies.','#4a4ae0','#8686f0','2026-07-19 05:32:16'),(11,'Salt Water','Marin',2021,'Indie Pop','Lunar Records','K. Mori',10,37,'Breezy indie pop inspired by coastal landscapes.','#20b6c4','#6fe0ea','2026-07-19 05:32:16'),(12,'Dust & Light','Nova Bloc',2023,'Hip-Hop','Bloc Records','R. James',12,45,'Sample-driven hip-hop exploring memory and place.','#a05bff','#c99bff','2026-07-19 05:32:16');
/*!40000 ALTER TABLE `albums` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `collection`
--

DROP TABLE IF EXISTS `collection`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `collection` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `album_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_save` (`user_id`,`album_id`),
  KEY `album_id` (`album_id`),
  CONSTRAINT `collection_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `collection_ibfk_2` FOREIGN KEY (`album_id`) REFERENCES `albums` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `collection`
--

LOCK TABLES `collection` WRITE;
/*!40000 ALTER TABLE `collection` DISABLE KEYS */;
INSERT INTO `collection` VALUES (1,2,2,'2026-07-19 05:37:17');
/*!40000 ALTER TABLE `collection` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reviews`
--

DROP TABLE IF EXISTS `reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reviews` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `album_id` int(11) NOT NULL,
  `rating` tinyint(4) NOT NULL,
  `review_text` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_user_album` (`user_id`,`album_id`),
  KEY `album_id` (`album_id`),
  CONSTRAINT `reviews_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `reviews_ibfk_2` FOREIGN KEY (`album_id`) REFERENCES `albums` (`id`) ON DELETE CASCADE,
  CONSTRAINT `chk_rating` CHECK (`rating` between 1 and 5)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reviews`
--

LOCK TABLES `reviews` WRITE;
/*!40000 ALTER TABLE `reviews` DISABLE KEYS */;
INSERT INTO `reviews` VALUES (1,1,1,5,'Gorgeous production, track 6 is on repeat.','2026-07-19 05:32:16'),(2,1,2,4,'Great energy, slightly long.','2026-07-19 05:32:16'),(3,1,3,3,'Nice ideas, uneven tracklist.','2026-07-19 05:32:16'),(4,2,2,5,'I LOVE THIS!!','2026-07-19 05:37:26');
/*!40000 ALTER TABLE `reviews` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `password` varchar(255) NOT NULL,
  `is_admin` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Demo User','demo@crate.test','$2b$10$YvM76Pm8clohCc0XCi..yOD4dll0D2KSt90q3jQdwA2dDRnrEbwge',0,'2026-07-19 05:32:16'),(2,'Vincent','vincent@gmail.com','$2y$10$YanyI1Y6ZWzEsQMD.rtyre/Nat1vF42/Amd070YG7UMwnPI3RAbAG',0,'2026-07-19 05:37:14');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'crate'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-08-09 20:34:02
