CREATE OR REPLACE FUNCTION search_student(searcham bigint)
RETURNS TABLE(
name character varying(20),
  email character varying(20),
  father_name character varying(20),
  surname character varying(20),
  entry_date date,
  am_ret bigint ,
  amka integer 
)AS

$$


BEGIN
	RETURN QUERY
	(SELECT "Student".name, "Student".email, "Student".father_name, "Student".surname, "Student".entry_date, "Student".am, "Student".amka
	 FROM "Student"
	 WHERE "Student".am = searcham);
END;


$$
LANGUAGE 'plpgsql' VOLATILE;

SELECT search_student(2011000000)

CREATE OR REPLACE FUNCTION student_by_code(tempcode character varying(7))
RETURNS TABLE(
  name character varying(20),
  surname character varying(20),
  am bigint
)AS

$$


BEGIN
	RETURN QUERY
	(
	SELECT "Student".name, "Student".surname, "Student".am
	FROM "Student", "Register", "CourseRun", "Semester"
	WHERE "CourseRun".course_code = tempcode 
		AND "CourseRun".semester_id = "Semester".semester_id 
		AND "Semester".semester_status = 'present' 
		AND "CourseRun".serial_number = "Register".serial_number 
		AND "Register"."Student_amka" = "Student".amka

	 );
END;
$$
LANGUAGE 'plpgsql' VOLATILE;

SELECT student_by_code('ΑΓΓ 101')

