CREATE DATABASE  IF NOT EXISTS `job_tracker` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `job_tracker`;
-- MySQL dump 10.13  Distrib 8.0.42, for macos15 (arm64)
--
-- Host: localhost    Database: job_tracker
-- ------------------------------------------------------
-- Server version	9.3.0

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
-- Table structure for table `application_summary`
--

DROP TABLE IF EXISTS `application_summary`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `application_summary` (
  `summary_id` int NOT NULL AUTO_INCREMENT,
  `company_name` varchar(100) DEFAULT NULL,
  `total_jobs` int DEFAULT NULL,
  `total_applications` int DEFAULT NULL,
  `avg_salary` decimal(10,2) DEFAULT NULL,
  `last_updated` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`summary_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `application_summary`
--

LOCK TABLES `application_summary` WRITE;
/*!40000 ALTER TABLE `application_summary` DISABLE KEYS */;
INSERT INTO `application_summary` VALUES (1,'Tech Solutions Inc',4,1,65000.00,'2026-03-22 16:45:52'),(2,'Data Analytics Corp',4,1,61250.00,'2026-03-22 16:45:52'),(3,'Cloud Systems LLC',3,1,78333.33,'2026-03-22 16:45:52'),(4,'Digital Innovations',4,3,67400.00,'2026-03-22 16:45:52'),(5,'Smart Tech Group',2,1,90000.00,'2026-03-22 16:45:52'),(6,'New Tech Corp',1,0,120000.00,'2026-03-22 16:45:52');
/*!40000 ALTER TABLE `application_summary` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `applications`
--

DROP TABLE IF EXISTS `applications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `applications` (
  `application_id` int NOT NULL AUTO_INCREMENT,
  `job_id` int NOT NULL,
  `application_date` date NOT NULL,
  `status` enum('Applied','Screening','Interview','Offer','Rejected','Withdrawn') NOT NULL,
  `resume_version` varchar(50) DEFAULT NULL,
  `cover_letter_sent` tinyint(1) DEFAULT '0',
  `interview_data` json DEFAULT NULL,
  PRIMARY KEY (`application_id`),
  KEY `job_id` (`job_id`),
  KEY `idx_app_status` (`status`),
  CONSTRAINT `applications_ibfk_1` FOREIGN KEY (`job_id`) REFERENCES `jobs` (`job_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `applications`
--

LOCK TABLES `applications` WRITE;
/*!40000 ALTER TABLE `applications` DISABLE KEYS */;
INSERT INTO `applications` VALUES (1,1,'2025-01-16','Offer','v2.1',1,NULL),(2,3,'2025-01-13','Interview','v2.1',1,NULL),(3,4,'2025-01-09','Interview','v2.0',0,NULL),(4,5,'2025-01-15','Applied','v2.1',1,NULL),(5,7,'2025-01-12','Screening','v2.1',1,NULL),(6,6,'2026-02-09','Applied','v3.0',1,NULL),(7,6,'2026-02-09','Applied','v3.0',1,NULL);
/*!40000 ALTER TABLE `applications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `companies`
--

DROP TABLE IF EXISTS `companies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `companies` (
  `company_id` int NOT NULL AUTO_INCREMENT,
  `company_name` varchar(100) NOT NULL,
  `industry` varchar(50) DEFAULT NULL,
  `website` varchar(200) DEFAULT NULL,
  `city` varchar(50) DEFAULT NULL,
  `state` varchar(50) DEFAULT NULL,
  `notes` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`company_id`),
  KEY `idx_company_industry` (`industry`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `companies`
--

LOCK TABLES `companies` WRITE;
/*!40000 ALTER TABLE `companies` DISABLE KEYS */;
INSERT INTO `companies` VALUES (1,'Tech Solutions Inc','Technology','www.techsolutions.com','Miami','Florida',NULL,'2026-01-24 03:10:00'),(2,'Data Analytics Corp','Data Science','www.dataanalytics.com','Austin','Texas',NULL,'2026-01-24 03:10:00'),(3,'Cloud Systems LLC','Cloud Computing','www.cloudsystems.com','Seattle','Washington',NULL,'2026-01-24 03:10:00'),(4,'Digital Innovations','Software','www.digitalinnovations.com','San Francisco','California','Applied to Senior Developer position on 2026-02-09','2026-01-24 03:10:00'),(5,'Smart Tech Group','AI/ML','www.smarttech.com','Boston','Massachusetts',NULL,'2026-01-24 03:10:00'),(7,'New Tech Corp','Technology',NULL,'Denver','Colorado',NULL,'2026-02-09 23:48:48');
/*!40000 ALTER TABLE `companies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contacts`
--

DROP TABLE IF EXISTS `contacts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contacts` (
  `contact_id` int NOT NULL AUTO_INCREMENT,
  `company_id` int NOT NULL,
  `contact_name` varchar(100) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `job_title` varchar(100) DEFAULT NULL,
  `linkedin_url` varchar(200) DEFAULT NULL,
  `notes` text,
  PRIMARY KEY (`contact_id`),
  KEY `company_id` (`company_id`),
  CONSTRAINT `contacts_ibfk_1` FOREIGN KEY (`company_id`) REFERENCES `companies` (`company_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contacts`
--

LOCK TABLES `contacts` WRITE;
/*!40000 ALTER TABLE `contacts` DISABLE KEYS */;
INSERT INTO `contacts` VALUES (1,1,'','sjohnson@techsolutions.com',NULL,'HR Manager',NULL,NULL),(2,2,'','mchen@dataanalytics.com',NULL,'Technical\nRecruiter',NULL,NULL),(3,3,'','ewilliams@cloudsystems.com',NULL,'Hiring\nManager',NULL,NULL),(4,4,'',NULL,NULL,'Senior Developer',NULL,NULL),(5,5,'','lgarcia@smarttech.com',NULL,'Talent\nAcquisition',NULL,NULL),(7,4,'','rkim@digitalinnovations.com',NULL,'Engineering Manager',NULL,NULL);
/*!40000 ALTER TABLE `contacts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `jobs`
--

DROP TABLE IF EXISTS `jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `jobs` (
  `job_id` int NOT NULL AUTO_INCREMENT,
  `company_id` int NOT NULL,
  `job_title` varchar(100) NOT NULL,
  `job_description` text,
  `salary_min` int DEFAULT NULL,
  `salary_max` int DEFAULT NULL,
  `job_type` enum('Full-time','Part-time','Contract','Internship') DEFAULT NULL,
  `job_url` varchar(300) DEFAULT NULL,
  `date_posted` date DEFAULT NULL,
  `requirements` json DEFAULT NULL,
  PRIMARY KEY (`job_id`),
  KEY `idx_job_title` (`job_title`),
  KEY `idx_company_type` (`company_id`,`job_type`),
  CONSTRAINT `jobs_ibfk_1` FOREIGN KEY (`company_id`) REFERENCES `companies` (`company_id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jobs`
--

LOCK TABLES `jobs` WRITE;
/*!40000 ALTER TABLE `jobs` DISABLE KEYS */;
INSERT INTO `jobs` VALUES (1,1,'Software Developer',NULL,70000,90000,'Full-time',NULL,'2025-01-15','[\"Python\", \"SQL\", \"Git\", \"JavaScript\"]'),(2,1,'Database Administrator',NULL,75000,95000,'Full-time',NULL,'2025-01-10','[\"MySQL\", \"SQL\", \"Database Design\", \"Backup Recovery\"]'),(3,2,'Data Analyst',NULL,65000,85000,'Full-time',NULL,'2025-01-12','[\"SQL\", \"Excel\", \"Tableau\", \"Python\"]'),(4,3,'Cloud Engineer',NULL,80000,100000,'Full-time',NULL,'2025-01-08','[\"AWS\", \"Azure\", \"Docker\", \"Linux\"]'),(5,4,'Junior Developer',NULL,55000,70000,'Full-time',NULL,'2025-01-14','[\"Python\", \"JavaScript\", \"HTML\", \"CSS\"]'),(6,4,'Senior Developer',NULL,95000,120000,'Full-time',NULL,'2025-01-14','[\"Python\", \"JavaScript\", \"SQL\", \"REST APIs\", \"Git\"]'),(7,5,'ML Engineer',NULL,90000,115000,'Full-time',NULL,'2025-01-11','[\"Python\", \"Machine Learning\", \"TensorFlow\", \"SQL\"]'),(8,1,'QA Engineer',NULL,60000,80000,'Full-time',NULL,'2025-01-05','[\"Selenium\", \"Python\", \"SQL\", \"Test Planning\"]'),(9,2,'Business Analyst',NULL,65000,85000,'Full-time',NULL,'2025-01-06','[\"SQL\", \"Excel\", \"Tableau\", \"Business Analysis\"]'),(10,2,'Data Scientist',NULL,85000,110000,'Full-time',NULL,'2025-01-07','[\"Python\", \"Machine Learning\", \"SQL\", \"Statistics\", \"Tableau\"]'),(11,3,'DevOps Engineer',NULL,80000,105000,'Full-time',NULL,'2025-01-08','[\"Docker\", \"Kubernetes\", \"Linux\", \"AWS\", \"CI/CD\"]'),(12,3,'Security Analyst',NULL,75000,95000,'Full-time',NULL,'2025-01-09','[\"Network Security\", \"Python\", \"Linux\", \"Risk Assessment\"]'),(13,4,'UI/UX Designer',NULL,60000,80000,'Full-time',NULL,'2025-01-10','[\"Figma\", \"CSS\", \"HTML\", \"User Research\"]'),(14,5,'Product Manager',NULL,90000,120000,'Full-time',NULL,'2025-01-11','[\"Agile\", \"Jira\", \"SQL\", \"Communication\"]'),(15,1,'Technical Writer',NULL,55000,75000,'Contract',NULL,'2025-01-12','[\"Technical Writing\", \"Markdown\", \"Git\", \"Communication\"]'),(16,2,'Intern - Data',NULL,30000,40000,'Internship',NULL,'2025-01-13','[\"Python\", \"SQL\", \"Excel\"]'),(17,4,'Intern - Development',NULL,32000,42000,'Internship',NULL,'2025-01-14','[\"Python\", \"JavaScript\", \"HTML\", \"CSS\"]'),(18,7,'Software Architect',NULL,120000,150000,'Full-time',NULL,NULL,'[\"Python\", \"SQL\", \"System Design\", \"REST APIs\", \"Git\"]');
/*!40000 ALTER TABLE `jobs` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-03-22 16:03:59
