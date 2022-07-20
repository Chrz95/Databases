-- Query

EXPLAIN (ANALYSE,BUFFERS) (SELECT St.amka ,St.am  , St.name , St.surname , St.father_name , St.email , St.entry_date , count(*) as numOfLessons ,sum(units) as TotalUnits
FROM "Student" St , "Register" R, "CourseRun" CR , "Course" C 
WHERE St.surname like  '%ΑΛ%'
AND R."Student_amka" = St.amka 
AND CR.course_code = C.course_code 
AND R.serial_number = CR.serial_number
AND R.register_status = 'approved'
GROUP BY  St.amka ,St.am  , St.name , St.surname , St.father_name , St.email , St.entry_date )

SELECT amka
FROM "Student" St
WHERE St.surname like '%ΑΛ%'

UPDATE "Register"
SET register_status = 'approved'
WHERE register_status = 'rejected'

-- Virtual View

CREATE VIEW surname_contains_al_students_2Part(Amka,Am,Name,Surname,Father_name,Email,Lessons,Units) AS
SELECT St.amka ,St.am  , St.name , St.surname , St.father_name , St.email , St.entry_date , count(*) as numOfLessons ,sum(units) as TotalUnits
FROM "Student" St , "Register" R, "CourseRun" CR , "Course" C 
WHERE St.surname like  '%ΑΛ%'
AND R."Student_amka" = St.amka 
AND CR.course_code = C.course_code 
AND R.serial_number = CR.serial_number
AND R.register_status = 'approved'
GROUP BY  St.amka ,St.am  , St.name , St.surname , St.father_name , St.email , St.entry_date 

-- Materialized View

CREATE MATERIALIZED VIEW surname_contains_al_students_mat_2Part (Amka,Am,Name,Surname,Father_name,Email,Lessons,Units) AS
SELECT St.amka ,St.am  , St.name , St.surname , St.father_name , St.email , St.entry_date , count(*) as numOfLessons ,sum(units) as TotalUnits
FROM "Student" St , "Register" R, "CourseRun" CR , "Course" C 
WHERE St.surname like  '%ΑΛ%'
AND R."Student_amka" = St.amka 
AND CR.course_code = C.course_code 
AND R.serial_number = CR.serial_number
AND R.register_status = 'approved'
GROUP BY  St.amka ,St.am  , St.name , St.surname , St.father_name , St.email , St.entry_date 

EXPLAIN (ANALYZE,BUFFERS) SELECT * FROM surname_contains_al_students_2Part -- Virt View
EXPLAIN (ANALYZE,BUFFERS) SELECT * FROM surname_contains_al_students_mat_2Part -- Mat View