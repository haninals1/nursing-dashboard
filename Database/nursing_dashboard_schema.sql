/* =========================================================
Nursing Dashboard Database Schema
   ========================================================= */

-- ---------------------------------------------------------
-- 1) Create and select database
-- ---------------------------------------------------------
CREATE DATABASE IF NOT EXISTS nursing_dashboard;
USE nursing_dashboard;

-- =========================================================
-- 2) Core Tables (Users & Roles)
-- =========================================================

-- Users table
CREATE TABLE `User` (
  user_id INT AUTO_INCREMENT PRIMARY KEY,
  email VARCHAR(255) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  account_status ENUM('Active','Suspended') NOT NULL DEFAULT 'Active',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Roles table
CREATE TABLE `Role` (
  role_id INT AUTO_INCREMENT PRIMARY KEY,
  role_name VARCHAR(100) NOT NULL UNIQUE,
  description TEXT
) ENGINE=InnoDB;

-- User ↔ Role relationship (many-to-many)
CREATE TABLE `UserRole` (
  user_id INT NOT NULL,
  role_id INT NOT NULL,
  PRIMARY KEY (user_id, role_id),

  CONSTRAINT fk_userrole_user
    FOREIGN KEY (user_id) REFERENCES `User`(user_id)
    ON UPDATE CASCADE ON DELETE CASCADE,

  CONSTRAINT fk_userrole_role
    FOREIGN KEY (role_id) REFERENCES `Role`(role_id)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- =========================================================
-- 3) Staff & Trainees
-- =========================================================

-- Nursing staff table
CREATE TABLE `Nursing_staff` (
  nurse_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNIQUE,
  full_name VARCHAR(150) NOT NULL,
  unit VARCHAR(100) NOT NULL,
  job_title VARCHAR(120) NOT NULL,
  qualification VARCHAR(100),
  license_number VARCHAR(100) UNIQUE,
  status ENUM('Active','On Leave','Terminated') NOT NULL DEFAULT 'Active',
  hire_date DATE,

  CONSTRAINT fk_nurse_user
    FOREIGN KEY (user_id) REFERENCES `User`(user_id)
    ON UPDATE CASCADE
    ON DELETE SET NULL
) ENGINE=InnoDB;

-- Trainees table
CREATE TABLE `Trainee` (
  trainee_id INT AUTO_INCREMENT PRIMARY KEY,
  full_name VARCHAR(150) NOT NULL,
  university VARCHAR(150),
  training_type ENUM('Intern','Student Nurse') NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL
) ENGINE=InnoDB;

-- =========================================================
-- 4) Certificates
-- =========================================================

-- Certificate types
CREATE TABLE `Certificate_type` (
  certificate_type_id INT AUTO_INCREMENT PRIMARY KEY,
  certificate_name VARCHAR(150) NOT NULL,
  validity_months INT NOT NULL
) ENGINE=InnoDB;

-- Staff certificates
CREATE TABLE `Staff_certificate` (
  nurse_id INT NOT NULL,
  certificate_type_id INT NOT NULL,
  issue_date DATE NOT NULL,
  expiry_date DATE NOT NULL,
  status ENUM('Valid','Expired') NOT NULL DEFAULT 'Valid',
  file_path VARCHAR(255),

  PRIMARY KEY (nurse_id, certificate_type_id),

  CONSTRAINT fk_sc_nurse
    FOREIGN KEY (nurse_id) REFERENCES `Nursing_staff`(nurse_id)
    ON UPDATE CASCADE ON DELETE CASCADE,

  CONSTRAINT fk_sc_type
    FOREIGN KEY (certificate_type_id) REFERENCES `Certificate_type`(certificate_type_id)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- =========================================================
-- 5) Training
-- =========================================================

-- Training programs
CREATE TABLE `Training_program` (
  training_id INT AUTO_INCREMENT PRIMARY KEY,
  training_name VARCHAR(150) NOT NULL,
  mandatory BOOLEAN NOT NULL,
  description TEXT
) ENGINE=InnoDB;

-- Staff training records
CREATE TABLE `Staff_training` (
  nurse_id INT NOT NULL,
  training_id INT NOT NULL,
  completion_date DATE,
  expiry_date DATE,
  status ENUM('Completed','Pending','Expired') NOT NULL DEFAULT 'Pending',

  PRIMARY KEY (nurse_id, training_id),

  CONSTRAINT fk_stafftraining_nurse
    FOREIGN KEY (nurse_id) REFERENCES `Nursing_staff`(nurse_id)
    ON UPDATE CASCADE ON DELETE CASCADE,

  CONSTRAINT fk_stafftraining_program
    FOREIGN KEY (training_id) REFERENCES `Training_program`(training_id)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- =========================================================
-- 6) Requests & Approvals
-- =========================================================

-- Requests table
CREATE TABLE `Request` (
  request_id INT AUTO_INCREMENT PRIMARY KEY,
  nurse_id INT NOT NULL,
  request_type VARCHAR(100) NOT NULL,
  submission_date DATE NOT NULL,
  current_status ENUM('Pending','Approved','Rejected') NOT NULL DEFAULT 'Pending',

  CONSTRAINT fk_request_nurse
    FOREIGN KEY (nurse_id) REFERENCES `Nursing_staff`(nurse_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Request approvals
CREATE TABLE `Request_approval` (
  approval_id INT AUTO_INCREMENT PRIMARY KEY,
  request_id INT NOT NULL,
  approver_role ENUM('Supervisor','Assistant Director') NOT NULL,
  decision ENUM('Approved','Rejected','Pending') NOT NULL DEFAULT 'Pending',
  decision_date DATE,

  CONSTRAINT fk_approval_request
    FOREIGN KEY (request_id) REFERENCES `Request`(request_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE
) ENGINE=InnoDB;

-- =========================================================
-- 7) Staffing & Performance
-- =========================================================

-- Ratio rules
CREATE TABLE `Ratio_rule` (
  ratio_id INT AUTO_INCREMENT PRIMARY KEY,
  unit VARCHAR(100) NOT NULL,
  ratio_value DECIMAL(5,2) NOT NULL,
  safe_limit INT NOT NULL
) ENGINE=InnoDB;

-- Daily assignments
CREATE TABLE `Daily_assignment` (
  assignment_id INT AUTO_INCREMENT PRIMARY KEY,
  nurse_id INT NOT NULL,
  ratio_id INT NOT NULL,
  submission_date DATE NOT NULL,
  unit VARCHAR(100) NOT NULL,

  CONSTRAINT fk_daily_nurse
    FOREIGN KEY (nurse_id) REFERENCES `Nursing_staff`(nurse_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,

  CONSTRAINT fk_daily_ratio
    FOREIGN KEY (ratio_id) REFERENCES `Ratio_rule`(ratio_id)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Performance evaluations
CREATE TABLE `Performance_evaluation` (
  evaluation_id INT AUTO_INCREMENT PRIMARY KEY,
  nurse_id INT NOT NULL,
  score DECIMAL(6,2) NOT NULL,
  evaluation_date DATE NOT NULL,

  CONSTRAINT fk_perf_nurse
    FOREIGN KEY (nurse_id) REFERENCES `Nursing_staff`(nurse_id)
    ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- =========================================================
-- 8) KPI & Research
-- =========================================================

-- KPI table
CREATE TABLE `KPI` (
  kpi_id INT AUTO_INCREMENT PRIMARY KEY,
  kpi_name VARCHAR(150) NOT NULL,
  category VARCHAR(100) NOT NULL
) ENGINE=InnoDB;

-- Research projects
CREATE TABLE `Research_project` (
  project_id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(200) NOT NULL,
  status VARCHAR(50) NOT NULL,
  start_date DATE,
  end_date DATE
) ENGINE=InnoDB;

-- Evidence guidelines
CREATE TABLE `EvidenceGuideline` (
  guideline_id INT AUTO_INCREMENT PRIMARY KEY,
  project_id INT NOT NULL,
  title VARCHAR(200) NOT NULL,
  description TEXT,

  CONSTRAINT fk_guideline_project
    FOREIGN KEY (project_id) REFERENCES `Research_project`(project_id)
    ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- KPI values
CREATE TABLE `KPI_value` (
  kpi_value_id INT AUTO_INCREMENT PRIMARY KEY,
  kpi_id INT NOT NULL,
  unit VARCHAR(100),
  value DECIMAL(12,4) NOT NULL,
  record_date DATE NOT NULL,

  CONSTRAINT fk_kpivalue_kpi
    FOREIGN KEY (kpi_id) REFERENCES `KPI`(kpi_id)
    ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- =========================================================
-- 9) Verification Queries 
-- =========================================================

-- Show tables
SHOW TABLES;

-- Show foreign keys
SELECT
  TABLE_NAME,
  COLUMN_NAME,
  CONSTRAINT_NAME,
  REFERENCED_TABLE_NAME,
  REFERENCED_COLUMN_NAME
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'nursing_dashboard'
  AND REFERENCED_TABLE_NAME IS NOT NULL
ORDER BY TABLE_NAME, COLUMN_NAME;

-- =========================================
-- Test Queries: Verify tables and data
-- =========================================
SELECT * FROM User;
SELECT * FROM Role;
SELECT * FROM UserRole;
SELECT * FROM Nursing_staff;
SELECT * FROM Trainee;
SELECT * FROM Certificate_type;
SELECT * FROM Staff_certificate;
SELECT * FROM Training_program;
SELECT * FROM Staff_training;
SELECT * FROM Request;
SELECT * FROM Request_approval;
SELECT * FROM Ratio_rule;
SELECT * FROM Daily_assignment;
SELECT * FROM Performance_evaluation;
SELECT * FROM KPI;
SELECT * FROM Research_project;
SELECT * FROM EvidenceGuideline;
SELECT * FROM KPI_value;
