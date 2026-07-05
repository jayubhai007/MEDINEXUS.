
SET search_path TO medinexus;

-- ------------------------------------------------------------
-- 1. LOCATION  (6 rows)
-- ------------------------------------------------------------
INSERT INTO medinexus.location (pincode, city, state) VALUES
('380001', 'Ahmedabad',   'Gujarat'),
('382010', 'Gandhinagar', 'Gujarat'),
('395001', 'Surat',       'Gujarat'),
('380015', 'Ahmedabad',   'Gujarat'),
('380052', 'Ahmedabad',   'Gujarat'),
('390001', 'Vadodara',    'Gujarat');

-- ------------------------------------------------------------
-- 2. USERS  (9 rows: 3 patients + 3 doctors + 3 pharmacies)
-- ------------------------------------------------------------
INSERT INTO medinexus.users (pincode, email, password, reg_date, type) VALUES
('380001', 'arjun.mehta@gmail.com',       'hashed_pass_001', '2024-01-10', 'Patient'),
('382010', 'priya.sharma@gmail.com',      'hashed_pass_002', '2024-01-15', 'Patient'),
('395001', 'rohit.verma@gmail.com',       'hashed_pass_003', '2024-02-01', 'Patient'),
('380015', 'dr.kapoor@medinexus.com',     'hashed_pass_004', '2024-01-05', 'Doctor'),
('380052', 'dr.nair@medinexus.com',       'hashed_pass_005', '2024-01-06', 'Doctor'),
('390001', 'dr.desai@medinexus.com',      'hashed_pass_006', '2024-01-07', 'Doctor'),
('380001', 'medplus.ahmd@pharmacy.com',   'hashed_pass_007', '2024-01-09', 'Pharmacy'),
('382010', 'apollo.gndh@pharmacy.com',    'hashed_pass_008', '2024-01-10', 'Pharmacy'),
('395001', 'lifecare.surat@pharmacy.com', 'hashed_pass_009', '2024-01-11', 'Pharmacy');

-- user_id mapping (SERIAL, in insert order): 1=Arjun 2=Priya 3=Rohit
--   4=Dr.Kapoor 5=Dr.Nair 6=Dr.Desai  7=MedPlus 8=Apollo 9=LifeCare

-- ------------------------------------------------------------
-- 3. PATIENTS  (3 rows)
-- ------------------------------------------------------------
INSERT INTO medinexus.patients (patient_id, name, dob, gender, blood_group, emg_contact) VALUES
(1, 'Arjun Mehta',  '1995-06-15', 'Male',   'B+', '9876543210'),
(2, 'Priya Sharma', '1998-11-22', 'Female', 'O+', '9823456781'),
(3, 'Rohit Verma',  '1990-03-08', 'Male',   'A+', '9712345678');

-- ------------------------------------------------------------
-- 4. DOCTORS  (3 rows)
-- ------------------------------------------------------------
INSERT INTO medinexus.doctors (doc_id, name, license_no, specialization, experience, fees, hospital_affiliation) VALUES
(4, 'Dr. Ramesh Kapoor', 'LIC-2001-GJ-001', 'Cardiologist',   20, 1500.00, 'Apollo Hospital Ahmedabad'),
(5, 'Dr. Meena Nair',    'LIC-2005-GJ-002', 'Dermatologist',  15, 1000.00, 'Sterling Hospital'),
(6, 'Dr. Suresh Desai',  'LIC-2008-GJ-003', 'Orthopedician',  12, 1200.00, 'Zydus Hospital');

-- ------------------------------------------------------------
-- 5. PHARMACY  (3 rows)
-- ------------------------------------------------------------
INSERT INTO medinexus.pharmacy (pharmacy_id, pharmacy_name, tax_id, contact_no) VALUES
(7, 'MedPlus Pharmacy Ahmedabad',   'GST-GJ-001-MED', '07912345601'),
(8, 'Apollo Pharmacy Gandhinagar',  'GST-GJ-002-APO', '07912345602'),
(9, 'LifeCare Pharmacy Surat',      'GST-GJ-003-LIF', '07912345603');

-- ------------------------------------------------------------
-- 6. VISIT_TIME  (6 rows)
-- ------------------------------------------------------------
INSERT INTO medinexus.visit_time (doc_id, day, start_time, end_time, mode) VALUES
(4, 'Monday',    '09:00', '13:00', 'Offline'),
(4, 'Wednesday', '09:00', '13:00', 'Offline'),
(5, 'Tuesday',   '10:00', '14:00', 'Both'),
(5, 'Thursday',  '10:00', '14:00', 'Both'),
(6, 'Monday',    '14:00', '18:00', 'Offline'),
(6, 'Saturday',  '09:00', '12:00', 'Offline');

-- ------------------------------------------------------------
-- 7. APPOINTMENTS  (6 rows)
-- ------------------------------------------------------------
INSERT INTO medinexus.appointments (patient_id, doc_id, app_timestamp, app_date, mode, status) VALUES
(1, 4, '2025-03-03 10:00:00', '2025-03-03', 'Offline', 'Completed'),
(2, 5, '2025-03-04 11:00:00', '2025-03-04', 'Offline', 'Completed'),
(3, 6, '2025-03-03 15:00:00', '2025-03-03', 'Offline', 'Completed'),
(1, 5, '2025-03-10 09:00:00', '2025-03-10', 'Online',  'Completed'),
(2, 4, '2025-04-02 08:30:00', '2025-04-02', 'Online',  'Scheduled'),
(3, 6, '2025-04-05 09:00:00', '2025-04-05', 'Offline', 'Scheduled');

-- app_id mapping: 1=Arjun/Kapoor 2=Priya/Nair 3=Rohit/Desai 4=Arjun/Nair 5=Priya/Kapoor 6=Rohit/Desai

-- ------------------------------------------------------------
-- 8. CONSULTATIONS  (4 rows, for the completed appointments)
-- ------------------------------------------------------------
INSERT INTO medinexus.consultations (app_id, diagnosis, summary) VALUES
(1, 'Hypertension Stage 1',              'Patient has elevated BP. Advised medication and diet control.'),
(2, 'Eczema',                            'Mild eczema on forearms. Prescribed topical cream.'),
(3, 'Hairline Fracture - Left Tibia',    'X-ray confirmed hairline fracture. Rest and support advised.'),
(4, 'Viral Fever',                       'Fever with body ache. Prescribed antipyretics and rest.');

-- consult_id mapping: 1=Arjun/Hypertension 2=Priya/Eczema 3=Rohit/Fracture 4=Arjun/Viral Fever

-- ------------------------------------------------------------
-- 9. SYMPTOMS  (8 rows)
-- ------------------------------------------------------------
INSERT INTO medinexus.symptoms (type, consult_id) VALUES
('Headache',  1),
('Dizziness', 1),
('Itching',   2),
('Redness',   2),
('Leg Pain',  3),
('Swelling',  3),
('Fever',     4),
('Body Ache', 4);

-- ------------------------------------------------------------
-- 10. VITAL_LOGS  (6 rows)
-- ------------------------------------------------------------
INSERT INTO medinexus.vital_logs (patient_id, log_timestamp, metric_type, value, unit) VALUES
(1, '2025-03-03 09:30:00', 'Blood Pressure Systolic', 145, 'mmHg'),
(1, '2025-03-03 09:30:00', 'Heart Rate',               88, 'bpm'),
(2, '2025-03-04 10:15:00', 'Temperature',              99, 'F'),
(2, '2025-03-04 10:15:00', 'SpO2',                     98, '%'),
(3, '2025-03-03 14:30:00', 'Blood Pressure Systolic', 118, 'mmHg'),
(3, '2025-03-03 14:30:00', 'Heart Rate',               76, 'bpm');

-- ------------------------------------------------------------
-- 11. PRESCRIPTIONS  (4 rows, one per consultation)
-- ------------------------------------------------------------
INSERT INTO medinexus.prescriptions (consult_id, issue_date) VALUES
(1, '2025-03-03'),
(2, '2025-03-04'),
(3, '2025-03-03'),
(4, '2025-03-05');

-- pres_id mapping: 1=consult1 2=consult2 3=consult3 4=consult4

-- ------------------------------------------------------------
-- 12. MEDICINES  (6 rows)
-- ------------------------------------------------------------
INSERT INTO medinexus.medicines (name, brand_name, category, description) VALUES
('Amlodipine 5mg',       'Amlokind',  'Antihypertensive', 'Calcium channel blocker'),
('Betamethasone Cream',  'Betnovate', 'Topical Steroid',  'Reduces inflammation and itching'),
('Ibuprofen 400mg',      'Brufen',    'NSAID',            'Anti-inflammatory and pain reliever'),
('Paracetamol 500mg',    'Calpol',    'Antipyretic',      'Reduces fever and mild pain'),
('Cetrizine 10mg',       'Cetzine',   'Antihistamine',    'Relieves allergy symptoms'),
('Vitamin D3 60000 IU',  'Uprise D3', 'Supplement',       'Weekly dose for Vitamin D deficiency');

-- med_code mapping: 1=Amlodipine 2=Betamethasone 3=Ibuprofen 4=Paracetamol 5=Cetrizine 6=Vitamin D3

-- ------------------------------------------------------------
-- 13. PRESCRIPTION_ITEMS  (8 rows)
-- ------------------------------------------------------------
INSERT INTO medinexus.prescription_items (pres_id, med_code, dosage, frequency, qty) VALUES
(1, 1, '5mg',              'Once daily at night',   30),
(1, 6, '60000 IU',         'Once a week',             4),
(2, 2, 'Apply thin layer', 'Twice daily',             1),
(2, 5, '10mg',             'Once daily at night',    10),
(3, 3, '400mg',            'Thrice daily after meals',21),
(3, 6, '60000 IU',         'Once a week',             4),
(4, 4, '500mg',            'Thrice daily',           15),
(4, 5, '10mg',             'Once daily',              5);

-- ------------------------------------------------------------
-- 14. STOCKS  (8 rows)
-- ------------------------------------------------------------
INSERT INTO medinexus.stocks (pharmacy_id, med_code, unit_price, qty) VALUES
(7, 1, 45.00, 200),
(7, 4, 12.00, 500),
(7, 5, 20.00, 300),
(8, 2, 120.00, 80),
(8, 3, 25.00, 250),
(8, 6, 210.00, 60),
(9, 1, 47.00, 180),
(9, 4, 11.00, 600);

-- ------------------------------------------------------------
-- 15. BILL  (8 rows: 4 consultation bills + 4 pharmacy bills)
-- ------------------------------------------------------------
INSERT INTO medinexus.bill (patient_id, bill_date, total_amount) VALUES
(1, '2025-03-03', 1500.00),  -- bill 1: consultation (consult 1)
(2, '2025-03-04', 1000.00),  -- bill 2: consultation (consult 2)
(3, '2025-03-03', 1200.00),  -- bill 3: consultation (consult 3)
(1, '2025-03-10', 1000.00),  -- bill 4: consultation (consult 4)
(1, '2025-03-05',  850.00),  -- bill 5: pharmacy (MedPlus)
(2, '2025-03-06',  560.00),  -- bill 6: pharmacy (Apollo)
(3, '2025-03-07',  320.00),  -- bill 7: pharmacy (LifeCare)
(1, '2025-03-08',  240.00);  -- bill 8: pharmacy (MedPlus)

-- ------------------------------------------------------------
-- 16. CONSULTATION_BILLS  (4 rows)
-- ------------------------------------------------------------
INSERT INTO medinexus.consultation_bills (consult_id, bill_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4);

-- ------------------------------------------------------------
-- 17. PHARMA_BILLS  (4 rows)
-- ------------------------------------------------------------
INSERT INTO medinexus.pharma_bills (bill_id, pharmacy_id) VALUES
(5, 7),
(6, 8),
(7, 9),
(8, 7);

-- ------------------------------------------------------------
-- 18. PHARMA_BILL_ITEMS  (8 rows)
-- ------------------------------------------------------------
INSERT INTO medinexus.pharma_bill_items (bill_id, med_code, qty, unit_price) VALUES
(5, 1, 30, 45.00),
(5, 4, 15, 12.00),
(6, 2,  1, 120.00),
(6, 3, 10, 25.00),
(7, 1, 20, 47.00),
(7, 4, 10, 11.00),
(8, 5, 10, 20.00),
(8, 1,  5, 45.00);

-- ------------------------------------------------------------
-- 19. PAYMENTS  (8 rows, one per bill)
-- ------------------------------------------------------------
INSERT INTO medinexus.payments (bill_id, gateway, mode, ref_no) VALUES
(1, 'Razorpay',   'Online',  'REF-RZP-10001'),
(2, 'Paytm',      'Online',  'REF-PTM-10002'),
(3, 'UPI',        'Online',  'REF-UPI-10003'),
(4, 'NetBanking', 'Online',  'REF-NB-10004'),
(5, 'Razorpay',   'Offline', 'REF-RZP-10005'),
(6, 'Paytm',      'Offline', 'REF-PTM-10006'),
(7, 'UPI',        'Offline', 'REF-UPI-10007'),
(8, 'Razorpay',   'Offline', 'REF-RZP-10008');

