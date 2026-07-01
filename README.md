# MediNexus Healthcare Ecosystem

**Course:** IT214 – Database Management Systems
**Semester:** Winter 2026
**Institution:** Dhirubhai Ambani University Technology (Formerly DA-IICT)

## Project Team

| Name | Roll Number |
|---|---|
| Atharv Trivedi | 202401230 |
| Jay Vaghela | 202401237 |
| Dharmraj Vaghela | 202401236 |
| Shlok Topaliya | 202401229 |

---

## 1. Objective

Design and implement a database for a comprehensive digital healthcare and telemedicine ecosystem. MediNexus acts as a unified marketplace connecting **patients**, **doctors**, **pharmacies**, and **insurance companies**, managing the full lifecycle of care — from remote consultations and Electronic Health Records (EHR) to pharmacy inventory and billing.

## 2. Scope

**In scope:** patient registration/profiles, doctor registration & specializations, appointment scheduling (physical + telemedicine), medical history/diagnosis records, prescriptions, pharmacy inventory, consultation billing/payments, telemedicine tracking, operational reports.

**Out of scope:** real-time video infrastructure, large medical imaging storage (MRI/CT), integration with national healthcare systems, and end-to-end insurance claims/reimbursement processing.

## 3. Application Users

- **Surfers** (unlogged) — browse doctors, specialties, pharmacy stock
- **Patients** — manage health profile, book appointments, view records, log vitals, leave reviews
- **Doctors** — manage schedule, conduct consultations, issue e-prescriptions, refer patients
- **Pharmacies** — manage inventory, fulfill prescriptions
- **Insurance Providers** — process claims
- **Platform Admin** — overall platform operations

## 4. Repository / Document Contents

| File | Description |
|---|---|
| `MediNexus-Healthcare-Ecosystem.pdf` | Project scenario description — objective, scope, users, use cases, sample reports |
| `MediNexus_er.pdf` | Entity–Relationship (ER) diagram |
| `Relational_Schema.pdf` | Relational schema derived from the ER diagram |
| `MediNexus_BCNF_Final.pdf` | Functional dependencies, candidate keys, and BCNF proofs for all relations |
| `Final_RS.pdf` | Final relational schema + minimal FD set + BCNF proofs + full PostgreSQL DDL scripts with sample data |

## 5. Database Design Summary

- **19 relations**, all verified to be in **BCNF** under stated business constraints (e.g. uniqueness of `Email`, `License_No`, `Tax_ID`, `Ref_No`; 1-to-1 mappings between Appointment–Consultation–Prescription and Bill–Payment).
- Core entities: `User`, `Patients`, `Doctor`, `Pharmacy`, `Medicine`, `Appointment`, `Consultation`, `Prescription`, `Bill`, `Payment`.
- Bridge/associative tables: `Stocks`, `Prescription_Item`, `Symptoms`, `Consultation_Bill`, `PHARMA_BILL`, `Pharma_Bill_Item`, `Visit_Time`.

### Key Design Decisions
- `User` is a supertype (ISA) for Patients, Doctors, and Pharmacies, all sharing `USER_ID` as PK/FK.
- Doctors and Pharmacies each carry an alternate candidate key (`License_No`, `Tax_ID` respectively) enforced via `UNIQUE`.
- Every consultation ties to exactly one appointment and produces at most one prescription (1:1), enforced with `UNIQUE` foreign keys.
- Billing is split into `Consultation_Bill` and `PHARMA_BILL`/`Pharma_Bill_Item` to support mixed consultation + pharmacy line items on a single `Bill`.

## 6. Tech Stack

- **RDBMS:** PostgreSQL
- **Schema name:** `medinexus`
- Scripts create the schema, 18–19 tables with constraints (PK/FK, `CHECK`, `UNIQUE`, `NOT NULL`), and load sample data (~14 users, patients, doctors, pharmacies, appointments, consultations, prescriptions, stocks, bills, and payments).

## 7. How to Run the DDL

```bash
# 1. Start / connect to a PostgreSQL instance
psql -U <username> -d <database>

# 2. Run the script (extracted from Final_RS.pdf, Section "DDL Script")
\i medinexus_schema.sql
```

The script:
1. Drops and recreates the `medinexus` schema.
2. Creates all 18 tables in dependency order (`users` → `patients`/`doctors`/`pharmacies` → `appointments` → `consultations` → ... → `pharma_bill_items`).
3. Inserts consistent sample data across all tables for testing queries.

> **Note:** The DDL is embedded in `Final_RS.pdf`. If you'd like, I can extract it into a standalone runnable `.sql` file — just ask.

## 8. Sample Reports / Queries Supported

- **General:** top-rated cardiologists under ₹1500, medicine price comparison across pharmacies, doctors available for video consult in next 24h, open pharmacies by PIN code.
- **Patients:** medical history, active claims, vital trends, prescription status, upcoming appointments.
- **Doctors:** daily schedule, high-risk patients, consultation summary, referral tracking, earnings report.
- **Pharmacy Admins:** low stock alerts, sales summary, order fulfillment log.
- **Insurance:** pending claims, claims audit, policy performance, provider analysis.
- **Global Admin:** specialty trends, platform earnings, user growth, feedback analytics, billing reconciliation.

## 9. Entity Relationship Diagram

See `MediNexus_er.pdf` for the full Chen-notation ER diagram, including entities (User, Patients, Doctors, Appointments, Consultation, Prescription, Medicine, Pharmacy, Bill, Payment, Vital_Log, Location) and relationships (ISA, Books, Conducts, Generates, Records, Prescribes, Includes, Pays, Settles, Stocks, Located, Available_On).

---
*This README summarizes the design artifacts submitted for the MediNexus Healthcare Ecosystem project (IT214, Winter 2026).*
