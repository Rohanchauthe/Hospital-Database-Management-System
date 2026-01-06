-- 1. Write a query in SQL to obtain the name of the physicians with department who are yet to be affiliated.
-- Ans :- 
use hospital_db;
select p.physician_name,
d.department_name 
from physician p 
left join affiliated_with a
on p.employeeid = a.physician
left join department d
on d.department_id = a.department
where primaryaffiliation = 'f';

select * from procedures;

-- 2. Write a query in SQL to obtain the name of the patients with their physicians by whom they got their preliminary treatment.
-- Ans :- 

select p.patient_name,
py.physician_name as priliminary_treatment_physician
from patient p
left join physician py
on p.pcp = py.employeeid;


-- 3. Write a query in SQL to find the name of the patients and the number of physicians they have taken appointment.
-- Ans :- 

select p.patient_name,
count(a.physician) as number_of_physicians,
py.physician_name
from patient p 
join appointment a  
on p.pcp= a.physician
join physician py
on a.physician = py.employeeid
group by p.patient_name,py.physician_name; 


-- 4.Write a query in SQL to count number of unique patients who got an appointment for examination room C.
-- Ans :-

select
count(p.ssn) as unique_patients
from patient p 
join appointment a 
on p.ssn = a.patient
where examinationroom = 'c';

-- 5.Write a query in SQL to find the name of the patients and the number of the room where they have to go for their treatment.
-- Ans :- 

select p.patient_name ,
s.roomnumber
from patient p
left join stay s
on p.ssn = s.patient;


-- 6. Write a query in SQL to find the name of the nurses and the room scheduled, where they will assist the physicians.
-- Ans :- 

select n.nurse_name,
s.roomnumber
from nurse n 
left join undergoes u
on n.employeeid = u.assistingnurse
left join stay s
on u.stay = s.stayid;

-- 7. Write a query in SQL to find the name of the patients who taken the appointment on the 
-- 25th of April at 10 am, and also display their physician, assisting nurses and room no.
-- Ans :- 

select p.patient_name,
py.physician_name,
n.nurse_name,
s.roomnumber
from appointment a
join patient p 
on p.ssn = a.patient
join physician py 
on a.physician = py.employeeid
join nurse n 
on a.prepnurse = n.employeeid
join stay s 
on a.patient = s.patient
where start_dt = "25/4/2008";

-- 8.Write a query in SQL to find the name of patients and their physicians who does not require any assistance of a nurse.
-- Ans :-

select p.patient_name,
py.physician_name
from patient p 
join undergoes u 
on p.ssn = u.patient
join physician py 
on u.physician = py.employeeid
where assistingnurse is null;


-- 9. Write a query in SQL to find the name of the patients, their treating physicians and medication.
-- Ans :- 

select  p.patient_name,
py.physician_name,
m.medication_name
from prescribes pr  
left join patient p 
on p.ssn = pr.patient
left join physician py
on pr.physician = py.employeeid 
left join medication m 
on pr.medication = m.code;


-- 10. Write a query in SQL to find the name of the patients who taken an advanced appointment, and also display their physicians and medication
-- Ans :- 

select distinct p.patient_name ,
py.physician_name ,
m.medication_name
from undergoes u
left join patient p 
on p.ssn = u.patient
left join physician py 
on u.physician = py.employeeid
left join appointment a 
on u.patient = a.patient
left join prescribes ps 
on p.ssn = ps.patient
left join medication m 
on ps.medication = m.code
where a.start_dt > u.date;


-- 11. Write a query in SQL to count the number of available rooms for each block in each floor
-- Ans :- 

select blockfloor,
blockcode,
count(*) as available_rooms
from room
where unavailable = 'f'
group by blockfloor,blockcode
order by blockfloor,blockcode;


-- 12. Write a query in SQL to find out the floor where the minimum no of rooms are available. 
-- Ans :- 

select blockfloor
from room
where unavailable = 'f'
group by blockfloor
having count(*) = ( 
select min(room_count)
from (
select count(*) as room_count
from room
where unavailable = 'f'
group by blockfloor)as temp_count);


-- 13. Write a query in SQL to obtain the name of the patients, their block, floor, and room number where they are admitted.
-- Ans :-

select p.patient_name,
b.blockcode,
b.blockfloor,
r.roomnumber 
from stay s 
left join patient p 
on s.patient = p.ssn
left join room r
on s.roomnumber = r.roomnumber
left join block b
on r.blockcode = b.blockcode 
and r.blockfloor = b.blockfloor;


-- 14. Write a query in SQL to obtain the name and position of all physicians who completed a
-- medical procedure with certification after the date of expiration of their certificate.
-- Ans :- 

select py.physician_name ,
py.physician_position
from trained_in t
left join physician py
on t.physician = py.employeeid
join undergoes u 
on t.treatment = u.procedure_id
where u.date > t.certificationexpires
order by t.certificationexpires asc limit 1 ;


-- 15. Write a query in SQL to obtain the name of all those physicians who completed a
-- medical procedure with certification after the date of expiration of their certificate, their
-- position, procedure they have done, date of procedure, name of the patient on which the
-- procedure had been applied and the date when the certification expired.
-- Ans :-


SELECT 
    py.physician_name,
    py.physician_position,
    p.patient_name,
    pr.procedure_name,
    u.date AS procedure_date,
    t.certificationexpires
FROM patient p 
JOIN undergoes u 
       ON u.patient = p.ssn
JOIN physician py 
       ON py.employeeid = u.physician
JOIN procedures pr 
       ON pr.code = u.procedure_id
JOIN trained_in t
       ON t.physician = py.employeeid
      AND t.treatment = pr.code      -- IMPORTANT join condition!
WHERE u.date > t.certificationexpires
order by t.certificationexpires asc limit 1;



