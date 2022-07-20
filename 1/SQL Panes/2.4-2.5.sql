CREATE OR REPLACE FUNCTION public.obligatory_lessons_of_student(amka_param integer) -- 2.4
  RETURNS TABLE(code character, title character) AS
$BODY$
BEGIN
 RETURN QUERY
 ((SELECT DISTINCT C.course_code , C.course_title -- All obligatory lessons
 FROM "Course" C 
 WHERE C.obligatory ) 
 EXCEPT
(SELECT DISTINCT C.course_code , C.course_title-- The obligatory lessons , in which the student succeeded
 FROM "Course" C , "CourseRun" CR , "Register" R 
 WHERE C.obligatory AND C.course_code = CR.course_code AND R.final_grade >= 5 AND R.register_status = 'approved' AND CR.serial_number = R.serial_number AND R."Student_amka" = amka_param ));
END;
$BODY$
  LANGUAGE plpgsql VOLATILE

CREATE OR REPLACE FUNCTION public.sector_with_most_thesis()  -- 2.5
  RETURNS TABLE(Code integer , Title character (100) , NumOFSect integer) AS
$BODY$
BEGIN
 RETURN QUERY

SELECT  subquerry.sector_code ,  subquerry.sector_title , subquerry.numofSect FROM

	(SELECT  S.sector_code ,  S.sector_title , count(*)::integer as numofSect
	FROM "Sector" S , "Lab" L , "Professor" P , "Diploma" D
	WHERE D."Supervisor" = P.amka AND P."Lab_id_works" = L.lab_code AND S.sector_code = L.sector_code 
	GROUP BY S.sector_code ,  S.sector_title) as subquerry
	
WHERE subquerry.numofSect >= ALL 	

	(SELECT  count(*)::integer as numofSect
	FROM "Sector" S , "Lab" L , "Professor" P , "Diploma" D
	WHERE D."Supervisor" = P.amka AND P."Lab_id_works" = L.lab_code AND S.sector_code = L.sector_code 
	GROUP BY S.sector_code ,  S.sector_title) ;	

END;
$BODY$
  LANGUAGE plpgsql VOLATILE

-- 2.4 TEST

SELECT insert_students('12-10-2012',40);

-- semester_id , exam_min , lab_min , exam_percentage , amka1 , lab_id , course_code , amka2 , (serial_number)
INSERT INTO "CourseRun" VALUES (1,1, 1, 1,1001188,null,'ΑΓΓ 101',null); 
INSERT INTO "CourseRun" VALUES (3,1, 1, 1,1001188,null,'ΑΓΓ 102',null); 
INSERT INTO "CourseRun" VALUES (1,1, 1, 1,1001188,null,'ΚΕΠ 102',null); -- not obligatory 
INSERT INTO "CourseRun" VALUES (3,1, 1, 1,1001188,null,'ΑΓΓ 201',null); 
INSERT INTO "CourseRun" VALUES (1,1, 1, 1,1001188,null,'ΑΓΓ 202',null); 
INSERT INTO "CourseRun" VALUES (3,1, 1, 1,1001188,null,'ΚΕΠ 101',null); -- not obligatory 

--Register_status , final_grade , exam_grade , lab_grade,  Serial_number , Student_amka
INSERT INTO "Register" VALUES ('approved',5,5,5,1000000043,3000753) ;
INSERT INTO "Register" VALUES ('approved',4,6,7,1000000044,3000753) ;
INSERT INTO "Register" VALUES ('approved',8,5,3,1000000049,3000754) ;
INSERT INTO "Register" VALUES ('approved',8,5,3,1000000050,3000755) ;
INSERT INTO "Register" VALUES ('approved',8,5,3,1000000051,3000755) ;
INSERT INTO "Register" VALUES ('approved',8,5,3,1000000052,3000757) ;

SELECT obligatory_lessons_of_student(3000755) ;

-- 2.5 ΤΕST

SELECT insert_professors(40);
SELECT insert_students('12-10-2012',40);

-- diploma_input(amka integer, amka_supervisor integer, amka_member1 integer, amka_member2 integer, title character varying(30))
SELECT diploma_input (3000757,1001237,1001238,1001239,'thesis_of_dsd');
SELECT diploma_input (3000758,1001240,1001241,1001242,'thesis_of_dsd');
SELECT diploma_input (3000759,1001243,1001244,1001245,'thesis_of_dsd');
SELECT diploma_input (3000760,1001246,1001247,1001248,'thesis_of_dsd');
SELECT diploma_input (3000761,1001249,1001250,1001251,'thesis_of_dsd');

SELECT sector_with_most_thesis() ; 
