-- Crate database export
-- Generated 2026-08-10 01:06:35

SET FOREIGN_KEY_CHECKS=0;
SET NAMES utf8mb4;

-- ----------------------------
-- Table: users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `password` varchar(255) NOT NULL,
  `is_admin` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `users` (`id`, `name`, `email`, `password`, `is_admin`, `created_at`) VALUES
('1','Demo User','demo@crate.test','$2b$10$YvM76Pm8clohCc0XCi..yOD4dll0D2KSt90q3jQdwA2dDRnrEbwge','0','2026-07-19 15:32:16'),
('2','Vincent','vincent@gmail.com','$2y$10$YanyI1Y6ZWzEsQMD.rtyre/Nat1vF42/Amd070YG7UMwnPI3RAbAG','0','2026-07-19 15:37:14'),
('8','Admin','admin@crate.test','$2y$10$u74D0tmoOnR/mzxBJvZGUeEjZnHJTAyqnTBm2vuOsyyNDLAv/qJSu','1','2026-08-10 08:28:46');

-- ----------------------------
-- Table: albums
-- ----------------------------
DROP TABLE IF EXISTS `albums`;
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
) ENGINE=InnoDB AUTO_INCREMENT=153 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `albums` (`id`, `title`, `artist`, `year`, `genre`, `label`, `producer`, `track_count`, `duration_min`, `description`, `cover_url`, `cover_color_1`, `cover_color_2`, `created_at`) VALUES
('1','Mingus Ah Um','Charles Mingus','1959','Jazz','Originally Released 1959, 1979, 1993 Sony Music Entertainment Inc.',NULL,'12','73','Charles Mingus released Mingus Ah Um in 1959. 12 tracks across about 73 minutes of jazz.','assets/covers/1.jpg','#ff6b6b','#ff9f7f','2026-08-10 08:25:43'),
('2','Clouds','Joni Mitchell','1969','Rock','Warner Records Inc.',NULL,'10','38','A rock record from Joni Mitchell, originally released in 1969 on Warner Records Inc. 10 tracks, about 38 minutes.','assets/covers/2.jpg','#4d7dff','#7fb2ff','2026-08-10 08:25:43'),
('3','I\'m Your Man','Leonard Cohen','1988','Pop','Sony Music Entertainment',NULL,'8','41','I\'m Your Man is Leonard Cohen\'s pop album from 1988, collecting 8 tracks across about 41 minutes.','assets/covers/3.jpg','#1fbf9f','#5fe0c4','2026-08-10 08:25:44'),
('4','Joni Mitchell (Song to a Seagull)','Joni Mitchell','1968','Pop','WEA International',NULL,'10','38','Out in 1968 on WEA International, Joni Mitchell (Song to a Seagull) gathers 10 tracks across about 38 minutes of pop from Joni Mitchell.','assets/covers/4.jpg','#8f5bff','#b98bff','2026-08-10 08:25:44'),
('5','Exit Planet Dust','The Chemical Brothers','1995','Electronic','Virgin Records Limited',NULL,'11','49','The Chemical Brothers\'s 1995 electronic album. 11 tracks, about 49 minutes.','assets/covers/5.jpg','#f2b90a','#ffe07f','2026-08-10 08:25:45'),
('6','Teen Dream','Beach House','2010','Alternative','Sub Pop Records',NULL,'12','56','Released in 2010, Teen Dream runs to 12 tracks across about 56 minutes of alternative from Beach House.','assets/covers/6.jpg','#ff7ab8','#ffb3d4','2026-08-10 08:25:46'),
('7','Illinois','Sufjan Stevens','2005','Alternative','Asthmatic Kitty Records',NULL,'26','91','Sufjan Stevens released Illinois in 2005. 26 tracks across about 91 minutes of alternative.','assets/covers/7.jpg','#ff6b6b','#ff9f7f','2026-08-10 08:25:46'),
('8','Crack-Up','Fleet Foxes','2017','Alternative','Fleet Foxes under exclusive license to Nonesuch Records Inc.',NULL,'12','55','A alternative record from Fleet Foxes, originally released in 2017 on Fleet Foxes under exclusive license to Nonesuch Records Inc. 12 tracks, about 55 minutes.','assets/covers/8.jpg','#4d7dff','#7fb2ff','2026-08-10 08:25:46'),
('9','The Dark Side of the Moon','Pink Floyd','1973','Rock','The copyright in this sound recording is owned by Pink Floyd Music Ltd., marketed and distributed by Sony Music Entertainment',NULL,'11','43','The Dark Side of the Moon is Pink Floyd\'s rock album from 1973, collecting 11 tracks across about 43 minutes.','assets/covers/9.jpg','#1fbf9f','#5fe0c4','2026-08-10 08:25:47'),
('10','Bridge Over Troubled Water','Simon & Garfunkel','1970','Pop','Originally released 1970. All rights reserved by Columbia Records, a division of Sony Music Entertainment',NULL,'11','37','Out in 1970 on Originally released 1970. All rights reserved by Columbia Records, a division of Sony Music Entertainment, Bridge Over Troubled Water gathers 11 tracks across about 37 minutes of pop from Simon & Garfunkel.','assets/covers/10.jpg','#8f5bff','#b98bff','2026-08-10 08:25:47'),
('11','I AM...SASHA FIERCE','Beyoncé','2008','Pop','SONY BMG MUSIC ENTERTAINMENT',NULL,'12','46','Beyoncé\'s 2008 pop album. 12 tracks, about 46 minutes.','assets/covers/11.jpg','#f2b90a','#ffe07f','2026-08-10 08:25:48'),
('12','The Wall','Pink Floyd','1979','Rock','The copyright in this sound recording is owned by Pink Floyd Music Ltd., marketed and distributed by Sony Music Entertainment',NULL,'27','81','Released in 1979, The Wall runs to 27 tracks across about 81 minutes of rock from Pink Floyd.','assets/covers/12.jpg','#ff7ab8','#ffb3d4','2026-08-10 08:25:48'),
('13','RENAISSANCE','Beyoncé','2022','Pop','Parkwood Entertainment LLC, under exclusive license to Columbia Records, a Division of Sony Music Entertainment',NULL,'16','62','Beyoncé released RENAISSANCE in 2022. 16 tracks across about 62 minutes of pop.','assets/covers/13.jpg','#ff6b6b','#ff9f7f','2026-08-10 08:25:49'),
('14','Illmatic','Nas','1994','Hip-Hop','Columbia Records, a division of Sony Music Entertainment',NULL,'10','40','A hip-hop record from Nas, originally released in 1994 on Columbia Records, a division of Sony Music Entertainment. 10 tracks, about 40 minutes.','assets/covers/14.jpg','#4d7dff','#7fb2ff','2026-08-10 08:25:49'),
('15','Vampire Weekend','Vampire Weekend','2008','Alternative','Vampire Weekend under exclusive license to XL Recordings Ltd',NULL,'11','32','Vampire Weekend is Vampire Weekend\'s alternative album from 2008, collecting 11 tracks across about 32 minutes.','assets/covers/15.jpg','#1fbf9f','#5fe0c4','2026-08-10 08:25:50'),
('16','Led Zeppelin II','Led Zeppelin','1969','Rock','Atlantic Recording Corporation, a Warner Music Group Company. Marketed by Rhino Entertainment Company, a Warner Music Group Company.',NULL,'9','42','Out in 1969 on Atlantic Recording Corporation, a Warner Music Group Company. Marketed by Rhino Entertainment Company, a Warner Music Group Company., Led Zeppelin II gathers 9 tracks across about 42 minutes of rock from Led Zeppelin.','assets/covers/16.jpg','#8f5bff','#b98bff','2026-08-10 08:25:50'),
('17','Come With Us','The Chemical Brothers','2002','Pop','Virgin Records Limited',NULL,'10','55','The Chemical Brothers\'s 2002 pop album. 10 tracks, about 55 minutes.','assets/covers/17.jpg','#f2b90a','#ffe07f','2026-08-10 08:25:51'),
('18','Selected Ambient Works, Vol. II','Aphex Twin','1994','Electronic','Warp Records Limited',NULL,'24','157','Released in 1994, Selected Ambient Works, Vol. II runs to 24 tracks across about 157 minutes of electronic from Aphex Twin.','assets/covers/18.jpg','#ff7ab8','#ffb3d4','2026-08-10 08:25:51'),
('19','Beats, Rhymes & Life','A Tribe Called Quest','1996','Hip-Hop','Zomba Recording LLC',NULL,'15','51','A Tribe Called Quest released Beats, Rhymes & Life in 1996. 15 tracks across about 51 minutes of hip-hop.','assets/covers/19.jpg','#ff6b6b','#ff9f7f','2026-08-10 08:25:52'),
('20','Migration','Bonobo','2017','Electronic','Ninja Tune',NULL,'13','62','A electronic record from Bonobo, originally released in 2017 on Ninja Tune. 13 tracks, about 62 minutes.','assets/covers/20.jpg','#4d7dff','#7fb2ff','2026-08-10 08:25:52'),
('21','Fear of Music','Talking Heads','1979','Rock','Sire Records. Manufactured & Marketed by Rhino Entertainment Group. A Warner Music Group Co.',NULL,'15','57','Fear of Music is Talking Heads\'s rock album from 1979, collecting 15 tracks across about 57 minutes.','assets/covers/21.jpg','#1fbf9f','#5fe0c4','2026-08-10 08:25:53'),
('22','Madonna','Madonna','1983','Pop',', 1983 Warner Records Inc.',NULL,'10','56','Out in 1983 on , 1983 Warner Records Inc., Madonna gathers 10 tracks across about 56 minutes of pop from Madonna.','assets/covers/22.jpg','#8f5bff','#b98bff','2026-08-10 08:25:53'),
('23','Automatic For The People','R.E.M.','1992','Alternative','R.E.M./Athens L.L.C., under exclusive license to Concord Music Group, Inc.',NULL,'12','49','R.E.M.\'s 1992 alternative album. 12 tracks, about 49 minutes.','assets/covers/23.jpg','#f2b90a','#ffe07f','2026-08-10 08:25:54'),
('24','Being There','Wilco','1996','Rock','Nonesuch Records',NULL,'19','77','Released in 1996, Being There runs to 19 tracks across about 77 minutes of rock from Wilco.','assets/covers/24.jpg','#ff7ab8','#ffb3d4','2026-08-10 08:25:54'),
('25','Out of Time','R.E.M.','1991','Alternative','R.E.M./Athens L.L.C., Under exclusive license to Concord Music Group, Inc.',NULL,'11','44','R.E.M. released Out of Time in 1991. 11 tracks across about 44 minutes of alternative.','assets/covers/25.jpg','#ff6b6b','#ff9f7f','2026-08-10 08:25:55'),
('26','Untrue','Burial','2007','Electronic','Hyperdub',NULL,'13','51','A electronic record from Burial, originally released in 2007 on Hyperdub. 13 tracks, about 51 minutes.','assets/covers/26.jpg','#4d7dff','#7fb2ff','2026-08-10 08:25:55'),
('27','Confessions on a Dance Floor','Madonna','2005','Pop','Warner Records Inc.',NULL,'12','56','Confessions on a Dance Floor is Madonna\'s pop album from 2005, collecting 12 tracks across about 56 minutes.','assets/covers/27.jpg','#1fbf9f','#5fe0c4','2026-08-10 08:25:56'),
('28','Five Leaves Left','Nick Drake','1969','Folk','Island Records, a division of Universal Music Operations Limited',NULL,'10','41','Out in 1969 on Island Records, a division of Universal Music Operations Limited, Five Leaves Left gathers 10 tracks across about 41 minutes of folk from Nick Drake.','assets/covers/28.jpg','#8f5bff','#b98bff','2026-08-10 08:25:57'),
('29','Depression Cherry','Beach House','2015','Alternative','Sub Pop Records',NULL,'10','45','Beach House\'s 2015 alternative album. 10 tracks, about 45 minutes.','assets/covers/29.jpg','#f2b90a','#ffe07f','2026-08-10 08:25:57'),
('30','Kind of Blue','Miles Davis','1959','Jazz','Originally recorded 1958. All rights reserved by SONY MUSIC ENTERTAINMENT/This compilation (P) 2008 Columbia Records, a division of Sony Music Enterta',NULL,'22','130','Recorded in two sessions with sketches instead of full charts, letting the band improvise around modes rather than chord changes.','assets/covers/30.jpg','#ff7ab8','#ffb3d4','2026-08-10 08:25:58'),
('31','7','Beach House','2018','Alternative','Sub Pop Records',NULL,'12','47','Beach House released 7 in 2018. 12 tracks across about 47 minutes of alternative.','assets/covers/31.jpg','#ff6b6b','#ff9f7f','2026-08-10 08:25:59'),
('32','Blue','Joni Mitchell','1971','Folk','Warner Records Inc. Marketed By Rhino Entertainment Company, a Warner Music Group Company.',NULL,'10','36','Ten songs with almost nothing to hide behind, mostly voice against dulcimer, piano or open-tuned guitar.','assets/covers/32.jpg','#4d7dff','#7fb2ff','2026-08-10 08:25:59'),
('33','folklore','Taylor Swift','2020','Alternative','Taylor Swift',NULL,'16','64','folklore is Taylor Swift\'s alternative album from 2020, collecting 16 tracks across about 64 minutes.','assets/covers/33.jpg','#1fbf9f','#5fe0c4','2026-08-10 08:26:00'),
('35','4','Beyoncé','2011','Pop',', 2012 Columbia Records, a Division of Sony Music Entertainment',NULL,'14','58','Beyoncé\'s 2011 pop album. 14 tracks, about 58 minutes.','assets/covers/35.jpg','#f2b90a','#ffe07f','2026-08-10 08:26:00'),
('36','Both Directions at Once: The Lost Album','John Coltrane','2018','Jazz','Verve Label Group, a Division of UMG Recordings, Inc.',NULL,'15','89','Released in 2018, Both Directions at Once: The Lost Album runs to 15 tracks across about 89 minutes of jazz from John Coltrane.','assets/covers/36.jpg','#ff7ab8','#ffb3d4','2026-08-10 08:26:01'),
('37','Some Other Time: The Lost Session from the Black Forest','Bill Evans','2016','Jazz','Resonance Records',NULL,'22','93','Bill Evans released Some Other Time: The Lost Session from the Black Forest in 2016. 22 tracks across about 93 minutes of jazz.','assets/covers/37.jpg','#ff6b6b','#ff9f7f','2026-08-10 08:26:02'),
('38','The Endless River','Pink Floyd','2014','Rock','Columbia Records, a Division of Sony Music Entertainment',NULL,'28','65','A rock record from Pink Floyd, originally released in 2014 on Columbia Records, a Division of Sony Music Entertainment. 28 tracks, about 65 minutes.','assets/covers/38.jpg','#4d7dff','#7fb2ff','2026-08-10 08:26:02'),
('39','It Was Written','Nas','1996','Hip-Hop','Columbia Records, a division of Sony Music Entertainment',NULL,'14','59','It Was Written is Nas\'s hip-hop album from 1996, collecting 14 tracks across about 59 minutes.','assets/covers/39.jpg','#1fbf9f','#5fe0c4','2026-08-10 08:26:02'),
('40','Solar Power','Lorde','2021','Alternative','Universal Music New Zealand Limited',NULL,'13','46','Out in 2021 on Universal Music New Zealand Limited, Solar Power gathers 13 tracks across about 46 minutes of alternative from Lorde.','assets/covers/40.jpg','#8f5bff','#b98bff','2026-08-10 08:26:03'),
('41','The Car','Arctic Monkeys','2022','Alternative','Domino Recording Co Ltd',NULL,'10','37','Arctic Monkeys\'s 2022 alternative album. 10 tracks, about 37 minutes.','assets/covers/41.jpg','#f2b90a','#ffe07f','2026-08-10 08:26:04'),
('42','Live Around the World','Queen & Adam Lambert','2020','Rock','Miracle Recordings Ltd. under exclusive license to Hollywood Records, Inc.',NULL,'20','80','Released in 2020, Live Around the World runs to 20 tracks across about 80 minutes of rock from Queen & Adam Lambert.','assets/covers/42.jpg','#ff7ab8','#ffb3d4','2026-08-10 08:26:04'),
('43','Hounds of Love','Kate Bush','1985','Pop','Noble & Brite Ltd',NULL,'12','47','Kate Bush released Hounds of Love in 1985. 12 tracks across about 47 minutes of pop.','assets/covers/43.jpg','#ff6b6b','#ff9f7f','2026-08-10 08:26:05'),
('44','The Low End Theory','A Tribe Called Quest','1991','Hip-Hop','Zomba Recording LLC',NULL,'14','48','A hip-hop record from A Tribe Called Quest, originally released in 1991 on Zomba Recording LLC. 14 tracks, about 48 minutes.','assets/covers/44.jpg','#4d7dff','#7fb2ff','2026-08-10 08:26:06'),
('45','Illadelph Halflife','The Roots','1996','Pop','Geffen Records',NULL,'20','79','Illadelph Halflife is The Roots\'s pop album from 1996, collecting 20 tracks across about 79 minutes.','assets/covers/45.jpg','#1fbf9f','#5fe0c4','2026-08-10 08:26:06'),
('46','Various Positions','Leonard Cohen','1984','Pop','Sony Music Entertainment',NULL,'9','36','Out in 1984 on Sony Music Entertainment, Various Positions gathers 9 tracks across about 36 minutes of pop from Leonard Cohen.','assets/covers/46.jpg','#8f5bff','#b98bff','2026-08-10 08:26:07'),
('47','Sleep Well Beast','The National','2017','Alternative','The National under exclusive licence to 4AD Ltd',NULL,'12','58','The National\'s 2017 alternative album. 12 tracks, about 58 minutes.','assets/covers/47.jpg','#f2b90a','#ffe07f','2026-08-10 08:26:07'),
('48','Number Ones','Michael Jackson','2003','Pop',', 1981, 1982, 1987, 1991, 1995, 2001, 2003 MJJ Productions, Inc.',NULL,'18','79','Released in 2003, Number Ones runs to 18 tracks across about 79 minutes of pop from Michael Jackson.','assets/covers/48.jpg','#ff7ab8','#ffb3d4','2026-08-10 08:26:08'),
('49','Hunky Dory','David Bowie','1971','Rock','Jones/Tintoretto Entertainment Co, LLC under exclusive license to Parlophone Records Ltd, a Warner Music Group Company',NULL,'11','42','David Bowie released Hunky Dory in 1971. 11 tracks across about 42 minutes of rock.','assets/covers/49.jpg','#ff6b6b','#ff9f7f','2026-08-10 08:26:09'),
('50','In Rainbows','Radiohead','2007','Alternative','LLLP LLP under exclusive license to XL Recordings Ltd',NULL,'10','43','A alternative record from Radiohead, originally released in 2007 on LLLP LLP under exclusive license to XL Recordings Ltd. 10 tracks, about 43 minutes.','assets/covers/50.jpg','#4d7dff','#7fb2ff','2026-08-10 08:26:10'),
('51','ATLiens','Outkast','1996','Hip-Hop','Arista Records LLC',NULL,'15','58','ATLiens is Outkast\'s hip-hop album from 1996, collecting 15 tracks across about 58 minutes.','assets/covers/51.jpg','#1fbf9f','#5fe0c4','2026-08-10 08:26:10');
INSERT INTO `albums` (`id`, `title`, `artist`, `year`, `genre`, `label`, `producer`, `track_count`, `duration_min`, `description`, `cover_url`, `cover_color_1`, `cover_color_2`, `created_at`) VALUES
('52','Pure Heroine','Lorde','2013','Alternative','Universal Music NZ Ltd.',NULL,'10','37','Out in 2013 on Universal Music NZ Ltd., Pure Heroine gathers 10 tracks across about 37 minutes of alternative from Lorde.','assets/covers/52.jpg','#8f5bff','#b98bff','2026-08-10 08:26:11'),
('53','Document','R.E.M.','1987','Alternative','Capitol Records, LLC',NULL,'11','40','R.E.M.\'s 1987 alternative album. 11 tracks, about 40 minutes.','assets/covers/53.jpg','#f2b90a','#ffe07f','2026-08-10 08:26:11'),
('54','Bloom','Beach House','2012','Alternative','Sub Pop Records',NULL,'10','61','Released in 2012, Bloom runs to 10 tracks across about 61 minutes of alternative from Beach House.','assets/covers/54.jpg','#ff7ab8','#ffb3d4','2026-08-10 08:26:12'),
('55','Blonde On Blonde','Bob Dylan','1966','Rock','Originally Released 1966 Sony Music Entertainment Inc.',NULL,'14','73','Bob Dylan released Blonde On Blonde in 1966. 14 tracks across about 73 minutes of rock.','assets/covers/55.jpg','#ff6b6b','#ff9f7f','2026-08-10 08:26:12'),
('56','Meow the Jewels','Run The Jewels','2015','Hip-Hop','Productomart Inc., under exclusive license to Mass Appeal',NULL,'12','42','A hip-hop record from Run The Jewels, originally released in 2015 on Productomart Inc., under exclusive license to Mass Appeal. 12 tracks, about 42 minutes.','assets/covers/56.jpg','#4d7dff','#7fb2ff','2026-08-10 08:26:12'),
('57','Body Talk','Robyn','2010','Electronic','Konichiwa Records',NULL,'17','65','Body Talk is Robyn\'s electronic album from 2010, collecting 17 tracks across about 65 minutes.','assets/covers/57.jpg','#1fbf9f','#5fe0c4','2026-08-10 08:26:13'),
('58','Hot Rocks 1964-1971','The Rolling Stones','1971','Rock','ABKCO Music & Records, Inc.',NULL,'22','86','Out in 1971 on ABKCO Music & Records, Inc., Hot Rocks 1964-1971 gathers 22 tracks across about 86 minutes of rock from The Rolling Stones.','assets/covers/58.jpg','#8f5bff','#b98bff','2026-08-10 08:26:13'),
('59','Tijuana Moods','Charles Mingus','1962','Jazz','Originally Recorded 1957 & Released 1962, 2001. All rights reserved by BMG Music, (P) 2007 BMG Music',NULL,'6','47','Charles Mingus\'s 1962 jazz album. 6 tracks, about 47 minutes.','assets/covers/59.jpg','#f2b90a','#ffe07f','2026-08-10 08:26:14'),
('60','AM','Arctic Monkeys','2013','Alternative','Domino Recording Co Ltd',NULL,'12','42','Released in 2013, AM runs to 12 tracks across about 42 minutes of alternative from Arctic Monkeys.','assets/covers/60.jpg','#ff7ab8','#ffb3d4','2026-08-10 08:26:15'),
('61','Nevermind','Nirvana','1991','Rock','Geffen Records',NULL,'13','49','Nirvana released Nevermind in 1991. 13 tracks across about 49 minutes of rock.','assets/covers/61.jpg','#ff6b6b','#ff9f7f','2026-08-10 08:26:16'),
('62','Black Sands','Bonobo','2010','Electronic','Ninja Tune',NULL,'12','55','A electronic record from Bonobo, originally released in 2010 on Ninja Tune. 12 tracks, about 55 minutes.','assets/covers/62.jpg','#4d7dff','#7fb2ff','2026-08-10 08:26:16'),
('63','Gish','The Smashing Pumpkins','1991','Rock','A Virgin Records Release; ℗ 2011 Capitol Records, LLC',NULL,'11','46','Gish is The Smashing Pumpkins\'s rock album from 1991, collecting 11 tracks across about 46 minutes.','assets/covers/63.jpg','#1fbf9f','#5fe0c4','2026-08-10 08:26:17'),
('64','Burial','Burial','2006','Electronic','Hyperdub',NULL,'13','51','Out in 2006 on Hyperdub, Burial gathers 13 tracks across about 51 minutes of electronic from Burial.','assets/covers/64.jpg','#8f5bff','#b98bff','2026-08-10 08:26:17'),
('65','Fleetwood Mac','Fleetwood Mac','1975','Rock','Warner Records Inc. Marketed by Rhino Entertainment Company, A Warner Music Group Company.',NULL,'11','43','Fleetwood Mac\'s 1975 rock album. 11 tracks, about 43 minutes.','assets/covers/65.jpg','#f2b90a','#ffe07f','2026-08-10 08:26:18'),
('66','Off the Wall','Michael Jackson','1979','Pop','MJJ Productions Inc.',NULL,'10','42','Released in 1979, Off the Wall runs to 10 tracks across about 42 minutes of pop from Michael Jackson.','assets/covers/66.jpg','#ff7ab8','#ffb3d4','2026-08-10 08:26:19'),
('67','The Sensual World','Kate Bush','1989','Pop','Noble & Brite Ltd',NULL,'10','42','Kate Bush released The Sensual World in 1989. 10 tracks across about 42 minutes of pop.','assets/covers/67.jpg','#ff6b6b','#ff9f7f','2026-08-10 08:26:19'),
('68','Remain In Light','Talking Heads','1980','Alternative','Sire Records. Manufactured & Marketed by Rhino Entertainment Group. A Warner Music Group Co.',NULL,'12','59','A alternative record from Talking Heads, originally released in 1980 on Sire Records. Manufactured & Marketed by Rhino Entertainment Group. A Warner Music Group Co. 12 tracks, about 59 minutes.','assets/covers/68.jpg','#4d7dff','#7fb2ff','2026-08-10 08:26:20'),
('69','Wake Up!','John Legend & The Roots','2010','Pop','Getting Out Our Dreams and Sony Music Entertainment',NULL,'12','63','Wake Up! is John Legend & The Roots\'s pop album from 2010, collecting 12 tracks across about 63 minutes.','assets/covers/69.jpg','#1fbf9f','#5fe0c4','2026-08-10 08:26:20'),
('70','XSCAPE','Michael Jackson','2014','Pop','MJJ Productions, Inc.',NULL,'19','73','Out in 2014 on MJJ Productions, Inc., XSCAPE gathers 19 tracks across about 73 minutes of pop from Michael Jackson.','assets/covers/70.jpg','#8f5bff','#b98bff','2026-08-10 08:26:21'),
('71','Ten New Songs','Leonard Cohen','2001','Pop','Sony Music Entertainment',NULL,'10','53','Leonard Cohen\'s 2001 pop album. 10 tracks, about 53 minutes.','assets/covers/71.jpg','#f2b90a','#ffe07f','2026-08-10 08:26:21'),
('72','Ray of Light','Madonna','1998','Pop','Warner Records Inc.',NULL,'13','67','Released in 1998, Ray of Light runs to 13 tracks across about 67 minutes of pop from Madonna.','assets/covers/72.jpg','#ff7ab8','#ffb3d4','2026-08-10 08:26:22'),
('73','BEYONCÉ','Beyoncé','2013','Pop','Columbia Records, a Division of Sony Music Entertainment',NULL,'33','142','Beyoncé released BEYONCÉ in 2013. 33 tracks across about 142 minutes of pop.','assets/covers/73.jpg','#ff6b6b','#ff9f7f','2026-08-10 08:26:23'),
('74','Syro','Aphex Twin','2014','Electronic','Warp Records Limited',NULL,'13','65','A electronic record from Aphex Twin, originally released in 2014 on Warp Records Limited. 13 tracks, about 65 minutes.','assets/covers/74.jpg','#4d7dff','#7fb2ff','2026-08-10 08:26:23'),
('75','The Age of Adz','Sufjan Stevens','2010','Alternative','Asthmatic Kitty',NULL,'11','75','The Age of Adz is Sufjan Stevens\'s alternative album from 2010, collecting 11 tracks across about 75 minutes.','assets/covers/75.jpg','#1fbf9f','#5fe0c4','2026-08-10 08:26:24'),
('76','Blues & Roots','Charles Mingus','1960','Jazz','Atlantic Recording Corp. Manufactured & Marketed by Warner Strategic Marketing',NULL,'10','68','Out in 1960 on Atlantic Recording Corp. Manufactured & Marketed by Warner Strategic Marketing, Blues & Roots gathers 10 tracks across about 68 minutes of jazz from Charles Mingus.','assets/covers/76.jpg','#8f5bff','#b98bff','2026-08-10 08:26:24'),
('77','RTJ4','Run The Jewels','2021','Hip-Hop','Jewel Runners LLC under exclusive license to BMG Rights Management (US) LLC',NULL,'26','92','Run The Jewels\'s 2021 hip-hop album. 26 tracks, about 92 minutes.','assets/covers/77.jpg','#f2b90a','#ffe07f','2026-08-10 08:26:25'),
('78','After the Gold Rush','Neil Young','1970','Rock','Reprise Records',NULL,'11','35','Released in 1970, After the Gold Rush runs to 11 tracks across about 35 minutes of rock from Neil Young.','assets/covers/78.jpg','#ff7ab8','#ffb3d4','2026-08-10 08:26:26'),
('79','Honey','Robyn','2018','Pop','Konichiwa Records, under exclusive license to Interscope Records',NULL,'9','40','Robyn released Honey in 2018. 9 tracks across about 40 minutes of pop.','assets/covers/79.jpg','#ff6b6b','#ff9f7f','2026-08-10 08:26:26'),
('80','Blood On the Tracks','Bob Dylan','1975','Folk','Sony Music Entertainment Inc.',NULL,'10','52','A folk record from Bob Dylan, originally released in 1975 on Sony Music Entertainment Inc. 10 tracks, about 52 minutes.','assets/covers/80.jpg','#4d7dff','#7fb2ff','2026-08-10 08:26:27'),
('81','New Energy','Four Tet','2017','Electronic','Text Records',NULL,'14','56','New Energy is Four Tet\'s electronic album from 2017, collecting 14 tracks across about 56 minutes.','assets/covers/81.jpg','#1fbf9f','#5fe0c4','2026-08-10 08:26:27'),
('82','A Kind of Magic','Queen','1986','Rock','Hollywood Records, Inc.',NULL,'16','71','Out in 1986 on Hollywood Records, Inc., A Kind of Magic gathers 16 tracks across about 71 minutes of rock from Queen.','assets/covers/82.jpg','#8f5bff','#b98bff','2026-08-10 08:26:28'),
('83','Rumours','Fleetwood Mac','1977','Rock','Warner Records Inc.',NULL,'11','40','Five band members writing through the collapse of their own relationships, and somehow turning it into the most polished pop-rock record of the decade.','assets/covers/83.jpg','#f2b90a','#ffe07f','2026-08-10 08:26:28'),
('84','Random Access Memories','Daft Punk','2013','Pop','Daft Life Limited under exclusive license to Columbia Records, a Division of Sony Music Entertainment',NULL,'14','75','Two robots hire live session players and disco veterans, then build an album about missing the way records used to sound.','assets/covers/84.jpg','#ff7ab8','#ffb3d4','2026-08-10 08:26:29'),
('85','Tunes 2011-2019','Burial','2019','Electronic','Hyperdub',NULL,'17','150','Burial released Tunes 2011-2019 in 2019. 17 tracks across about 150 minutes of electronic.','assets/covers/85.jpg','#ff6b6b','#ff9f7f','2026-08-10 08:26:30'),
('86','The Rise and Fall of Ziggy Stardust and the Spiders from Mars','David Bowie','1972','Rock','Under exclusive license to Parlophone Records Limited, ℗ 1972, 2012 Jones/Tintoretto Entertainment Company LLC',NULL,'11','39','A rock record from David Bowie, originally released in 1972 on Under exclusive license to Parlophone Records Limited, ℗ 1972, 2012 Jones/Tintoretto Entertainment Company LLC. 11 tracks, about 39 minutes.','assets/covers/86.jpg','#4d7dff','#7fb2ff','2026-08-10 08:26:30'),
('87','The North Borders','Bonobo','2013','Electronic','Ninja Tune',NULL,'13','59','The North Borders is Bonobo\'s electronic album from 2013, collecting 13 tracks across about 59 minutes.','assets/covers/87.jpg','#1fbf9f','#5fe0c4','2026-08-10 08:26:31'),
('88','Say You Will','Fleetwood Mac','2003','Rock','Reprise Records for the U.S. and WEA International Inc. for the world outside of the U.S.',NULL,'18','76','Out in 2003 on Reprise Records for the U.S. and WEA International Inc. for the world outside of the U.S., Say You Will gathers 18 tracks across about 76 minutes of rock from Fleetwood Mac.','assets/covers/88.jpg','#8f5bff','#b98bff','2026-08-10 08:26:31'),
('89','Tranquility Base Hotel & Casino','Arctic Monkeys','2018','Alternative','Domino Recording Company Ltd',NULL,'11','41','Arctic Monkeys\'s 2018 alternative album. 11 tracks, about 41 minutes.','assets/covers/89.jpg','#f2b90a','#ffe07f','2026-08-10 08:26:32'),
('90','Bitches Brew','Miles Davis','1970','Jazz','Originally Recorded 1970, Originally Released 1970 Sony Music Entertainment Inc.',NULL,'7','106','Released in 1970, Bitches Brew runs to 7 tracks across about 106 minutes of jazz from Miles Davis.','assets/covers/90.jpg','#ff7ab8','#ffb3d4','2026-08-10 08:26:32'),
('91','A Treasury','Nick Drake','2004','Folk','This Compilation ℗ 2004 Universal-Island Records Ltd.',NULL,'15','52','Nick Drake released A Treasury in 2004. 15 tracks across about 52 minutes of folk.','assets/covers/91.jpg','#ff6b6b','#ff9f7f','2026-08-10 08:26:33'),
('92','Future Shock','Herbie Hancock','1983','Jazz',', 1984 Sony Music Entertainment Inc.',NULL,'7','44','A jazz record from Herbie Hancock, originally released in 1983 on , 1984 Sony Music Entertainment Inc. 7 tracks, about 44 minutes.','assets/covers/92.jpg','#4d7dff','#7fb2ff','2026-08-10 08:26:33'),
('93','Nirvana','Nirvana','2002','Alternative','A Geffen Records Release; ℗ 2002 UMG Recordings, Inc.',NULL,'14','49','Nirvana is Nirvana\'s alternative album from 2002, collecting 14 tracks across about 49 minutes.','assets/covers/93.jpg','#1fbf9f','#5fe0c4','2026-08-10 08:26:34'),
('94','Boxer','The National','2007','Alternative','Beggars Banquet Records Ltd',NULL,'14','50','Out in 2007 on Beggars Banquet Records Ltd, Boxer gathers 14 tracks across about 50 minutes of alternative from The National.','assets/covers/94.jpg','#8f5bff','#b98bff','2026-08-10 08:26:34'),
('95','Lover','Taylor Swift','2019','Pop','Taylor Swift',NULL,'18','62','Taylor Swift\'s 2019 pop album. 18 tracks, about 62 minutes.','assets/covers/95.jpg','#f2b90a','#ffe07f','2026-08-10 08:26:34'),
('96','Southernplayalisticadillacmuzik','Outkast','1994','Hip-Hop','Arista Records LLC',NULL,'17','65','Released in 1994, Southernplayalisticadillacmuzik runs to 17 tracks across about 65 minutes of hip-hop from Outkast.','assets/covers/96.jpg','#ff7ab8','#ffb3d4','2026-08-10 08:26:35'),
('97','Led Zeppelin IV','Led Zeppelin','1971','Rock','Atlantic Recording Corporation, a Warner Music Group Company. Marketed by Rhino Entertainment Company, a Warner Music Group Company.',NULL,'8','43','Led Zeppelin released Led Zeppelin IV in 1971. 8 tracks across about 43 minutes of rock.','assets/covers/97.jpg','#ff6b6b','#ff9f7f','2026-08-10 08:26:35'),
('98','Things Fall Apart','The Roots','1999','Hip-Hop','DGC Records',NULL,'18','69','A hip-hop record from The Roots, originally released in 1999 on DGC Records. 18 tracks, about 69 minutes.','assets/covers/98.jpg','#4d7dff','#7fb2ff','2026-08-10 08:26:36'),
('99','NASIR','Nas','2018','Hip-Hop','Mass Appeal Records LLC, distributed by Def Jam Recordings',NULL,'7','27','NASIR is Nas\'s hip-hop album from 2018, collecting 7 tracks across about 27 minutes.','assets/covers/99.jpg','#1fbf9f','#5fe0c4','2026-08-10 08:26:36'),
('100','How I Got Over','The Roots','2010','Hip-Hop','The Island Def Jam Music Group',NULL,'15','43','Out in 2010 on The Island Def Jam Music Group, How I Got Over gathers 15 tracks across about 43 minutes of hip-hop from The Roots.','assets/covers/100.jpg','#8f5bff','#b98bff','2026-08-10 08:26:36'),
('101','DAMN.','Kendrick Lamar','2017','Hip-Hop','Aftermath/Interscope (Top Dawg Entertainment)',NULL,'15','55','Kendrick Lamar\'s 2017 hip-hop album. 15 tracks, about 55 minutes.','assets/covers/101.jpg','#f2b90a','#ffe07f','2026-08-10 08:26:37');
INSERT INTO `albums` (`id`, `title`, `artist`, `year`, `genre`, `label`, `producer`, `track_count`, `duration_min`, `description`, `cover_url`, `cover_color_1`, `cover_color_2`, `created_at`) VALUES
('102','The Kick Inside','Kate Bush','1978','Pop','Noble & Brite Ltd',NULL,'13','43','Released in 1978, The Kick Inside runs to 13 tracks across about 43 minutes of pop from Kate Bush.','assets/covers/102.jpg','#ff7ab8','#ffb3d4','2026-08-10 08:26:38'),
('103','Art Blakey\'s Jazz Messengers With Thelonious Monk','Thelonious Monk & Art Blakey','1958','Jazz','Warner Strategic Marketing.',NULL,'9','64','Thelonious Monk & Art Blakey released Art Blakey\'s Jazz Messengers With Thelonious Monk in 1958. 9 tracks across about 64 minutes of jazz.','assets/covers/103.jpg','#ff6b6b','#ff9f7f','2026-08-10 08:26:38'),
('104','Sky Blue Sky','Wilco','2007','Rock','Nonesuch Records Inc.',NULL,'12','51','A rock record from Wilco, originally released in 2007 on Nonesuch Records Inc. 12 tracks, about 51 minutes.','assets/covers/104.jpg','#4d7dff','#7fb2ff','2026-08-10 08:26:39'),
('105','thank u, next','Ariana Grande','2019','Pop','Republic Records, a division of UMG Recordings, Inc.',NULL,'12','41','thank u, next is Ariana Grande\'s pop album from 2019, collecting 12 tracks across about 41 minutes.','assets/covers/105.jpg','#1fbf9f','#5fe0c4','2026-08-10 08:26:40'),
('106','The Tony Bennett / Bill Evans Album','Tony Bennett & Bill Evans','1975','Jazz','Fantasy, Inc.',NULL,'14','54','Out in 1975 on Fantasy, Inc., The Tony Bennett / Bill Evans Album gathers 14 tracks across about 54 minutes of jazz from Tony Bennett & Bill Evans.','assets/covers/106.jpg','#8f5bff','#b98bff','2026-08-10 08:26:40'),
('107','All Delighted People EP','Sufjan Stevens','2010','Alternative','Sufjan Stevens',NULL,'8','60','Sufjan Stevens\'s 2010 alternative album. 8 tracks, about 60 minutes.','assets/covers/107.jpg','#f2b90a','#ffe07f','2026-08-10 08:26:41'),
('108','Solo Monk','Thelonious Monk','1965','Jazz','Sony Music Entertainment Inc.',NULL,'21','70','Released in 1965, Solo Monk runs to 21 tracks across about 70 minutes of jazz from Thelonious Monk.','assets/covers/108.jpg','#ff7ab8','#ffb3d4','2026-08-10 08:26:42'),
('109','Speaking In Tongues','Talking Heads','1983','Pop','Sire Records Company',NULL,'9','47','Talking Heads released Speaking In Tongues in 1983. 9 tracks across about 47 minutes of pop.','assets/covers/109.jpg','#ff6b6b','#ff9f7f','2026-08-10 08:26:42'),
('110','High Violet','The National','2010','Alternative','4AD Ltd',NULL,'12','50','A alternative record from The National, originally released in 2010 on 4AD Ltd. 12 tracks, about 50 minutes.','assets/covers/110.jpg','#4d7dff','#7fb2ff','2026-08-10 08:26:43'),
('111','Tusk','Fleetwood Mac','1979','Rock','Warner Records Inc. All Rights Reserved. Marketed by Warner Strategic Marketing. Printed in U.S.A.',NULL,'20','74','Tusk is Fleetwood Mac\'s rock album from 1979, collecting 20 tracks across about 74 minutes.','assets/covers/111.jpg','#1fbf9f','#5fe0c4','2026-08-10 08:26:44'),
('112','Popular Favorites 1976-1992: Sand In the Vaseline','Talking Heads','1992','Alternative','Sire Records, manufactured and marketed by Rhino Entertainment Company, a Warner Music Group Company',NULL,'33','142','Out in 1992 on Sire Records, manufactured and marketed by Rhino Entertainment Company, a Warner Music Group Company, Popular Favorites 1976-1992: Sand In the Vaseline gathers 33 tracks across about 142 minutes of alternative from Talking Heads.','assets/covers/112.jpg','#8f5bff','#b98bff','2026-08-10 08:26:45'),
('113','Midnights (3am Edition)','Taylor Swift','2022','Pop','Taylor Swift',NULL,'21','69','Taylor Swift\'s 2022 pop album. 21 tracks, about 69 minutes.','assets/covers/113.jpg','#f2b90a','#ffe07f','2026-08-10 08:26:45'),
('114','Harvest','Neil Young','1972','Rock','Warner Records Inc.',NULL,'10','38','Country-leaning songs cut between Nashville, a barn in California and a London orchestra session, and the record that made him far bigger than he wanted to be.','assets/covers/114.jpg','#ff7ab8','#ffb3d4','2026-08-10 08:26:46'),
('115','Siamese Dream','The Smashing Pumpkins','1993','Rock','Virgin Records America, Inc.',NULL,'14','62','The Smashing Pumpkins released Siamese Dream in 1993. 14 tracks across about 62 minutes of rock.','assets/covers/115.jpg','#ff6b6b','#ff9f7f','2026-08-10 08:26:46'),
('116','Oceania','The Smashing Pumpkins','2012','Rock','Martha\'s Music, LLC. All rights reserved. Unauthorized reproduction is a violation of applicable laws.  Manufactured by EMI Label Services,',NULL,'14','60','A rock record from The Smashing Pumpkins, originally released in 2012 on Martha\'s Music, LLC. All rights reserved. Unauthorized reproduction is a violation of applicable laws.  Manufactured by EMI Label Services,. 14 tracks, about 60 minutes.','assets/covers/116.jpg','#4d7dff','#7fb2ff','2026-08-10 08:26:47'),
('117','Drukqs','Aphex Twin','2001','Electronic','Warp Records',NULL,'30','101','Drukqs is Aphex Twin\'s electronic album from 2001, collecting 30 tracks across about 101 minutes.','assets/covers/117.jpg','#1fbf9f','#5fe0c4','2026-08-10 08:26:47'),
('118','No Geography','The Chemical Brothers','2019','Electronic','A Virgin EMI Records release; ℗ 2019 The Chemical Brothers, under exclusive license to Universal Music Operations Limited',NULL,'10','47','Out in 2019 on A Virgin EMI Records release; ℗ 2019 The Chemical Brothers, under exclusive license to Universal Music Operations Limited, No Geography gathers 10 tracks across about 47 minutes of electronic from The Chemical Brothers.','assets/covers/118.jpg','#8f5bff','#b98bff','2026-08-10 08:26:48'),
('119','Heligoland','Massive Attack','2010','Electronic','Virgin Records Limited',NULL,'11','53','Massive Attack\'s 2010 electronic album. 11 tracks, about 53 minutes.','assets/covers/119.jpg','#f2b90a','#ffe07f','2026-08-10 08:26:49'),
('120','E.S.P.','Miles Davis','1965','Jazz','Sony Music Entertainment',NULL,'7','49','Released in 1965, E.S.P. runs to 7 tracks across about 49 minutes of jazz from Miles Davis.','assets/covers/120.jpg','#ff7ab8','#ffb3d4','2026-08-10 08:26:49'),
('121','Pause','Four Tet','2001','Electronic','Domino Recording Co Ltd',NULL,'11','43','Four Tet released Pause in 2001. 11 tracks across about 43 minutes of electronic.','assets/covers/121.jpg','#ff6b6b','#ff9f7f','2026-08-10 08:26:50'),
('122','Stan Getz & Bill Evans (Previously Unreleased Recordings)','Stan Getz & Bill Evans','1973','Jazz','A Verve Label Group release; ℗ 1973 UMG Recordings, Inc.',NULL,'11','62','A jazz record from Stan Getz & Bill Evans, originally released in 1973 on A Verve Label Group release; ℗ 1973 UMG Recordings, Inc. 11 tracks, about 62 minutes.','assets/covers/122.jpg','#4d7dff','#7fb2ff','2026-08-10 08:26:50'),
('123','Red','Taylor Swift','2021','Pop','Taylor Swift',NULL,'30','131','Red is Taylor Swift\'s pop album from 2021, collecting 30 tracks across about 131 minutes.','assets/covers/123.jpg','#1fbf9f','#5fe0c4','2026-08-10 08:26:51'),
('124','Living With War','Neil Young','2006','Rock','Reprise Records for the U.S. and WEA International Inc. for the world outside the U.S.',NULL,'10','42','Out in 2006 on Reprise Records for the U.S. and WEA International Inc. for the world outside the U.S., Living With War gathers 10 tracks across about 42 minutes of rock from Neil Young.','assets/covers/124.jpg','#8f5bff','#b98bff','2026-08-10 08:26:51'),
('125','Midnight Marauders','A Tribe Called Quest','1993','Hip-Hop','Zomba Recording LLC',NULL,'14','51','A Tribe Called Quest\'s 1993 hip-hop album. 14 tracks, about 51 minutes.','assets/covers/125.jpg','#f2b90a','#ffe07f','2026-08-10 08:26:51'),
('126','Cantaloupe Island','Herbie Hancock','1994','Jazz','This Compilation ℗ 1994 Blue Note Records',NULL,'6','43','Released in 1994, Cantaloupe Island runs to 6 tracks across about 43 minutes of jazz from Herbie Hancock.','assets/covers/126.jpg','#ff7ab8','#ffb3d4','2026-08-10 08:26:52'),
('127','OK Computer','Radiohead','1997','Alternative','XL Recordings Ltd',NULL,'12','54','Guitar music bent into something colder and stranger, full of dread about technology that only reads as more accurate with time.','assets/covers/127.jpg','#ff6b6b','#ff9f7f','2026-08-10 08:26:53'),
('128','Sexistential','Robyn','2026','Pop','Konichiwa / Young',NULL,'9','30','A pop record from Robyn, originally released in 2026 on Konichiwa / Young. 9 tracks, about 30 minutes.','assets/covers/128.jpg','#4d7dff','#7fb2ff','2026-08-10 08:26:53'),
('129','FABRICLIVE 100: Kode9 & Burial','Kode9 & Burial','2018','Electronic',NULL,NULL,'27','133','FABRICLIVE 100: Kode9 & Burial is Kode9 & Burial\'s electronic album from 2018, collecting 27 tracks across about 133 minutes.','assets/covers/129.jpg','#1fbf9f','#5fe0c4','2026-08-10 08:26:53'),
('130','Fleet Foxes','Fleet Foxes','2008','Alternative','Sub Pop Records',NULL,'11','39','Out in 2008 on Sub Pop Records, Fleet Foxes gathers 11 tracks across about 39 minutes of alternative from Fleet Foxes.','assets/covers/130.jpg','#8f5bff','#b98bff','2026-08-10 08:26:54'),
('131','Straight, No Chaser','Thelonious Monk','1967','Jazz',', 1996 Sony Music Entertainment Inc.',NULL,'9','76','Thelonious Monk\'s 1967 jazz album. 9 tracks, about 76 minutes.','assets/covers/131.jpg','#f2b90a','#ffe07f','2026-08-10 08:26:54'),
('132','Thelonious Monk With John Coltrane','Thelonious Monk & John Coltrane','1961','Jazz','Concord Music Group, Inc.',NULL,'8','46','Released in 1961, Thelonious Monk With John Coltrane runs to 8 tracks across about 46 minutes of jazz from Thelonious Monk & John Coltrane.','assets/covers/132.jpg','#ff7ab8','#ffb3d4','2026-08-10 08:26:54'),
('133','Yankee Hotel Foxtrot','Wilco','2002','Rock','Nonesuch Records',NULL,'11','52','Wilco released Yankee Hotel Foxtrot in 2002. 11 tracks across about 52 minutes of rock.','assets/covers/133.jpg','#ff6b6b','#ff9f7f','2026-08-10 08:26:55'),
('134','petal','Ariana Grande','2026','Pop','A Republic Records Release; ℗ 2026 Babydoll Music, under exclusive license to Republic Records, a division of UMG Recordings, Inc.',NULL,'13','37','A pop record from Ariana Grande, originally released in 2026 on A Republic Records Release; ℗ 2026 Babydoll Music, under exclusive license to Republic Records, a division of UMG Recordings, Inc. 13 tracks, about 37 minutes.','assets/covers/134.jpg','#4d7dff','#7fb2ff','2026-08-10 08:26:55'),
('135','We Got It from Here... Thank You 4 Your Service','A Tribe Called Quest','2016','Hip-Hop','Epic Records, a division of Sony Music Entertainment',NULL,'16','60','We Got It from Here.. Thank You 4 Your Service is A Tribe Called Quest\'s hip-hop album from 2016, collecting 16 tracks across about 60 minutes.','assets/covers/135.jpg','#1fbf9f','#5fe0c4','2026-08-10 08:26:56'),
('136','Mr. Morale & The Big Steppers','Kendrick Lamar','2022','Hip-Hop','pgLang/Top Dawg Entertainment/Aftermath/Interscope Records; ℗ 2022 Aftermath/Interscope Records',NULL,'18','0','Out in 2022 on pgLang/Top Dawg Entertainment/Aftermath/Interscope Records; ℗ 2022 Aftermath/Interscope Records, Mr. Morale & The Big Steppers gathers 18 tracks of hip-hop from Kendrick Lamar.','assets/covers/136.jpg','#8f5bff','#b98bff','2026-08-10 08:26:56'),
('137','To Pimp a Butterfly','Kendrick Lamar','2015','Hip-Hop','Aftermath/Interscope (Top Dawg Entertainment)',NULL,'17','79','Free jazz, funk and spoken word pulled into a dense record about fame, survivor guilt and Black identity in America.','assets/covers/137.jpg','#f2b90a','#ffe07f','2026-08-10 08:26:57'),
('138','Station to Station','David Bowie','1976','Rock',', 2016 Jones/Tintoretto Entertainment Co., LLC under exclusive license to Parlophone Records Ltd, a Warner Music Group Company',NULL,'6','38','Released in 1976, Station to Station runs to 6 tracks across about 38 minutes of rock from David Bowie.','assets/covers/138.jpg','#ff7ab8','#ffb3d4','2026-08-10 08:26:58'),
('139','A Moon Shaped Pool','Radiohead','2016','Alternative','LLLP LLP under exclusive license to XL Recordings Ltd',NULL,'11','53','Radiohead released A Moon Shaped Pool in 2016. 11 tracks across about 53 minutes of alternative.','assets/covers/139.jpg','#ff6b6b','#ff9f7f','2026-08-10 08:26:58'),
('140','Bleach','Nirvana','1989','Alternative','Sub Pop Records',NULL,'26','77','A alternative record from Nirvana, originally released in 1989 on Sub Pop Records. 26 tracks, about 77 minutes.','assets/covers/140.jpg','#4d7dff','#7fb2ff','2026-08-10 08:26:59'),
('141','Wish You Were Here','Pink Floyd','1975','Rock','The copyright in this sound recording is owned by Pink Floyd Music Ltd., marketed and distributed by Sony Music Entertainment',NULL,'6','44','Wish You Were Here is Pink Floyd\'s rock album from 1975, collecting 6 tracks across about 44 minutes.','assets/covers/141.jpg','#1fbf9f','#5fe0c4','2026-08-10 08:26:59'),
('142','For the Roses','Joni Mitchell','1972','Pop','Asylum Records',NULL,'12','40','Out in 1972 on Asylum Records, For the Roses gathers 12 tracks across about 40 minutes of pop from Joni Mitchell.','assets/covers/142.jpg','#8f5bff','#b98bff','2026-08-10 08:27:00'),
('143','Rounds','Four Tet','2003','Electronic','Domino Recording Co Ltd',NULL,'10','45','Four Tet\'s 2003 electronic album. 10 tracks, about 45 minutes.','assets/covers/143.jpg','#f2b90a','#ffe07f','2026-08-10 08:27:00'),
('144','Sticky Fingers','The Rolling Stones','1971','Rock','Promotone B.V., under exclusive licence to Universal International Music B.V.',NULL,'10','46','Released in 1971, Sticky Fingers runs to 10 tracks across about 46 minutes of rock from The Rolling Stones.','assets/covers/144.jpg','#ff7ab8','#ffb3d4','2026-08-10 08:27:01'),
('145','Favourite Worst Nightmare','Arctic Monkeys','2007','Alternative','Domino Recording Company Ltd. under exclusive license to Warner Records Inc. for the United States, and WEA International Inc. for Canada.',NULL,'12','37','Arctic Monkeys released Favourite Worst Nightmare in 2007. 12 tracks across about 37 minutes of alternative.','assets/covers/145.jpg','#ff6b6b','#ff9f7f','2026-08-10 08:27:01'),
('146','King\'s Disease II','Nas','2021','Hip-Hop','Mass Appeal',NULL,'15','52','A hip-hop record from Nas, originally released in 2021 on Mass Appeal. 15 tracks, about 52 minutes.','assets/covers/146.jpg','#4d7dff','#7fb2ff','2026-08-10 08:27:02'),
('147','Run The Jewels','Run The Jewels','2013','Hip-Hop','Seeker Music',NULL,'10','33','Run The Jewels is Run The Jewels\'s hip-hop album from 2013, collecting 10 tracks across about 33 minutes.','assets/covers/147.jpg','#1fbf9f','#5fe0c4','2026-08-10 08:27:02'),
('148','News of the World','Queen','1977','Rock','Hollywood Records, Inc.',NULL,'16','56','Out in 1977 on Hollywood Records, Inc., News of the World gathers 16 tracks across about 56 minutes of rock from Queen.','assets/covers/148.jpg','#8f5bff','#b98bff','2026-08-10 08:27:03'),
('149','Computer Controlled Acoustic Instruments, Pt. 2','Aphex Twin','2015','Electronic','Warp Records Limited',NULL,'13','28','Aphex Twin\'s 2015 electronic album. 13 tracks, about 28 minutes.','assets/covers/149.jpg','#f2b90a','#ffe07f','2026-08-10 08:27:03'),
('150','Blue Train','John Coltrane','1958','Jazz','This Compilation ℗ 2003 Blue Note Records',NULL,'7','59','Released in 1958, Blue Train runs to 7 tracks across about 59 minutes of jazz from John Coltrane.','assets/covers/150.jpg','#ff7ab8','#ffb3d4','2026-08-10 08:27:04');

-- ----------------------------
-- Table: reviews
-- ----------------------------
DROP TABLE IF EXISTS `reviews`;
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
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `reviews` (`id`, `user_id`, `album_id`, `rating`, `review_text`, `created_at`) VALUES
('15','1','3','5','Absolute classic. Holds up completely.','2026-08-10 08:32:15'),
('16','2','3','4','Really strong front to back, drags slightly in the middle.','2026-08-10 08:32:15'),
('17','1','8','4','Grew on me a lot after a few listens.','2026-08-10 08:32:15'),
('18','2','13','5','One of my favourites of all time.','2026-08-10 08:32:15'),
('19','1','21','3','Good but not their best work.','2026-08-10 08:32:15'),
('20','2','26','5','Production on this is unbelievable.','2026-08-10 08:32:15'),
('21','1','35','4','Great late-night listening.','2026-08-10 08:32:15'),
('22','2','43','4','Solid throughout, no skips for me.','2026-08-10 08:32:15'),
('23','1','57','5','Still sounds ahead of its time.','2026-08-10 08:32:15'),
('24','2','62','3','Decent, though a bit long.','2026-08-10 08:32:15');

-- ----------------------------
-- Table: collection
-- ----------------------------
DROP TABLE IF EXISTS `collection`;
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
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `collection` (`id`, `user_id`, `album_id`, `created_at`) VALUES
('7','2','3','2026-08-10 08:32:15'),
('8','2','13','2026-08-10 08:32:15'),
('9','2','26','2026-08-10 08:32:15'),
('10','1','8','2026-08-10 08:32:15');

SET FOREIGN_KEY_CHECKS=1;
