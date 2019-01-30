-- MySQL dump 10.15  Distrib 10.0.22-MariaDB, for Linux (x86_64)
--
-- Host: localhost    Database: hvht_db
-- ------------------------------------------------------
-- Server version	10.0.22-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `wminfo`
--

DROP TABLE IF EXISTS `wminfo`;
CREATE TABLE `wminfo` (
  `Win32_BIOS$SerialNumber` varchar(767) NOT NULL,
  `Win32_ComputerSystem$Name` text,
  `Win32_NetworkAdapterConfiguration$IPAddress` text,
  `Win32_ComputerSystem$Domain` text,
  `Win32_Timezone$Caption` text,
  `Win32_Timezone$Bias` text,
  `Win32_Timezone$DaylightBias` text,
  `Win32_LocalTime$Year` text,
  `Win32_LocalTime$Month` text,
  `Win32_LocalTime$Day` text,
  `Win32_LocalTime$Hour` text,
  `Win32_LocalTime$Minute` text,
  `Win32_LocalTime$Second` text,
  `Win32_OperatingSystem$CurrentTimeZone` text,
  `Win32_Timezone$DaylightDay` text,
  `Win32_Timezone$DaylightDayOfWeek` text,
  `Win32_Timezone$DaylightMonth` text,
  `Win32_Timezone$StandardDay` text,
  `Win32_Timezone$StandardDayOfWeek` text,
  `Win32_Timezone$StandardMonth` text,
  `Win32_OperatingSystem$Caption` text,
  `source_address` text,
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`Win32_BIOS$SerialNumber`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wminfo`
--

LOCK TABLES `wminfo` WRITE;
/*!40000 ALTER TABLE `wminfo` DISABLE KEYS */;
/*!40000 ALTER TABLE `wminfo` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-01-22 18:30:52
