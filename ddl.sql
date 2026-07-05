

DROP SCHEMA IF EXISTS medinexus CASCADE;
CREATE SCHEMA medinexus;
SET search_path TO medinexus;

-- ------------------------------------------------------------
-- 1. LOCATION
-- ------------------------------------------------------------
CREATE TABLE medinexus.location (
    pincode     CHAR(6) PRIMARY KEY,
    city        VARCHAR(60) NOT NULL,
    state       VARCHAR(60) NOT NULL
);

-- ------------------------------------------------------------
-- 2. USERS   (superclass for Patient / Doctor / Pharmacy - ISA)
-- ------------------------------------------------------------
CREATE TABLE medinexus.users (
    user_id     SERIAL PRIMARY KEY,
    pincode     CHAR(6) NOT NULL REFERENCES medinexus.location(pincode),
    email       VARCHAR(100) NOT NULL UNIQUE,
    password    VARCHAR(255) NOT NULL,
    reg_date    DATE NOT NULL DEFAULT CURRENT_DATE,
    type        VARCHAR(20) NOT NULL CHECK (type IN ('Patient','Doctor','Pharmacy'))
);

-- ------------------------------------------------------------
-- 3. PATIENTS
-- ------------------------------------------------------------
CREATE TABLE medinexus.patients (
    patient_id  INT PRIMARY KEY REFERENCES medinexus.users(user_id) ON DELETE CASCADE,
    name        VARCHAR(100) NOT NULL,
    dob         DATE NOT NULL,
    gender      VARCHAR(10) CHECK (gender IN ('Male','Female','Other')),
    blood_group VARCHAR(5),
    emg_contact VARCHAR(15)
);

-- ------------------------------------------------------------
-- 4. DOCTORS
-- ------------------------------------------------------------
CREATE TABLE medinexus.doctors (
    doc_id                INT PRIMARY KEY REFERENCES medinexus.users(user_id) ON DELETE CASCADE,
    name                  VARCHAR(100) NOT NULL,
    license_no            VARCHAR(30) NOT NULL UNIQUE,
    specialization        VARCHAR(100) NOT NULL,
    experience            INT CHECK (experience >= 0),
    fees                  NUMERIC(10,2) NOT NULL CHECK (fees >= 0),
    hospital_affiliation  VARCHAR(150)
);

-- ------------------------------------------------------------
-- 5. PHARMACY
-- ------------------------------------------------------------
CREATE TABLE medinexus.pharmacy (
    pharmacy_id     INT PRIMARY KEY REFERENCES medinexus.users(user_id) ON DELETE CASCADE,
    pharmacy_name   VARCHAR(150) NOT NULL,
    tax_id          VARCHAR(30) NOT NULL UNIQUE,
    contact_no      VARCHAR(15) NOT NULL
);

-- ------------------------------------------------------------
-- 6. VISIT_TIME
-- ------------------------------------------------------------
CREATE TABLE medinexus.visit_time (
    slot_id     SERIAL PRIMARY KEY,
    doc_id      INT NOT NULL REFERENCES medinexus.doctors(doc_id) ON DELETE CASCADE,
    day         VARCHAR(10) NOT NULL CHECK (day IN
                ('Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday')),
    start_time  TIME NOT NULL,
    end_time    TIME NOT NULL,
    mode        VARCHAR(20) NOT NULL CHECK (mode IN ('Online','Offline','Both')),
    CONSTRAINT chk_slot_times CHECK (end_time > start_time),
    UNIQUE (doc_id, day, start_time)
);

-- ------------------------------------------------------------
-- 7. APPOINTMENTS
-- ------------------------------------------------------------
CREATE TABLE medinexus.appointments (
    app_id          SERIAL PRIMARY KEY,
    patient_id      INT NOT NULL REFERENCES medinexus.patients(patient_id) ON DELETE CASCADE,
    doc_id          INT NOT NULL REFERENCES medinexus.doctors(doc_id) ON DELETE CASCADE,
    app_timestamp   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    app_date        DATE NOT NULL,
    mode            VARCHAR(20) NOT NULL CHECK (mode IN ('Online','Offline')),
    status          VARCHAR(20) NOT NULL DEFAULT 'Scheduled'
                    CHECK (status IN ('Scheduled','Completed','Cancelled','No-Show'))
);

-- ------------------------------------------------------------
-- 8. CONSULTATIONS
-- ------------------------------------------------------------
CREATE TABLE medinexus.consultations (
    consult_id          SERIAL PRIMARY KEY,
    app_id              INT NOT NULL UNIQUE REFERENCES medinexus.appointments(app_id) ON DELETE CASCADE,
    diagnosis           VARCHAR(500),
    summary             VARCHAR(1000),
    consult_timestamp   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ------------------------------------------------------------
-- 9. SYMPTOMS
-- ------------------------------------------------------------
CREATE TABLE medinexus.symptoms (
    type        VARCHAR(100) NOT NULL,
    consult_id  INT NOT NULL REFERENCES medinexus.consultations(consult_id) ON DELETE CASCADE,
    PRIMARY KEY (type, consult_id)
);

-- ------------------------------------------------------------
-- 10. VITAL_LOGS
-- ------------------------------------------------------------
CREATE TABLE medinexus.vital_logs (
    log_id          SERIAL PRIMARY KEY,
    patient_id      INT NOT NULL REFERENCES medinexus.patients(patient_id) ON DELETE CASCADE,
    log_timestamp   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    metric_type     VARCHAR(60) NOT NULL,
    value           INT NOT NULL,
    unit            VARCHAR(20) NOT NULL
);

-- ------------------------------------------------------------
-- 11. PRESCRIPTIONS
-- ------------------------------------------------------------
CREATE TABLE medinexus.prescriptions (
    pres_id     SERIAL PRIMARY KEY,
    consult_id  INT NOT NULL UNIQUE REFERENCES medinexus.consultations(consult_id) ON DELETE CASCADE,
    issue_date  DATE NOT NULL DEFAULT CURRENT_DATE
);

-- ------------------------------------------------------------
-- 12. MEDICINES
-- ------------------------------------------------------------
CREATE TABLE medinexus.medicines (
    med_code     SERIAL PRIMARY KEY,
    name         VARCHAR(150) NOT NULL,
    brand_name   VARCHAR(150),
    category     VARCHAR(80),
    description  VARCHAR(500)
);

-- ------------------------------------------------------------
-- 13. PRESCRIPTION_ITEMS
-- ------------------------------------------------------------
CREATE TABLE medinexus.prescription_items (
    pres_id     INT NOT NULL REFERENCES medinexus.prescriptions(pres_id) ON DELETE CASCADE,
    med_code    INT NOT NULL REFERENCES medinexus.medicines(med_code) ON DELETE RESTRICT,
    dosage      VARCHAR(60),
    frequency   VARCHAR(60),
    qty         INT NOT NULL CHECK (qty > 0),
    PRIMARY KEY (pres_id, med_code)
);

-- ------------------------------------------------------------
-- 14. STOCKS
-- ------------------------------------------------------------
CREATE TABLE medinexus.stocks (
    pharmacy_id  INT NOT NULL REFERENCES medinexus.pharmacy(pharmacy_id) ON DELETE CASCADE,
    med_code     INT NOT NULL REFERENCES medinexus.medicines(med_code) ON DELETE RESTRICT,
    unit_price   NUMERIC(10,2) NOT NULL CHECK (unit_price >= 0),
    qty          INT NOT NULL CHECK (qty >= 0),
    PRIMARY KEY (pharmacy_id, med_code)
);

-- ------------------------------------------------------------
-- 15. BILL
-- ------------------------------------------------------------
CREATE TABLE medinexus.bill (
    bill_id       SERIAL PRIMARY KEY,
    patient_id    INT NOT NULL REFERENCES medinexus.patients(patient_id) ON DELETE RESTRICT,
    bill_date     DATE NOT NULL DEFAULT CURRENT_DATE,
    total_amount  NUMERIC(10,2) NOT NULL CHECK (total_amount >= 0)
);

-- ------------------------------------------------------------
-- 16. CONSULTATION_BILLS
-- ------------------------------------------------------------
CREATE TABLE medinexus.consultation_bills (
    consult_id  INT PRIMARY KEY REFERENCES medinexus.consultations(consult_id) ON DELETE CASCADE,
    bill_id     INT NOT NULL UNIQUE REFERENCES medinexus.bill(bill_id) ON DELETE CASCADE
);

-- ------------------------------------------------------------
-- 17. PHARMA_BILLS
-- ------------------------------------------------------------
CREATE TABLE medinexus.pharma_bills (
    bill_id      INT PRIMARY KEY REFERENCES medinexus.bill(bill_id) ON DELETE CASCADE,
    pharmacy_id  INT NOT NULL REFERENCES medinexus.pharmacy(pharmacy_id) ON DELETE RESTRICT
);

-- ------------------------------------------------------------
-- 18. PHARMA_BILL_ITEMS
-- ------------------------------------------------------------
CREATE TABLE medinexus.pharma_bill_items (
    bill_id     INT NOT NULL REFERENCES medinexus.pharma_bills(bill_id) ON DELETE CASCADE,
    med_code    INT NOT NULL REFERENCES medinexus.medicines(med_code) ON DELETE RESTRICT,
    qty         INT NOT NULL CHECK (qty > 0),
    unit_price  NUMERIC(10,2) NOT NULL CHECK (unit_price >= 0),
    PRIMARY KEY (bill_id, med_code)
);

-- ------------------------------------------------------------
-- 19. PAYMENTS
-- ------------------------------------------------------------
CREATE TABLE medinexus.payments (
    transaction_id  SERIAL PRIMARY KEY,
    bill_id         INT NOT NULL UNIQUE REFERENCES medinexus.bill(bill_id) ON DELETE RESTRICT,
    gateway         VARCHAR(60) NOT NULL,
    mode            VARCHAR(20) NOT NULL DEFAULT 'Online' CHECK (mode IN ('Online','Offline')),
    ref_no          VARCHAR(60) NOT NULL UNIQUE
);

