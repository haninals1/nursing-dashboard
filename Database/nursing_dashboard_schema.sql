-- MySQL dump 10.13  Distrib 8.0.45, for Win64 (x86_64)
--
-- Host: localhost    Database: nursing_dashboard
-- ------------------------------------------------------
-- Server version	8.0.44

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
-- Table structure for table `certificate_type`
--

DROP TABLE IF EXISTS `certificate_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `certificate_type` (
  `certificate_type_id` int NOT NULL AUTO_INCREMENT,
  `certificate_name` varchar(150) NOT NULL,
  `validity_months` int NOT NULL,
  PRIMARY KEY (`certificate_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `daily_assignment`
--

DROP TABLE IF EXISTS `daily_assignment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `daily_assignment` (
  `assignment_id` int NOT NULL AUTO_INCREMENT,
  `nurse_id` int NOT NULL,
  `ratio_id` int NOT NULL,
  `submission_date` date NOT NULL,
  `unit` varchar(100) NOT NULL,
  PRIMARY KEY (`assignment_id`),
  KEY `fk_daily_nurse` (`nurse_id`),
  KEY `fk_daily_ratio` (`ratio_id`),
  CONSTRAINT `fk_daily_nurse` FOREIGN KEY (`nurse_id`) REFERENCES `nursing_staff` (`nurse_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_daily_ratio` FOREIGN KEY (`ratio_id`) REFERENCES `ratio_rule` (`ratio_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `evidenceguideline`
--

DROP TABLE IF EXISTS `evidenceguideline`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `evidenceguideline` (
  `guideline_id` int NOT NULL AUTO_INCREMENT,
  `project_id` int NOT NULL,
  `title` varchar(200) NOT NULL,
  `description` text,
  PRIMARY KEY (`guideline_id`),
  KEY `fk_guideline_project` (`project_id`),
  CONSTRAINT `fk_guideline_project` FOREIGN KEY (`project_id`) REFERENCES `research_project` (`project_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kpi`
--

DROP TABLE IF EXISTS `kpi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kpi` (
  `kpi_id` int NOT NULL AUTO_INCREMENT,
  `kpi_name` varchar(150) NOT NULL,
  `category` varchar(100) NOT NULL,
  PRIMARY KEY (`kpi_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kpi_value`
--

DROP TABLE IF EXISTS `kpi_value`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kpi_value` (
  `kpi_value_id` int NOT NULL AUTO_INCREMENT,
  `kpi_id` int NOT NULL,
  `unit` varchar(100) DEFAULT NULL,
  `value` decimal(12,4) NOT NULL,
  `record_date` date NOT NULL,
  PRIMARY KEY (`kpi_value_id`),
  KEY `fk_kpivalue_kpi` (`kpi_id`),
  CONSTRAINT `fk_kpivalue_kpi` FOREIGN KEY (`kpi_id`) REFERENCES `kpi` (`kpi_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `nursing_staff`
--

DROP TABLE IF EXISTS `nursing_staff`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nursing_staff` (
  `nurse_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `full_name` varchar(150) NOT NULL,
  `unit` varchar(100) NOT NULL,
  `job_title` varchar(120) NOT NULL,
  `qualification` varchar(100) DEFAULT NULL,
  `license_number` varchar(100) DEFAULT NULL,
  `status` enum('Active','On Leave','Terminated') NOT NULL DEFAULT 'Active',
  `hire_date` date DEFAULT NULL,
  PRIMARY KEY (`nurse_id`),
  UNIQUE KEY `user_id` (`user_id`),
  UNIQUE KEY `license_number` (`license_number`),
  CONSTRAINT `fk_nurse_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `performance_evaluation`
--

DROP TABLE IF EXISTS `performance_evaluation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `performance_evaluation` (
  `evaluation_id` int NOT NULL AUTO_INCREMENT,
  `nurse_id` int NOT NULL,
  `score` decimal(6,2) NOT NULL,
  `evaluation_date` date NOT NULL,
  PRIMARY KEY (`evaluation_id`),
  KEY `fk_perf_nurse` (`nurse_id`),
  CONSTRAINT `fk_perf_nurse` FOREIGN KEY (`nurse_id`) REFERENCES `nursing_staff` (`nurse_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ratio_rule`
--

DROP TABLE IF EXISTS `ratio_rule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ratio_rule` (
  `ratio_id` int NOT NULL AUTO_INCREMENT,
  `unit` varchar(100) NOT NULL,
  `ratio_value` decimal(5,2) NOT NULL,
  `safe_limit` int NOT NULL,
  PRIMARY KEY (`ratio_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `request`
--

DROP TABLE IF EXISTS `request`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `request` (
  `request_id` int NOT NULL AUTO_INCREMENT,
  `nurse_id` int NOT NULL,
  `request_type` varchar(100) NOT NULL,
  `submission_date` date NOT NULL,
  `current_status` enum('Pending','Approved','Rejected') NOT NULL DEFAULT 'Pending',
  PRIMARY KEY (`request_id`),
  KEY `fk_request_nurse` (`nurse_id`),
  CONSTRAINT `fk_request_nurse` FOREIGN KEY (`nurse_id`) REFERENCES `nursing_staff` (`nurse_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `request_approval`
--

DROP TABLE IF EXISTS `request_approval`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `request_approval` (
  `approval_id` int NOT NULL AUTO_INCREMENT,
  `request_id` int NOT NULL,
  `approver_role` enum('Supervisor','Assistant Director') NOT NULL,
  `decision` enum('Approved','Rejected','Pending') NOT NULL DEFAULT 'Pending',
  `decision_date` date DEFAULT NULL,
  PRIMARY KEY (`approval_id`),
  KEY `fk_approval_request` (`request_id`),
  CONSTRAINT `fk_approval_request` FOREIGN KEY (`request_id`) REFERENCES `request` (`request_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `research_project`
--

DROP TABLE IF EXISTS `research_project`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `research_project` (
  `project_id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(200) NOT NULL,
  `status` varchar(50) NOT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  PRIMARY KEY (`project_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `role`
--

DROP TABLE IF EXISTS `role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role` (
  `role_id` int NOT NULL AUTO_INCREMENT,
  `role_name` varchar(100) NOT NULL,
  `description` text,
  PRIMARY KEY (`role_id`),
  UNIQUE KEY `role_name` (`role_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `staff_certificate`
--

DROP TABLE IF EXISTS `staff_certificate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `staff_certificate` (
  `nurse_id` int NOT NULL,
  `certificate_type_id` int NOT NULL,
  `issue_date` date NOT NULL,
  `expiry_date` date NOT NULL,
  `status` enum('Valid','Expired') NOT NULL DEFAULT 'Valid',
  `file_path` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`nurse_id`,`certificate_type_id`),
  KEY `fk_sc_type` (`certificate_type_id`),
  CONSTRAINT `fk_sc_nurse` FOREIGN KEY (`nurse_id`) REFERENCES `nursing_staff` (`nurse_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_sc_type` FOREIGN KEY (`certificate_type_id`) REFERENCES `certificate_type` (`certificate_type_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `staff_training`
--

DROP TABLE IF EXISTS `staff_training`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `staff_training` (
  `nurse_id` int NOT NULL,
  `training_id` int NOT NULL,
  `completion_date` date DEFAULT NULL,
  `expiry_date` date DEFAULT NULL,
  `status` enum('Completed','Pending','Expired') NOT NULL DEFAULT 'Pending',
  PRIMARY KEY (`nurse_id`,`training_id`),
  KEY `fk_stafftraining_program` (`training_id`),
  CONSTRAINT `fk_stafftraining_nurse` FOREIGN KEY (`nurse_id`) REFERENCES `nursing_staff` (`nurse_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_stafftraining_program` FOREIGN KEY (`training_id`) REFERENCES `training_program` (`training_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `trainee`
--

DROP TABLE IF EXISTS `trainee`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `trainee` (
  `trainee_id` int NOT NULL AUTO_INCREMENT,
  `full_name` varchar(150) NOT NULL,
  `university` varchar(150) DEFAULT NULL,
  `training_type` enum('Intern','Student Nurse') NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  PRIMARY KEY (`trainee_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `training_program`
--

DROP TABLE IF EXISTS `training_program`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `training_program` (
  `training_id` int NOT NULL AUTO_INCREMENT,
  `training_name` varchar(150) NOT NULL,
  `mandatory` tinyint(1) NOT NULL,
  `description` text,
  PRIMARY KEY (`training_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `account_status` enum('Active','Suspended') NOT NULL DEFAULT 'Active',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `userrole`
--

DROP TABLE IF EXISTS `userrole`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `userrole` (
  `user_id` int NOT NULL,
  `role_id` int NOT NULL,
  PRIMARY KEY (`user_id`,`role_id`),
  KEY `fk_userrole_role` (`role_id`),
  CONSTRAINT `fk_userrole_role` FOREIGN KEY (`role_id`) REFERENCES `role` (`role_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_userrole_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-02-23  3:27:33
