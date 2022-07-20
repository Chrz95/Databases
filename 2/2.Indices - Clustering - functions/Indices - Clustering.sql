VACUUM ANALYSE

-- Input data

SELECT insert_courserun_1_6(34)

SELECT insert_all_100000_test ('19-09-2016') ;
SELECT insert_courseRuns_test(100000,34)
SELECT insert_Registers_test(100000)


CREATE OR REPLACE FUNCTION public.insert_all_100000_test(entry_date_param date)
  RETURNS void AS
$BODY$
DECLARE
	i integer;
BEGIN
	FOR i IN 1..1000 LOOP
		PERFORM insert_all_1_1(100,entry_date_param);
	END LOOP;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE

  CREATE OR REPLACE FUNCTION public.insert_all_10000_test(entry_date_param date)
  RETURNS void AS
$BODY$
DECLARE
	i integer;
BEGIN
	FOR i IN 1..100 LOOP
		PERFORM insert_students_1_1(entry_date_param,100);
	END LOOP;
	
	FOR i IN 1..100 LOOP
		PERFORM insert_labstaff_1_1(100);
	END LOOP;
	
	FOR i IN 1..100 LOOP
		PERFORM insert_professors_1_1(100);
	END LOOP;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE

  EXPLAIN ANALYSE (SELECT insert_all_10000_test ('19-09-2002')) ;
  
   CREATE INDEX student_name_idx_btree ON "Student" USING btree (name)	;
  CREATE INDEX labstaff_name_idx_btree ON "Labstaff" USING btree (name);	
  CREATE INDEX professor_name_idx_btree ON "Professor" USING btree (name);	

  CREATE INDEX student_surname_idx_btree ON "Student" USING btree (surname)	;
  CREATE INDEX labstaff_surname_idx_btree  ON "Labstaff" USING btree (surname);	
  CREATE INDEX professor_surname_idx_btree ON "Professor" USING btree (surname);
  
 CREATE INDEX student_name_idx_hash ON "Student" USING hash (name)	;
  CREATE INDEX labstaff_name_idx_hash ON "Labstaff" USING hash (name);	
  CREATE INDEX professor_name_idx_hash ON "Professor" USING hash (name);	

  CREATE INDEX student_surname_idx_hash ON "Student" USING hash (surname)	;
  CREATE INDEX labstaff_surname_idx_hash  ON "Labstaff" USING hash (surname);	
  CREATE INDEX professor_surname_idx_hash ON "Professor" USING hash (surname);

  DROP INDEX professor_name_idx;
  DROP INDEX student_name_idx;
  DROP INDEX labstaff_name_idx;

  DROP INDEX student_surname_idx ;
  DROP INDEX professor_surname_idx;
  DROP INDEX labstaff_surname_idx;
  
CREATE OR REPLACE FUNCTION public.insert_courseRuns_test(num_of_courseRuns integer ,semester_id_param integer)
  RETURNS void AS
$BODY$
DECLARE
	i integer;
BEGIN
	FOR i IN 1..num_of_courseRuns LOOP
		INSERT INTO "CourseRun" VALUES (semester_id_param,0,0,0,1000001,1,i,1000002);		
	END LOOP;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE

CREATE OR REPLACE FUNCTION public.insert_Registers_test(num_of_Registers integer)
  RETURNS void AS
$BODY$
DECLARE
	i integer;
BEGIN
	FOR i IN 1..num_of_Registers LOOP
		INSERT INTO "Register" VALUES ('approved',0,0,0,i,i+1000000);		
	END LOOP;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
 
-- 2.1

EXPLAIN ANALYSE (SELECT "Student".name, "Student".email, "Student".father_name, "Student".surname, "Student".entry_date, "Student".am, "Student".amka
	 FROM "Student"
	 WHERE "Student".am = 2016083621)
	 ORDER by surname , name

CREATE INDEX student_surname_idx ON "Student" USING hash (am)	 
CLUSTER "Student" USING student_surname_idx_btree ;
DROP INDEX student_surname_idx_btree

-- 2.2

EXPLAIN ANALYSE (SELECT "Student".name, "Student".surname, "Student".am
	FROM "Student", "Register", "CourseRun", "Semester"
	WHERE "CourseRun".course_code = 'ΜΑΘ 411'
	       AND "Semester".semester_status = 'present'
	       AND "Register".register_status = 'approved' 
	       AND "CourseRun".semester_id = "Semester".semester_id 
	       AND "CourseRun".serial_number = "Register".serial_number 
	        AND "Register"."Student_amka" = "Student".amka 		
		)
		ORDER BY surname , name

--  register_status ,R.student_amka , "Register".serial_number , "CR.course_code " , St.student_amka

CREATE INDEX student_amka_idx ON "Student" USING hash (amka)
DROP INDEX student_amka_idx
CREATE INDEX student_amka_idx ON "Student" USING hash (amka)
DROP INDEX student_amka_idx
CREATE INDEX student_amka_idx ON "Student" USING hash (amka)
DROP INDEX student_amka_idx

CREATE INDEX register_status_b_tree_idx ON "Register" USING btree (register_status)
DROP INDEX register_status_b_tree_idx
CREATE INDEX course_code_CR_b_tree_idx ON "CourseRun" USING btree (course_code)
DROP INDEX course_code_CR_b_tree_idx

CREATE INDEX complex_index ON "Register" USING btree ("Student_amka",serial_number)
DROP INDEX complex_index 

CREATE INDEX serial_number_reg_idx ON "Register" USING btree (serial_number)
DROP INDEX serial_number_reg_idx 

CREATE INDEX serial_number_reg_idx ON "Register" USING hash (serial_number)
DROP INDEX serial_number_reg_idx 
		
-- 2.3

EXPLAIN ANALYSE ((SELECT "Student".surname, "Student".name,  'Student'
	FROM "Student"
	)
	UNION
	(
	SELECT "Professor".surname ,"Professor".name , 'Professor'
	FROM "Professor"
	)
	UNION
	(
	SELECT "Labstaff".surname ,"Labstaff".name, 'Labstaff'
	FROM "Labstaff"
	))
	ORDER BY surname , name			

CLUSTER "Student" USING "Student_pkey" ;
CLUSTER "Labstaff" USING "Student_pkey" ;
CLUSTER "Professor" USING "Student_pkey" ;






CREATE INDEX surname_Student_idx ON "Student" USING btree (name,surname)
CLUSTER "Student" USING surname_Student_idx
DROP INDEX surname_Student_idx 

CREATE INDEX surname_Labstaff_idx ON "Labstaff" USING btree (name,surname)
CLUSTER "Labstaff" USING surname_Labstaff_idx
DROP INDEX surname_Labstaff_idx 

CREATE INDEX surname_Professor_idx ON "Professor" USING btree (name,surname)
CLUSTER "Professor" USING surname_Professor_idx
DROP INDEX surname_Professor_idx 


CREATE INDEX surname_Student_idx ON "Student" USING btree (surname)
CLUSTER "Student" USING surname_Student_idx
DROP INDEX surname_Student_idx 

CREATE INDEX surname_Labstaff_idx ON "Labstaff" USING btree (surname)
CLUSTER "Labstaff" USING surname_Labstaff_idx
DROP INDEX surname_Labstaff_idx 

CREATE INDEX surname_Professor_idx ON "Professor" USING btree (surname)
CLUSTER "Professor" USING surname_Professor_idx
DROP INDEX surname_Professor_idx 

EXPLAIN ANALYSE (SELECT insert_all_10000_test ('19-09-2002')) ;

