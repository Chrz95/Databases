CREATE OR REPLACE VIEW annual_stats_4_2 AS 
(SELECT "Student".am as AM, "Student".name as First_Name, "Student".surname as Surname, annual_grade_4_2("Student".am) as Annual_grade, (years_passed_from_date("Student".entry_date) :: integer)  as Current_Year 		     
FROM "Student")

CREATE OR REPLACE FUNCTION public.annual_grade_4_2(am_param bigint)
  RETURNS numeric AS
$BODY$
DECLARE
   previous_year integer ;
BEGIN

previous_year := ((SELECT years_passed_from_date((SELECT entry_date FROM "Student" WHERE am = am_param)) ) -1 ) :: integer  ;

IF (previous_year <=5) THEN 
	IF EXISTS ((SELECT course_code FROM "Course" WHERE typical_year = previous_year AND obligatory)  
	           EXCEPT
		  (SELECT C.course_code 
		   FROM "Register" R , "CourseRun" CR , "Course" C 
		   WHERE register_status = 'pass' 
		   AND C.typical_year = previous_year 
		   AND obligatory AND R.serial_number = CR.serial_number 
		   AND CR.course_code = C.course_code  
		   AND R."Student_amka" = (SELECT amka FROM "Student" WHERE am = am_param ))) THEN RETURN NULL ; 
	ELSE -- Calculate the annual grade
	RETURN 
						((SELECT sum(R.final_grade * factor_calc_1_5(C.units))
						  FROM "Register" R, "CourseRun" CR, "Course" C
						  WHERE R.serial_number = CR.serial_number AND C.course_code = CR.course_code AND C.typical_year = previous_year AND R.register_status = 'pass'
						  AND R."Student_amka" IN (SELECT amka FROM "Student" WHERE am = am_param ))			  
							   / 
						 (SELECT sum(factor_calc_1_5(C.units))
						  FROM "Register" R, "CourseRun" CR, "Course" C
						  WHERE R.serial_number = CR.serial_number AND C.course_code = CR.course_code AND C.typical_year = previous_year AND R.register_status = 'pass'
						  AND R."Student_amka" IN (SELECT amka FROM "Student" WHERE am = am_param ))) ;					       
	END IF ; 	
ELSE RETURN NULL ;
END IF ; 	       
END;
$BODY$
  LANGUAGE plpgsql 

  2014000001 3000021

DROP VIEW annual_stats_4_2 

SELECT * FROM "Course" WHERE obligatory AND typical_year = 2
SELECT * FROM "Course" WHERE not obligatory AND typical_year = 2

SELECT * FROM "Course" WHERE obligatory AND 

SELECT annual_grade_4_2(2013000013)

UPDATE "Register"
SET register_status = 'pass'
WHERE "Student_amka" = 3000021

UPDATE "Register"
SET register_status = 'pass'
WHERE "Student_amka" = 3000021 AND register_status = 'rejected'

UPDATE "Register"
SET final_grade = 8
WHERE "Student_amka" = 3000021



