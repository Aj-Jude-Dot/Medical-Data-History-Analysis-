Show databases;
use project_medical_data_history;

-- MEDICAL DATA HISTORY PROJECT
-- practicing SQL on a 4-table hospital dataset (patients,doctors,admission,province_names)
-- working is mySQL via DBeaver, connected to the institute's remote server
-- going through these roughly in the order I tackled, grouped by concept.

-- had to fix this first before some of the later joins would work -
-- admissions used "attending_doctor_id" but doctor uses "doctor_id", so renaming to match

select * from patients;

-- Q1. Show first name, last name, and gender of patients whose gender is "M."
select first_name,last_name,gender
from patients
where gender = 'M';

-- Q2. Show first name and last name of patients who do not have allergies

select first_name, last_name
from patients
where allergies is null;

-- Q3. Show first name of patients that start with the letter 'C'

select first_name 
from patients
where first_name like 'C%';

select count(*) from patients;

-- Q4. Show first name and last name of patients that weigh within the range of  100 to 120 (inclusive)

select first_name, last_name
from patients
where weight between 100 and 120;

-- Q5. Update the patients table - if allergies is null, replace it with 'NKA'

Update patients
set allergies = 'NKA'
where allergies is null;


-- OR

select first_name, last_name, coalesce(allergies, 'NKA') as allergies
from patients;

set sql_safe_updates=0;

-- Q6. Show first name and last name concatenated into one column as full name

select concat (first_name, ' ', last_name) as full_name
from patients;


-- Q7. Show first name, last name, and the full province name of each patient

select p.first_name, p.last_name, pn.province_name
from patients p
join province_names pn on p.province_id = pn.province_id;

-- Q8. Show how many patients have a birth_date with 2010 as the birth year;

select count(*) as total_patients
from patients
where year (birth_date) = 2010;

-- Q9. Show first name, last name, and height of the patient with the greatest height

select first_name, last_name, height
from patients
order by height DESC 
limit 1;

-- another method gets only the number

select max(height)
from patients; 

-- Q10. Show all columns for patients who have one of these patient ids 1,45,534,879,1000.

select * 
from patients
where patient_id in  (1,45,534,879,1000);

-- Q11. Show the total number of admissions

select count(*) as total_admissions
from admissions;

select * from admissions;

-- Q12. show all columns from admissions where the patient was admitted and discharged on the same date

select *
from admissions
where admission_date = discharge_date;

select count(*)
from admissions
where admission_date = discharge_date;

-- Q13. show the total number of admissions for patient_id 579

select count(*) as total_admissions
from admissions
where patient_id = 579;

-- Q14. Based on the cities that patients live in , show unique cities that are in province_id 'NS'

select distinct city
from patients
where province_id = 'NS';


-- Q15. Find first_name, last_name, and birth_date of patients with height > 160 and weight <70

select first_name, last_name, birth_date 
from patients
where height > 160 and weight < 70;


select * from province_names;

-- Q16. Show unique birth years, ordered ascending

select distinct year (birth_date) as birth_year
from patients
order by birth_year asc;

-- Q17. Show unique first names that occur exactly once

select first_name
from patients
group by first_name 
having count(*) = 1;

select distinct (first_name) as first_name
from patients
group by first_name asc;


-- Q18. Show patient_id and first name where first names starts and ends with 'S' and is atleast 6 characters long

select patient_id, first_name
from patients
where first_name like 'S%S'and length (first_name) >=6;


-- Q19. Show patient id, first name, last name for patients whose diagnosis is 'Dementia'(diagnosis livs in admissions)

select p.patient_id, p.first_name, p.last_name
from patients p
join admissions a on p.patient_id = a.patient_id
where a.diagnosis = 'Dementia';

select * from admissions;

-- Q20. Display every patient's first_name, ordered by name lenth then alphabetically

select first_name
from patients
order by length (first_name) , first_name;

-- Q21&Q22. show total male patients and total female patients, in the same row

select 
    sum (case when gender = 'M' then 1 else 0 end) as male_count,
    sum (case when gender = 'F' then 1 else 0 end) as female_count
from patients;

-- Q23. Show patient id, diagnosis form admissions- find patients admitted multiple times for the same diagnosis

select patient_id, diagnosis
from admissions
group by patient_id, diagnosis 
having count(*) >1;

-- Q24. Show city and total patients per city, ordered most -- least, then city name ascending

select city, count(*) as total_patients
from patients
group by city 
order by total_patients, city asc;

-- Q25. show first name, last name, and role of every perosn that is either patient or doctor. 
-- roles are "patient" or 'doctor'

select first_name, last_name,'Patients' as role
from patients
Union ALL 
select first_name, last_name, 'Doctors' as role
from doctors;


-- Q26. Show all allergies ordered by popularity. Remove null values

select allergies, count(*) as total
from patients
where allergies is not NULL
group by allergies 
order by total desc;

-- Q27. Show firt name, last name, birth date for patients born in the 1970s, sorted from earliest birth date

select first_name, last_name, birth_date
from patients
where birth_date between '1970-01-01' and '1979-12-31' 
order by birth_date asc;


-- Q28. Display each patient's full name in a single column - last name (upper case)
-- then first name (lowercase), sepereated by comma. Sort by first name, descending. ex, SMITH,jane

select concat(Upper(last_name),',',lower(first_name)) as full_Name
from patients
order by first_name desc;

-- Q29. Show province_id(s) and sum of height, where the total sum of patient height is >=7000


select province_id, sum(height) as total_height
from patients
group by province_id
having  sum(height) >=7000;

-- Q30. Show the difference between largest and smallest weight for patients with last name "Maroni"

select max(weight) - min(weight) as weight_differences
from patients
where last_name = 'Maroni';

-- Q31. Show all the days of the month (1-31) and how many admission_dates occured on that day.
-- sort most to least admissions

select day(admission_date) as day_of_month, count(*) as total_admissions
from admissions
group by day(admission_date)
order by total_admissions desc;

-- Q32. Show patients grouped into weight groups (100-109) 100, (110-119) - 110 etc.,
-- show total patients per group, ordered by weight group descending

select floor(weight/10)*10 as weight_group, count(*) as total_patients
from patients
group by weight_group
order by weight_group desc;

-- Q33. Show patient)id, weight, heaight, is obsee from patients. isobese=weight(kg)/height(m), shown as boolean 0/1

select patient_id, weight, height,
       case when weight / (height/100) > 25 then 1 else 0 end as isObese
from patients;

-- Q34. Show patietnid , first name, last name, and attending doctor's speciality, on ly for patients
-- diagnosed with 'Epilepsy' where doctor's first name is 'lisa'

Select p.patient_id, p.first_name, p.last_name, d.specialty
from patients p
join admissions a on p.patient_id = a.patient_id
join doctors d on a.attending_doctor_id = d.doctor_id
where a.diagnosis = 'Epilepsy' and d.first_name='Lisa';

select * from doctors;