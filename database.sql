-- =============================================================================
-- SMANFUMA Digital Learning database schema
-- MySQL 8.0+
--
-- This file creates a fresh database. Existing installations should back up
-- their database first, then apply the teacher_id migration separately.
-- Do not put Dapodik/student records or production credentials in this file.
-- =============================================================================

CREATE DATABASE IF NOT EXISTS `smanfuma_lms`
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE `smanfuma_lms`;

CREATE TABLE IF NOT EXISTS `school_branding` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `school_name` VARCHAR(150) NOT NULL DEFAULT 'Smanfuma',
  `tagline` VARCHAR(150) NOT NULL DEFAULT 'Digital Learning',
  `logo_data` LONGTEXT NULL,
  `poster1_data` LONGTEXT NULL,
  `poster2_data` LONGTEXT NULL,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `school_branding` (`id`, `school_name`, `tagline`)
VALUES (1, 'Smanfuma', 'Digital Learning')
ON DUPLICATE KEY UPDATE `school_name` = VALUES(`school_name`);

CREATE TABLE IF NOT EXISTS `user_profiles` (
  `role` VARCHAR(20) NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  `role_title` VARCHAR(100) NULL,
  `class_name` VARCHAR(50) NULL,
  `avatar` LONGTEXT NULL,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`role`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `user_profiles` (`role`, `name`, `role_title`, `class_name`)
VALUES
  ('guru', 'Guru SMAN 1 Kebakkramat', 'Guru / Pendidik', NULL),
  ('siswa', 'Peserta Didik', 'Siswa', NULL)
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`);

CREATE TABLE IF NOT EXISTS `teachers` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nama` VARCHAR(150) NOT NULL,
  `nip` VARCHAR(50) NOT NULL,
  `jk` VARCHAR(10) NULL,
  `status` VARCHAR(50) NULL,
  `role` VARCHAR(50) NOT NULL DEFAULT 'Guru',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_teachers_nip` (`nip`),
  KEY `idx_teachers_nama` (`nama`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `students` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nama` VARCHAR(150) NOT NULL,
  `nis` VARCHAR(50) NOT NULL DEFAULT '',
  `nipd` VARCHAR(50) NULL,
  `nisn` VARCHAR(50) NULL,
  `jk` VARCHAR(10) NULL,
  `rombel` VARCHAR(50) NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_students_nis` (`nis`),
  KEY `idx_students_nipd` (`nipd`),
  KEY `idx_students_nisn` (`nisn`),
  KEY `idx_students_nama` (`nama`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `subjects` (
  `id` VARCHAR(50) NOT NULL,
  `name` VARCHAR(120) NOT NULL,
  `description` TEXT NULL,
  `icon` VARCHAR(50) NOT NULL DEFAULT 'fa-book-open',
  `color` VARCHAR(30) NOT NULL DEFAULT '#2563eb',
  `teacher_id` VARCHAR(50) NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_subjects_teacher_created` (`teacher_id`, `created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `materials` (
  `id` VARCHAR(50) NOT NULL,
  `subject_id` VARCHAR(50) NOT NULL,
  `title` VARCHAR(200) NOT NULL,
  `type` ENUM('materi', 'video') NOT NULL DEFAULT 'materi',
  `link` TEXT NULL,
  `file_name` VARCHAR(255) NULL,
  `file_size` VARCHAR(50) NULL,
  `file_data` LONGTEXT NULL,
  `description` TEXT NULL,
  `created_at` DATE NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_materials_subject_created` (`subject_id`, `created_at`),
  CONSTRAINT `fk_materials_subject`
    FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `tasks` (
  `id` VARCHAR(50) NOT NULL,
  `subject_id` VARCHAR(50) NOT NULL,
  `title` VARCHAR(200) NOT NULL,
  `description` TEXT NULL,
  `student_name` VARCHAR(100) NOT NULL,
  `student_class` VARCHAR(50) NULL,
  `file_name` VARCHAR(255) NOT NULL,
  `file_size` VARCHAR(50) NULL,
  `file_data` LONGTEXT NULL,
  `submitted_at` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_tasks_subject_submitted` (`subject_id`, `submitted_at`),
  CONSTRAINT `fk_tasks_subject`
    FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `evaluations` (
  `id` VARCHAR(50) NOT NULL,
  `eval_type` ENUM('pre', 'post') NOT NULL,
  `title` VARCHAR(200) NOT NULL,
  `subject` VARCHAR(120) NOT NULL,
  `grade` VARCHAR(50) NOT NULL,
  `link` TEXT NULL,
  `file_name` VARCHAR(255) NULL,
  `file_size` VARCHAR(50) NULL,
  `file_data` LONGTEXT NULL,
  `teacher_id` VARCHAR(50) NULL,
  `created_at` DATE NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_evaluations_teacher_created` (`teacher_id`, `created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `announcements` (
  `id` VARCHAR(50) NOT NULL,
  `title` VARCHAR(200) NOT NULL,
  `category` VARCHAR(50) NOT NULL DEFAULT 'Informasi',
  `body` TEXT NOT NULL,
  `date` DATE NOT NULL,
  `teacher_id` VARCHAR(50) NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_announcements_teacher_date` (`teacher_id`, `date`, `created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `announcement_files` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `announcement_id` VARCHAR(50) NOT NULL,
  `file_name` VARCHAR(255) NOT NULL,
  `file_size` VARCHAR(50) NULL,
  `file_data` LONGTEXT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_announcement_files_announcement` (`announcement_id`),
  CONSTRAINT `fk_announcement_files_announcement`
    FOREIGN KEY (`announcement_id`) REFERENCES `announcements` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `progress_logs` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `resource_id` VARCHAR(50) NOT NULL,
  `title` VARCHAR(200) NOT NULL,
  `type` VARCHAR(50) NOT NULL,
  `subject` VARCHAR(120) NULL,
  `accessed_at` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_progress_logs_resource` (`resource_id`),
  KEY `idx_progress_logs_id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Do not seed example tasks here: tasks require an existing subject due to
-- the foreign-key constraint. Load real school data through a protected import.
-- Avoid placing private student/teacher records in a public Git repository.
