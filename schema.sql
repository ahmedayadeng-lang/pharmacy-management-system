-- Database schema for pharmacy management system
-- Usage: mysql -u root -p < schema.sql
CREATE DATABASE IF NOT EXISTS pharmacy_db;
USE pharmacy_db;

CREATE TABLE customers (
  customer_id int NOT NULL AUTO_INCREMENT,
  name varchar(100) NOT NULL,
  phone varchar(15) DEFAULT NULL,
  email varchar(100) DEFAULT NULL,
  address text DEFAULT NULL,
  age int DEFAULT NULL,
  loyalty_points int DEFAULT 0,
  created_at timestamp NOT NULL DEFAULT current_timestamp(),
  updated_at timestamp NULL DEFAULT NULL ON UPDATE current_timestamp(),
  PRIMARY KEY (customer_id),
  UNIQUE KEY email (email),
  KEY name (name)
);

CREATE TABLE employees (
  employee_id int NOT NULL AUTO_INCREMENT,
  name varchar(100) NOT NULL,
  role varchar(50) DEFAULT NULL,
  phone varchar(15) DEFAULT NULL,
  email varchar(100) DEFAULT NULL,
  salary decimal(10, 2) DEFAULT NULL,
  hire_date date DEFAULT NULL,
  created_at timestamp NOT NULL DEFAULT current_timestamp(),
  updated_at timestamp NULL DEFAULT NULL ON UPDATE current_timestamp(),
  PRIMARY KEY (employee_id),
  UNIQUE KEY email (email),
  KEY name (name),
  KEY role (role)
);

CREATE TABLE suppliers (
  supplier_id int NOT NULL AUTO_INCREMENT,
  name varchar(100) NOT NULL,
  contact_person varchar(85) DEFAULT NULL,
  phone varchar(15) DEFAULT NULL,
  email varchar(100) DEFAULT NULL,
  country varchar(50) DEFAULT NULL,
  payment_terms varchar(100) DEFAULT NULL,
  created_at timestamp NOT NULL DEFAULT current_timestamp(),
  updated_at timestamp NULL DEFAULT NULL ON UPDATE current_timestamp(),
  PRIMARY KEY (supplier_id),
  UNIQUE KEY email (email),
  KEY name (name)
);

CREATE TABLE medicines (
  medicine_id int NOT NULL AUTO_INCREMENT,
  name varchar(100) NOT NULL,
  quantity int NOT NULL DEFAULT 0,
  price decimal(10, 2) NOT NULL,
  expiry_date date DEFAULT NULL,
  manufacturer varchar(100) DEFAULT NULL,
  batch_number varchar(50) DEFAULT NULL,
  category varchar(50) DEFAULT NULL,
  description text DEFAULT NULL,
  supplier_id int DEFAULT NULL,
  created_at timestamp NOT NULL DEFAULT current_timestamp(),
  updated_at timestamp NULL DEFAULT NULL ON UPDATE current_timestamp(),
  PRIMARY KEY (medicine_id),
  KEY supplier_id (supplier_id),
  KEY name (name),
  KEY category (category),
  KEY expiry_date (expiry_date)
);

CREATE TABLE stock (
  stock_id int NOT NULL AUTO_INCREMENT,
  medicine_id int NOT NULL,
  quantity_in_stock int NOT NULL,
  reorder_level int NOT NULL,
  last_updated date DEFAULT NULL,
  created_at timestamp NOT NULL DEFAULT current_timestamp(),
  updated_at timestamp NULL DEFAULT NULL ON UPDATE current_timestamp(),
  PRIMARY KEY (stock_id),
  KEY medicine_id (medicine_id)
);

CREATE TABLE orders (
  order_id int NOT NULL AUTO_INCREMENT,
  customer_id int DEFAULT NULL,
  employee_id int DEFAULT NULL,
  order_type varchar(50) DEFAULT NULL,
  total_amount decimal(10, 2) NOT NULL,
  order_date timestamp NOT NULL DEFAULT current_timestamp(),
  created_at timestamp NOT NULL DEFAULT current_timestamp(),
  updated_at timestamp NULL DEFAULT NULL ON UPDATE current_timestamp(),
  PRIMARY KEY (order_id),
  KEY customer_id (customer_id),
  KEY employee_id (employee_id)
);

CREATE TABLE order_items (
  item_id int NOT NULL AUTO_INCREMENT,
  order_id int NOT NULL,
  medicine_id int NOT NULL,
  quantity int NOT NULL,
  unit_price decimal(10, 2) NOT NULL,
  subtotal decimal(10, 2) NOT NULL,
  created_at timestamp NOT NULL DEFAULT current_timestamp(),
  updated_at timestamp NULL DEFAULT NULL ON UPDATE current_timestamp(),
  PRIMARY KEY (item_id),
  KEY order_id (order_id),
  KEY medicine_id (medicine_id)
);

CREATE TABLE prescriptions (
  prescription_id int NOT NULL AUTO_INCREMENT,
  customer_id int NOT NULL,
  doctor_name varchar(100) DEFAULT NULL,
  doctor_license varchar(50) DEFAULT NULL,
  issue_date date NOT NULL,
  expiry_date date DEFAULT NULL,
  notes text DEFAULT NULL,
  created_at timestamp NOT NULL DEFAULT current_timestamp(),
  updated_at timestamp NULL DEFAULT NULL ON UPDATE current_timestamp(),
  PRIMARY KEY (prescription_id),
  KEY customer_id (customer_id)
);

CREATE TABLE prescription_items (
  item_id int NOT NULL AUTO_INCREMENT,
  prescription_id int NOT NULL,
  medicine_id int NOT NULL,
  quantity int NOT NULL,
  dosage varchar(50) DEFAULT NULL,
  instructions text DEFAULT NULL,
  created_at timestamp NOT NULL DEFAULT current_timestamp(),
  updated_at timestamp NULL DEFAULT NULL ON UPDATE current_timestamp(),
  PRIMARY KEY (item_id),
  KEY prescription_id (prescription_id),
  KEY medicine_id (medicine_id)
);

-- Foreign key constraints
ALTER TABLE medicines
ADD FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
ON DELETE SET NULL 
ON UPDATE CASCADE;

ALTER TABLE orders
ADD FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE orders
ADD FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
ON DELETE SET NULL
ON UPDATE CASCADE;

ALTER TABLE order_items
ADD FOREIGN KEY (order_id) REFERENCES orders(order_id)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE order_items
ADD FOREIGN KEY (medicine_id) REFERENCES medicines(medicine_id)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE prescriptions
ADD FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE prescription_items
ADD FOREIGN KEY (prescription_id) REFERENCES prescriptions(prescription_id)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE prescription_items
ADD FOREIGN KEY (medicine_id) REFERENCES medicines(medicine_id)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE stock
ADD FOREIGN KEY (medicine_id) REFERENCES medicines(medicine_id)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- =============================================
-- INSERT DATA - MUST FOLLOW THIS ORDER DUE TO FOREIGN KEYS
-- =============================================

-- 1. Suppliers (no dependencies)
INSERT INTO suppliers (name, contact_person, phone, email, country, payment_terms) VALUES
('Dar Alshifa', 'Ahmed', '0781111111', 'ahmed@darshifa.com', 'Iraq', 'Net 30'),
('Future Pharmacy', 'Layla', '0782222222', 'layla@futureph.com', 'Iraq', 'Net 15'),
('Arab Meds', 'Omar', '0783333333', 'omar@arabmeds.com', 'Iraq', 'Net 45'),
('Medical Top', 'Rana', '0784444444', 'rana@medtop.com', 'Iraq', 'Net 30'),
('Noor Health', 'Yousef', '0785555555', 'yousef@noorhealth.com', 'Iraq', 'Net 65'),
('Gulf Shifa', 'Huda', '0786666666', 'huda@gulfshifa.com', 'Iraq', 'Net 30'),
('Bayt Tibb', 'Hassan', '0787777777', 'hassan@bayttibb.com', 'Iraq', 'Net 15'),
('Dawa & Shifa', 'Fatima', '0788888888', 'fatima@dawashifa.com', 'Iraq', 'Net 30'),
('Health Bridge', 'Zainab', '0789999999', 'zainab@healthbridge.com', 'Iraq', 'Net 45'),
('Pharma Trust', 'Ali', '0781234567', 'ali@pharmatrust.com', 'Iraq', 'Net 30'),
('MediCare Iraq', 'Adnan', '0787654321', 'adnan@medicareiq.com', 'Iraq', 'Net 30'),
('Pharma Solutions', 'Lamia', '0788765432', 'lamia@pharmasol.com', 'Iraq', 'Net 45'),
('Gulf Medical', 'Fahad', '0789876543', 'fahad@gulfmed.com', 'Iraq', 'Net 60'),
('Health Plus', 'Hanan', '0781122334', 'hanan@healthplus.com', 'Iraq', 'Net 15'),
('MediWorld', 'Walid', '0782233445', 'walid@mediworld.com', 'Iraq', 'Net 30');

-- 2. Customers (no dependencies)
INSERT INTO customers (name, phone, email, address, age, loyalty_points) VALUES
('Ammar Salman', '0791111111', 'ammar@mail.com', 'Baghdad', 35, 100),
('Mona Ali', '0792222222', 'mona@mail.com', 'Basrah', 28, 50),
('Zaid Ahmed', '0793333333', 'zaid@mail.com', 'Erbil', 42, 75),
('Sara Hussein', '0794444444', 'sara@mail.com', 'Mosul', 31, 120),
('Khalid Abbas', '0795555555', 'khalid@mail.com', 'Najaf', 25, 30),
('Lina Majid', '0796666666', 'lina@mail.com', 'Kirkuk', 19, 60),
('Tariq Saeed', '0797777777', 'tariq@mail.com', 'Baghdad', 55, 200),
('Nour Fadel', '0798888888', 'nour@mail.com', 'Sulaymaniyah', 22, 80),
('Bilal Karim', '0799999999', 'bilal@mail.com', 'Basrah', 38, 90),
('Dina Zaki', '0791234567', 'dina@mail.com', 'Baghdad', 29, 110),
('Ali Hassan', '0797654321', 'ali.hassan@mail.com', 'Baghdad', 42, 75),
('Layla Mohammed', '0798765432', 'layla.m@mail.com', 'Basrah', 29, 110),
('Omar Khalid', '0799876543', 'omar.k@mail.com', 'Erbil', 35, 150),
('Huda Ahmed', '0791122334', 'huda.a@mail.com', 'Mosul', 27, 60),
('Karim Faisal', '0792233445', 'karim.f@mail.com', 'Najaf', 45, 200);

-- 3. Employees (no dependencies)
INSERT INTO employees (name, role, phone, email, salary, hire_date) VALUES
('Ahmed Kareem', 'Pharmacist', '0781111111', 'ahmed@pharmacy.com', 900.00, '2020-01-15'),
('Hanan Ali', 'Assistant', '0782222222', 'hanan@pharmacy.com', 550.00, '2021-03-10'),
('Yousef Saad', 'Cashier', '0783333333', 'yousef@pharmacy.com', 450.00, '2022-06-01'),
('Rana Nabil', 'Pharmacist', '0784444444', 'rana@pharmacy.com', 1000.00, '2019-09-12'),
('Omar Talib', 'Cleaner', '0785555555', 'omar@pharmacy.com', 300.00, '2023-01-20'),
('Fatima Hassan', 'Manager', '0786666666', 'fatima@pharmacy.com', 1200.00, '2018-05-05'),
('Ali Zaid', 'Security', '0787777777', 'ali@pharmacy.com', 400.00, '2020-10-10'),
('Zainab Hadi', 'Pharmacist', '0788888888', 'zainab@pharmacy.com', 950.00, '2022-12-12'),
('Hassan Qasim', 'Assistant', '0789999999', 'hassan@pharmacy.com', 570.00, '2021-08-08'),
('Salma Mahdi', 'Cashier', '0781234567', 'salma@pharmacy.com', 430.00, '2024-02-02'),
('Samir Adil', 'Pharmacist', '0787654321', 'samir.a@pharmacy.com', 920.00, '2021-02-15'),
('Lina Fawzi', 'Assistant', '0788765432', 'lina.f@pharmacy.com', 580.00, '2022-04-10'),
('Faisal Hadi', 'Cashier', '0789876543', 'faisal.h@pharmacy.com', 460.00, '2023-07-01'),
('Hanan Majid', 'Pharmacist', '0781122334', 'hanan.m@pharmacy.com', 1050.00, '2020-10-12'),
('Waleed Naji', 'Cleaner', '0782233445', 'waleed.n@pharmacy.com', 320.00, '2024-02-20');

-- 4. Medicines (depends on suppliers)
INSERT INTO medicines (name, quantity, price, expiry_date, manufacturer, batch_number, category, description, supplier_id) VALUES
('Paracetamol 500mg', 200, 1.25, '2026-12-31', 'GSK', 'GB12345', 'Painkiller', 'For fever and mild pain', 1),
('Amoxicillin 500mg', 150, 2.50, '2025-08-15', 'Pfizer', 'A98765', 'Antibiotic', 'Broad spectrum antibiotic', 2),
('Ibuprofen 400mg', 180, 1.75, '2024-05-10', 'Sanofi', 'IB3042', 'Painkiller', 'Inflammation relief', 1),
('Cetirizine 10mg', 120, 0.90, '2026-11-01', 'Novartis', 'CT2022', 'Antihistamine', 'Allergy relief', 2),
('Metformin 850mg', 130, 3.00, '2027-01-20', 'Merck', 'M85087', 'Diabetes', 'Blood sugar control', 3),
('Cough Syrup', 50, 1.00, '2025-06-30', 'Hikma', 'HCX001', 'Cough', 'For dry cough', 4),
('Vitamin B12 Injection', 10, 20.00, '2025-02-28', 'AbbVie', 'RJN888', 'Injection', 'Vitamin supplement', 5),
('Vitamin C 1000mg', 100, 0.50, '2026-09-01', 'Bayer', 'VC999', 'Supplement', 'Immune support', 6),
('Aspirin 100mg', 250, 0.40, '2027-03-15', 'GSK', 'AS100', 'Antiplatelet', 'Blood thinner', 1),
('Omeprazole 20mg', 80, 2.25, '2026-05-15', 'AstraZeneca', 'OM202401', 'Antacid', 'For acid reflux', 7),
('Atorvastatin 40mg', 60, 4.50, '2025-11-30', 'Pfizer', 'AT402024', 'Cholesterol', 'Lowers cholesterol', 8),
('Metoprolol 50mg', 90, 1.80, '2026-08-20', 'Novartis', 'MT502024', 'Cardiac', 'Beta blocker', 9),
('Ciprofloxacin 500mg', 70, 3.25, '2025-09-15', 'Bayer', 'CP5002024', 'Antibiotic', 'For infections', 10),
('Diazepam 5mg', 40, 1.50, '2026-03-31', 'Roche', 'DZ52024', 'Anxiolytic', 'For anxiety', 11),
('Losartan 50mg', 110, 2.75, '2026-07-15', 'Merck', 'LS502024', 'Hypertension', 'Blood pressure', 12);

-- 5. Stock (depends on medicines)
INSERT INTO stock (medicine_id, quantity_in_stock, reorder_level, last_updated) VALUES
(1, 200, 50, '2024-04-01'),
(2, 150, 30, '2024-04-01'),
(3, 180, 40, '2024-04-01'),
(4, 120, 25, '2024-04-01'),
(5, 130, 20, '2024-04-01'),
(6, 50, 10, '2024-04-01'),
(7, 10, 5, '2024-04-01'),
(8, 100, 25, '2024-04-01'),
(9, 250, 30, '2024-04-01'),
(10, 80, 20, '2024-04-01'),
(11, 60, 15, '2024-04-01'),
(12, 90, 18, '2024-04-01'),
(13, 70, 14, '2024-04-01'),
(14, 40, 8, '2024-04-01'),
(15, 110, 22, '2024-04-01');

-- 6. Prescriptions (depends on customers)
INSERT INTO prescriptions (customer_id, doctor_name, doctor_license, issue_date, expiry_date, notes) VALUES
(1, 'Dr. Ahmed', 'MD12345', '2024-04-01', '2024-05-01', 'Take after meals'),
(2, 'Dr. Sara', 'MD23456', '2024-04-02', '2024-05-02', 'Avoid alcohol'),
(3, 'Dr. Omar', 'MD34567', '2024-04-03', '2024-05-03', '3 times daily'),
(4, 'Dr. Fatima', 'MD45678', '2024-04-04', '2024-05-04', 'Finish full dose'),
(5, 'Dr. Ali', 'MD56789', '2024-04-05', '2024-05-05', 'No sugar'),
(6, 'Dr. Laila', 'MD67890', '2024-04-06', '2024-05-06', 'Monitor BP'),
(7, 'Dr. Hassan', 'MD78901', '2024-04-07', '2024-05-07', 'Before sleeping'),
(8, 'Dr. Mona', 'MD89012', '2024-04-08', '2024-05-08', 'Apply on skin'),
(9, 'Dr. Yousef', 'MD90123', '2024-04-09', '2024-05-09', 'Use for 5 days'),
(10, 'Dr. Zainab', 'MD01234', '2024-04-10', '2024-05-10', 'Take with water'),
(11, 'Dr. Samir', 'MD12346', '2024-04-11', '2024-05-11', 'Take with food'),
(12, 'Dr. Lina', 'MD23457', '2024-04-12', '2024-05-12', 'Avoid dairy'),
(13, 'Dr. Faisal', 'MD34568', '2024-04-13', '2024-05-13', 'Morning dose'),
(14, 'Dr. Hanan', 'MD45679', '2024-04-14', '2024-05-14', 'Evening dose'),
(15, 'Dr. Waleed', 'MD56780', '2024-04-15', '2024-05-15', 'Monitor sugar');

-- 7. Orders (depends on customers and employees)
INSERT INTO orders (customer_id, employee_id, order_type, total_amount, order_date) VALUES
(1, 1, 'Prescription', 12.50, '2024-04-01 09:00:00'),
(2, 2, 'OTC', 5.75, '2024-04-02 10:30:00'),
(3, 3, 'Prescription', 8.25, '2024-04-03 11:45:00'),
(4, 4, 'OTC', 3.50, '2024-04-04 14:20:00'),
(5, 5, 'Prescription', 15.00, '2024-04-05 16:05:00'),
(6, 6, 'OTC', 7.80, '2024-04-06 08:15:00'),
(7, 7, 'Prescription', 22.50, '2024-04-07 12:30:00'),
(8, 8, 'OTC', 4.25, '2024-04-08 15:45:00'),
(9, 9, 'Prescription', 9.75, '2024-04-09 17:00:00'),
(10, 10, 'OTC', 6.50, '2024-04-10 10:15:00'),
(11, 11, 'Prescription', 18.75, '2024-04-11 09:00:00'),
(12, 12, 'OTC', 7.20, '2024-04-12 10:15:00'),
(13, 13, 'Prescription', 25.50, '2024-04-13 11:30:00'),
(14, 14, 'OTC', 4.80, '2024-04-14 14:45:00'),
(15, 15, 'Prescription', 32.25, '2024-04-15 16:00:00');

-- 8. Order Items (depends on orders and medicines)
INSERT INTO order_items (order_id, medicine_id, quantity, unit_price, subtotal) VALUES
(1, 1, 2, 1.25, 2.50),
(1, 2, 1, 2.50, 2.50),
(1, 3, 2, 1.75, 3.50),
(2, 4, 3, 0.90, 2.70),
(2, 9, 2, 0.40, 0.80),
(3, 5, 1, 3.00, 3.00),
(3, 7, 1, 20.00, 20.00),
(4, 1, 1, 1.25, 1.25),
(4, 3, 1, 1.75, 1.75),
(5, 2, 2, 2.50, 5.00),
(5, 4, 1, 0.90, 0.90),
(5, 9, 5, 0.40, 2.00),
(6, 3, 3, 1.75, 5.25),
(7, 7, 1, 20.00, 20.00),
(8, 1, 1, 1.25, 1.25),
(8, 4, 1, 0.90, 0.90),
(9, 2, 1, 2.50, 2.50),
(9, 3, 2, 1.75, 3.50),
(10, 9, 10, 0.40, 4.00),
(10, 4, 2, 0.90, 1.80),
(11, 10, 2, 2.25, 4.50),
(11, 11, 1, 4.50, 4.50),
(12, 12, 3, 1.80, 5.40),
(13, 13, 1, 3.25, 3.25),
(14, 14, 2, 1.50, 3.00),
(15, 15, 1, 2.75, 2.75);

-- 9. Prescription Items (depends on prescriptions and medicines)
INSERT INTO prescription_items (prescription_id, medicine_id, quantity, dosage, instructions) VALUES
(1, 1, 30, '500mg', 'Once daily'),
(1, 2, 20, '500mg', 'Twice daily'),
(2, 3, 15, '400mg', 'As needed'),
(3, 4, 30, '10mg', 'Once at night'),
(4, 5, 60, '850mg', 'Twice daily'),
(5, 1, 20, '500mg', 'Every 6 hours'),
(6, 2, 15, '500mg', 'Three times daily'),
(7, 7, 1, 'Injection', 'One time only'),
(8, 9, 30, '100mg', 'Once daily'),
(9, 3, 10, '400mg', 'When in pain'),
(10, 4, 20, '10mg', 'Before sleep'),
(11, 10, 30, '20mg', 'Once daily before breakfast'),
(12, 11, 28, '40mg', 'At bedtime'),
(13, 12, 15, '50mg', 'Twice daily'),
(14, 13, 10, '500mg', 'Every 12 hours'),
(15, 14, 20, '5mg', 'As needed for anxiety');