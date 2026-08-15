# Medical Data History - SQL Analysis Project

# Author: Ajith Kumar JE
# Datebase: MySQL

# Overview

- Analysis of a relational healthcare dataset using SQL (MySQL), covering patient demographics, hospital
- admissions, and attending physician records. The project answers 34 business and analytical questions
- using SQL alone: filtering, aggregation, multi-tablejoins, string/date manipulation, and conditional logic Tools. MySQL (data source, provided via institute-hosted remote server)

- DBeaver (SQL client / query execution)

# Objecitves

- Analyse patient and admission data
- Identify Important Trends
- Explore relationship between tables

# Database Schema

Four related tables:

Table Key Columns

*patients*

patient_id (PK),
first_name, last_name, gender,
birth_date, city, allergies,
height, weight, province_id
(FK)

*doctors*

doctor_id (PK), first_name,
last_name, speciality

*admissions*

patient_id (FK),
admission_date,
discharge_date, diagnosis,
doctor_id (FK)

*province_names*

province_id (PK),
province_name

- See erd.png for the full entity relationship diagram.

# Schema fix applied:
- admissions.attending_doctor_id was renamed to doctor_id via ALTER TABLE ... CHANGE to align with the doctors table's primary key and enable a
clean join.

# Files
- queries.sql : all 34 queries with explanatory comments

- erd.png : entity relationship diagram screenshots/ : sample query result sets

# Skills Demonstrated

- Filtering with WHERE , LIKE , BETWEEN , IN
- NULL handling ( IS NULL , COALESCE )
- Aggregate functions: COUNT , SUM , MAX , MIN
- GROUP BY / HAVING , including multi-column
- grouping and grouping on calculated expressions
- Multi-key ORDER BY
- String functions: CONCAT , UPPER , LOWER ,LENGTH

- Date functions: YEAR() , DAY() , date range
- filtering
- CASE WHEN conditional logic
- INNER JOIN across two and three tables
- UNION ALL to combine result sets from different tables

- Schema literacy: reading an ERD, primary/foreign keys, ALTER TABLE
- Practical troubleshooting: remote DB connection setup and authentication in DBeaver, working
within read-only permission constraints

# Notes

Question 5 required an UPDATE statement. The provided database account had read-only access to the patients table, so the intended logic was verified non-destructively using COALESCE(allergies, 'NKA') in a SELECT instead.
The correct UPDATE syntax is included in queries.sql for reference.

# Project files

- MDH-Queries.sql (SQL Queries used for analysis)
- Medical Data History Project - Report.pdf
- Medical Data History Project(Results).pdf