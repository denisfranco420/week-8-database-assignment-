# 🏥 Clinic Booking System Database

## 📖 Overview
This project implements a **relational database schema** for a **Clinic Booking System** using **MySQL**.  
It models real-world healthcare workflows, including patients, doctors, clinics, appointments, services, payments, prescriptions, and reviews.

The database is designed with:
- **Primary & Foreign Keys** for relationships
- **One-to-One, One-to-Many, and Many-to-Many** relationships
- **Constraints** (NOT NULL, UNIQUE, CHECK)
- **Indexes** for performance optimization
- **Audit Logs** for accountability

---

## 📂 Project Structure
├── clinic_booking_db.sql # Main SQL script (schema + constraints)
├── seed.sql # Optional: insert example data
├── postman_collection.json # Optional: API testing collection (if backend provided)
└── README.md # Documentation


---

## 🚀 How to Run the Project

### 🔧 Prerequisites
- Install [MySQL 8+](https://dev.mysql.com/downloads/)
- Install [Git](https://git-scm.com/)
- (Optional) Install [Postman](https://www.postman.com/) for API testing if using a backend API

### 📥 Setup Instructions
1. Clone this repository:
   ```bash
   git clone https://github.com/your-username/clinic-booking-system-db.git
   cd clinic-booking-system-db


Run the SQL script to create the database and tables:

mysql -u root -p < clinic_booking_db.sql


(Optional) Insert seed data:

mysql -u root -p < seed.sql


Verify the database:

USE clinic_booking_db;
SHOW TABLES;

📌 Database Schema Highlights

Users Table – stores patients, doctors, staff (role-based)

Clinics Table – clinic locations

Doctors Table – doctor profiles (linked one-to-one with users)

Services Table – medical services offered

Doctor_Services Table – many-to-many mapping of doctors to services

Appointments Table – bookings between patients and doctors

Payments Table – payment tracking for appointments

Prescriptions Table – issued prescriptions

Reviews Table – patient feedback on doctors

Audit Logs Table – lightweight system audit

📡 API Endpoints (Example)

If connected to a backend API, typical endpoints could include:

👤 Users

GET /api/users → List all users

POST /api/users → Register a new user

GET /api/users/{id} → Get user details

PUT /api/users/{id} → Update user

DELETE /api/users/{id} → Delete user

🩺 Doctors

GET /api/doctors → List doctors with specialization

POST /api/doctors → Add doctor profile

GET /api/doctors/{id} → Get doctor details

GET /api/doctors/{id}/services → List services a doctor offers

📅 Appointments

POST /api/appointments → Book appointment

GET /api/appointments/{id} → View appointment details

PUT /api/appointments/{id}/status → Update appointment status

DELETE /api/appointments/{id} → Cancel appointment

💳 Payments

POST /api/payments → Record payment

GET /api/payments/{id} → Get payment details

🧪 Testing

Run SQL queries directly in MySQL Workbench or terminal.

(Optional) Import postman_collection.json into Postman to test API endpoints if you build a backend.

✨ Future Enhancements

Add authentication & RBAC (Role-Based Access Control)

Implement stored procedures & triggers for auto-updates

Build a REST API (Flask, Django, or Node.js) connected to this database

Deploy to cloud (AWS RDS, GCP, or Azure)

📜 License

This project is licensed under the MIT License.


---


