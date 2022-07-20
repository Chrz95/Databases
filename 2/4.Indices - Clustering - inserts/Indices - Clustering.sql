VACUUM ANALYSE

-- 2.1

--CREATE INDEX index_name ON table USING hash (table_attribute)
--DROP INDEX index_name
--CLUSTER table USING index_name ; 

CREATE INDEX student_am_idx ON "Student" USING hash (am)
--DROP INDEX student_am_idx
CLUSTER "Student" USING student_am_idx ;
EXPLAIN (ANALYSE,BUFFERS) SELECT search_student_2_1(IN searcham bigint) ; 

-- 2.2

CREATE INDEX course_code_idx ON "CourseRun" USING hash (course_code)
--DROP INDEX course_code_idx
CLUSTER "CourseRun" USING course_code_idx ;


CREATE INDEX cr_semester_id_idx ON "CourseRun" USING hash (semester_id)
--DROP INDEX cr_semester_id_idx
CLUSTER "CourseRun" USING cr_semester_id_idx ;

CREATE INDEX sm_semester_id_idx ON "Semester" USING hash (semester_id)
--DROP INDEX sm_semester_id_idx
CLUSTER "CourseRun" USING sm_semester_id_idx ;


CREATE INDEX semester_status_idx ON "Semester" USING hash (semester_status)
--DROP INDEX semester_status_idx
CLUSTER "Semester" USING semester_status_idx ;


CREATE INDEX cr_serial_idx ON "CourseRun" USING hash (serial_number)
--DROP INDEX cr_serial_idx
CLUSTER "CourseRun" USING cr_serial_idx ;

CREATE INDEX sm_serial_idx ON "Semester" USING hash (serial_number)
--DROP INDEX sm_serial_idx
CLUSTER "Semester" USING sm_serial_idx ;


CREATE INDEX st_student_amka_idx ON "Student" USING hash (amka)
--DROP INDEX st_student_amka_idx
CLUSTER "Student" USING st_student_amka_idx ;

CREATE INDEX rg_student_amka_idx ON "Register" USING hash ("Student_amka")
--DROP INDEX rg_student_amka_idx
CLUSTER "Register" USING rg_student_amka_idx ;


CREATE INDEX register_status_idx ON "Register" USING hash (register_status)
--DROP INDEX register_status_idx
CLUSTER "Register" USING register_status_idx ;

EXPLAIN (ANALYSE,BUFFERS) SELECT student_by_code_2_2(IN tempcode character varying) ;

-- 2.3

--CREATE INDEX st_student_amka_idx ON "Student" USING hash (amka)
--DROP INDEX st_student_amka_idx
--CLUSTER "Student" USING st_student_amka_idx ; 

CREATE INDEX labstaff_amka_idx ON "Labstaff" USING hash (amka)
--DROP INDEX labstaff_amka_idx
CLUSTER "Labstaff" USING labstaff_amka_idx ; 

CREATE INDEX professor_amka_idx ON "Professor" USING hash (amka)
--DROP INDEX professor_amka_idx
CLUSTER "Professor" USING professor_amka_idx ; 
EXPLAIN (ANALYSE,BUFFERS) SELECT show_people_2_3() ; 



--  WHERE "Student".am = searcham);

-- "CourseRun".course_code = tempcode 
--AND "CourseRun".semester_id = "Semester".semester_id 
--AND "Semester".semester_status = 'present' 
--AND "CourseRun".serial_number = "Register".serial_number 
--AND "Register"."Student_amka" = "Student".amka
--AND "Register".register_status = 'approved'