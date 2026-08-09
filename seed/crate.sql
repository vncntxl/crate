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
  `cover_url` varchar(255) DEFAULT NULL,
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
INSERT INTO `albums` VALUES (1,'Rumours','Fleetwood Mac',1977,'Rock','Warner Bros.','Fleetwood Mac, Ken Caillat, Richard Dashut',11,40,'Five band members writing through the collapse of their own relationships, and somehow turning it into the most polished pop-rock record of the decade.','assets/covers/1.jpg','#ff6b6b','#ff9f7f','2026-08-09 12:52:23'),(2,'OK Computer','Radiohead',1997,'Rock','Parlophone','Nigel Godrich, Radiohead',12,53,'Guitar music bent into something colder and stranger, full of dread about technology that only reads as more accurate with time.','assets/covers/2.jpg','#4d7dff','#7fb2ff','2026-08-09 12:52:24'),(3,'Random Access Memories','Daft Punk',2013,'Electronic','Columbia','Daft Punk',14,74,'Two robots hire live session players and disco veterans, then build an album about missing the way records used to sound.','assets/covers/3.jpg','#1fbf9f','#5fe0c4','2026-08-09 12:52:24'),(4,'Discovery','Daft Punk',2001,'Electronic','Virgin','Daft Punk',14,61,'Filtered house built out of chopped-up samples and pure nostalgia, and the record that taught a generation what a French touch drop sounds like.','assets/covers/4.jpg','#8f5bff','#b98bff','2026-08-09 12:52:25'),(5,'To Pimp a Butterfly','Kendrick Lamar',2015,'Hip-Hop','Top Dawg / Aftermath / Interscope','Sounwave, Terrace Martin, Flying Lotus and others',17,79,'Free jazz, funk and spoken word pulled into a dense record about fame, survivor guilt and Black identity in America.','assets/covers/5.jpg','#f2b90a','#ffe07f','2026-08-09 12:52:25'),(6,'good kid, m.A.A.d city','Kendrick Lamar',2012,'Hip-Hop','Top Dawg / Aftermath / Interscope','Dr. Dre, Sounwave, Hit-Boy and others',13,68,'A short film in album form: one day in Compton, told out of order, with the skits doing as much narrative work as the verses.','assets/covers/6.jpg','#ff6b6b','#ff9f7f','2026-08-09 12:52:25'),(7,'Kind of Blue','Miles Davis',1959,'Jazz','Columbia','Irving Townsend, Teo Macero',5,45,'Recorded in two sessions with sketches instead of full charts, letting the band improvise around modes rather than chord changes.','assets/covers/7.jpg','#4d7dff','#7fb2ff','2026-08-09 12:52:26'),(8,'A Love Supreme','John Coltrane',1965,'Jazz','Impulse!','Bob Thiele',4,33,'A four-part suite written as a devotional offering, moving from restless searching into something close to peace.','assets/covers/8.jpg','#1fbf9f','#5fe0c4','2026-08-09 12:52:26'),(9,'Blue','Joni Mitchell',1971,'Folk','Reprise','Henry Lewy',10,36,'Ten songs with almost nothing to hide behind, mostly voice against dulcimer, piano or open-tuned guitar.','assets/covers/9.jpg','#8f5bff','#b98bff','2026-08-09 12:52:27'),(10,'Harvest','Neil Young',1972,'Folk','Reprise','Elliot Mazer, Neil Young, Jack Nitzsche, Henry Lewy',10,37,'Country-leaning songs cut between Nashville, a barn in California and a London orchestra session, and the record that made him far bigger than he wanted to be.','assets/covers/10.jpg','#f2b90a','#ffe07f','2026-08-09 12:52:27'),(11,'Melodrama','Lorde',2017,'Indie Pop','Lava / Republic','Jack Antonoff, Lorde',11,41,'One house party stretched across a whole album, running from the high of the first drink to the walk home alone.','assets/covers/11.jpg','#ff6b6b','#ff9f7f','2026-08-09 12:52:28'),(12,'Modern Vampires of the City','Vampire Weekend',2013,'Indie Pop','XL Recordings','Rostam Batmanglij, Ariel Rechtshaid',12,43,'The band drop the bright preppy guitars for pitch-shifted vocals and organ, and spend the album arguing with the idea of getting older.','assets/covers/12.jpg','#4d7dff','#7fb2ff','2026-08-09 12:52:29'),(13,'Thriller','Michael Jackson',1982,'Pop','Epic','Quincy Jones, Michael Jackson',9,42,'Pop, funk, rock and disco welded together with studio precision, and still the yardstick every big commercial record gets measured against.','assets/covers/13.jpg','#1fbf9f','#5fe0c4','2026-08-09 12:52:29'),(14,'1989','Taylor Swift',2014,'Pop','Big Machine','Max Martin, Shellback, Jack Antonoff, Taylor Swift',14,49,'A full move from country into synth-pop, built on 80s drum sounds and hooks aimed squarely at radio.','assets/covers/14.jpg','#8f5bff','#b98bff','2026-08-09 12:52:30');
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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `collection`
--

LOCK TABLES `collection` WRITE;
/*!40000 ALTER TABLE `collection` DISABLE KEYS */;
INSERT INTO `collection` VALUES (5,2,3,'2026-08-09 12:53:33'),(6,2,7,'2026-08-09 12:53:33');
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
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reviews`
--

LOCK TABLES `reviews` WRITE;
/*!40000 ALTER TABLE `reviews` DISABLE KEYS */;
INSERT INTO `reviews` VALUES (8,1,1,5,'Every song earns its place. The fact they made this while falling apart is unbelievable.','2026-08-09 12:53:33'),(9,2,1,4,'Dreams and The Chain are perfect. Loses me slightly in the back half.','2026-08-09 12:53:33'),(10,1,3,5,'Giorgio by Moroder alone is worth it. Sounds enormous on good speakers.','2026-08-09 12:53:33'),(11,2,5,5,'Dense and difficult and worth every replay. Not background music.','2026-08-09 12:53:33'),(12,1,7,5,'Puts me in a completely different mood within about ten seconds.','2026-08-09 12:53:33'),(13,2,11,4,'Captures being young and wrecked at a party better than anything else.','2026-08-09 12:53:33'),(14,1,13,4,'The production still sounds current forty years on.','2026-08-09 12:53:33');
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

-- Dump completed on 2026-08-09 22:55:06
