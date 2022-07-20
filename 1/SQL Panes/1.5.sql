CREATE OR REPLACE FUNCTION diploma_finish_1_5(grad_date date )
RETURNS VOID AS
$$ 
DECLARE
	 min_not_obligary_lessons integer  ;
BEGIN
        min_not_obligary_lessons := 14 ; 
	UPDATE "Diploma"
	SET	graduation_date = grad_date,
		diploma_grade = 0.2*thesis_grade +
					  0.8*(((SELECT sum("Register".final_grade * factor_calc_1_5("Course".units))
					           FROM ("Register" inner join "CourseRun" on "Register".serial_number = "CourseRun".serial_number)inner join "Course" on 
					           ("Course".course_code = "CourseRun".course_code AND "Course".obligatory = 'true')  WHERE "Register"."Student_amka" = "Diploma"."Student_amka" )					           
					  + 
					  (SELECT sum(totalsum) FROM 
					          (SELECT DISTINCT "Course".course_code , "Register".final_grade , factor_calc_1_5("Course".units)  ,("Register".final_grade * factor_calc_1_5("Course".units)) as totalsum
					           FROM ("Register" inner join "CourseRun" on "Register".serial_number = "CourseRun".serial_number)inner join "Course" on 
					           ("Course".course_code = "CourseRun".course_code AND "Course".obligatory = 'false')  
					           WHERE "Register"."Student_amka" = "Diploma"."Student_amka"  	
						   GROUP BY "Register".final_grade , "Course".units , "Course".course_code 
						   ORDER BY "Register".final_grade DESC
						   LIMIT min_not_obligary_lessons) as subsum )) 
						   / 
					    ((SELECT sum(factor_calc_1_5("Course".units))
					      FROM "Register", "CourseRun", "Course"
					      WHERE "Register"."Student_amka" = "Diploma"."Student_amka"  AND
				              "Register".serial_number = "CourseRun".serial_number AND
					      "Course".course_code = "CourseRun".course_code AND
					       "Course".obligatory = 'true')					       
						+
						(SELECT sum(totalunits) FROM 
					          (SELECT DISTINCT "Course".course_code , "Register".final_grade , factor_calc_1_5("Course".units)  ,(factor_calc_1_5("Course".units)) as totalunits
					           FROM ("Register" inner join "CourseRun" on "Register".serial_number = "CourseRun".serial_number)inner join "Course" on 
					           ("Course".course_code = "CourseRun".course_code AND "Course".obligatory = 'false')  
					           WHERE "Register"."Student_amka" = "Diploma"."Student_amka"  	
						   GROUP BY "Register".final_grade , "Course".units , "Course".course_code 
						   ORDER BY "Register".final_grade DESC
						   LIMIT min_not_obligary_lessons) as subsum )						
						   ))
	FROM  "Semester"
	WHERE "Diploma"."Student_amka" IN (SELECT amka FROM "Student" St WHERE St.am IN (SELECT grad_students_who_have_not_grad_2_6()));	
END;
$$
LANGUAGE 'plpgsql' VOLATILE;

SELECT diploma_finish_1_5('6-5-2017')

CREATE OR REPLACE FUNCTION factor_calc_1_5(course_units smallint)
RETURNS numeric AS
$$ 
BEGIN

IF (course_units <= 0) THEN RAISE EXCEPTION 'Invalid Course Units!' ;
ELSIF (course_units <=2) AND (course_units > 0) THEN RETURN 1 ;
ELSIF (course_units <=4) AND (course_units > 2)  THEN RETURN 1.5 ;
ELSIF (course_units = 5) THEN RETURN 2 ;
ELSE RAISE EXCEPTION 'Invalid Course Units!' ;
END IF ; 

END;
$$
LANGUAGE 'plpgsql' VOLATILE;

UPDATE "Register"
SET register_status = 'pass'
WHERE register_status = 'fail' AND "Student_amka" 

UPDATE "Register"
SET register_status = 'pass'
WHERE register_status = 'fail'

UPDATE "Register"
SET final_grade = 7
WHERE final_grade < 5

SELECT diploma_input_1_4(
    2011000001,
    1000001,
    1000002,
    1000003,
    'SWAG')

SELECT grade_input_1_2()

SELECT insert_courserun_1_6()

SELECT insert_uncomp_thesis_grade_1_3()



SELECT grad_students_who_have_not_grad_2_6()