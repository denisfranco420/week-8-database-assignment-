CREATE DATABASE clinic_booking_db
USE clinic_booking_db;
-- Table: users
CREATE TABLE users (
  user_id INT AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  phone VARCHAR(30),
  role ENUM('patient','doctor','receptionist','admin') NOT NULL DEFAULT 'patient',
  password_hash VARCHAR(255) NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NULL ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;
-- Table: clinics
DROP TABLE IF EXISTS clinics;
CREATE TABLE clinics (
  clinic_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(200) NOT NULL,
  address VARCHAR(500),
  city VARCHAR(100),
  phone VARCHAR(30),
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;
-- Table: clinics
CREATE TABLE clinics (
  clinic_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(200) NOT NULL,
  address VARCHAR(500),
  city VARCHAR(100),
  phone VARCHAR(30),
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;
 --Table: doctors
CREATE TABLE doctors (
  doctor_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL UNIQUE, -- one-to-one link to users
  clinic_id INT,
  specialization VARCHAR(150),
  qualification VARCHAR(255),
  bio TEXT,
  availability_json JSON DEFAULT NULL, -- (optional) structured availability
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(user_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (clinic_id) REFERENCES clinics(clinic_id)
    ON DELETE SET NULL
    ON UPDATE CASCADE
) ENGINE=InnoDB;
-- Table: services
CREATE TABLE services (
  service_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(150) NOT NULL,
  description TEXT,
  base_price DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  duration_minutes INT NOT NULL DEFAULT 30, -- expected duration
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY ux_service_name (name)
) ENGINE=InnoDB;
-- Table: doctor_services (many-to-many)
CREATE TABLE doctor_services (
  doctor_id INT NOT NULL,
  service_id INT NOT NULL,
  custom_price DECIMAL(10,2) DEFAULT NULL, -- if doctor charges different price
  PRIMARY KEY (doctor_id, service_id),
  FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (service_id) REFERENCES services(service_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB;
-- Table: appointments
DROP TABLE IF EXISTS appointments;
CREATE TABLE appointments (
  appointment_id INT AUTO_INCREMENT PRIMARY KEY,
  patient_id INT NOT NULL, -- references users.user_id (role patient)
  doctor_id INT NOT NULL, -- references doctors.doctor_id
  clinic_id INT NOT NULL,
  service_id INT NOT NULL,
  scheduled_start DATETIME NOT NULL,
  scheduled_end DATETIME NOT NULL,
  status ENUM('pending','confirmed','completed','cancelled') NOT NULL DEFAULT 'pending',
  notes TEXT,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NULL ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (patient_id) REFERENCES users(user_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (clinic_id) REFERENCES clinics(clinic_id)
    ON DELETE SET 
    ON UPDATE CASCADE,
  FOREIGN KEY (service_id) REFERENCES services(service_id)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  INDEX idx_sched_start (scheduled_start),
  INDEX idx_patient (patient_id)
) ENGINE=InnoDB;
-- Table: payments
CREATE TABLE payments (
  payment_id INT AUTO_INCREMENT PRIMARY KEY,
  appointment_id INT NOT NULL,
  amount DECIMAL(10,2) NOT NULL,
  method ENUM('cash','card','mobile_money','insurance') NOT NULL,
  status ENUM('pending','paid','failed','refunded') NOT NULL DEFAULT 'pending',
  transaction_ref VARCHAR(255),
  paid_at DATETIME NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  INDEX idx_payment_appointment (appointment_id)
) ENGINE=InnoDB;
-- Table: prescriptions
CREATE TABLE prescriptions (
  prescription_id INT AUTO_INCREMENT PRIMARY KEY,
  appointment_id INT NOT NULL UNIQUE,
  issued_by_doctor_id INT,
  content TEXT NOT NULL, -- prescription details
  issued_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (issued_by_doctor_id) REFERENCES doctors(doctor_id)
    ON DELETE SET NULL
    ON UPDATE CASCADE
) ENGINE=InnoDB;
-- Table: reviews
CREATE TABLE reviews (
  review_id INT AUTO_INCREMENT PRIMARY KEY,
  doctor_id INT NOT NULL,
  patient_id INT NOT NULL,
  rating TINYINT NOT NULL CHECK (rating BETWEEN 1 AND 5),
  comment TEXT,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (patient_id) REFERENCES users(user_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  UNIQUE KEY ux_patient_doctor (doctor_id, patient_id)
) ENGINE=InnoDB;
-- Table: audit_logs
CREATE TABLE audit_logs (
  log_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NULL,
  action VARCHAR(200) NOT NULL,
  meta JSON NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(user_id)
    ON DELETE SET NULL
    ON UPDATE CASCADE
) ENGINE=InnoDB;