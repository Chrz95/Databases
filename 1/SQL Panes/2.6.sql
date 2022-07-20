CREATE OR REPLACE FUNCTION public.grad_students_who_have_not_grad() -- 2.6
  RETURNS TABLE(am bigint) AS
$BODY$
BEGIN
 RETURN QUERY 
SELECT St.am 
FROM "Student" St , "Register" R , "CourseRun" CR , "Course" C ,"Graduation_rules" G 
WHERE St.amka = R."Student_amka" AND R.register_status = 'pass' AND CR.serial_number = R.serial_number AND CR.course_code = C.course_code AND (date_part('year',St.entry_date)::integer = G.year) AND St.amka NOT IN 
	(SELECT "Student_amka" 
	FROM "Diploma" 
	WHERE diploma_grade is not null AND graduation_date is not null )
GROUP BY St.am , min_courses , min_units 
HAVING count(CR.course_code) >= min_courses AND sum(units)>=min_units ;
 END;
$BODY$
  LANGUAGE plpgsql VOLATILE

  CREATE OR REPLACE FUNCTION public.grad_students_who_have_not_grad_test() -- 2.6 -- returns amka too
  RETURNS TABLE(am bigint , amka integer) AS
$BODY$
BEGIN
 RETURN QUERY 
SELECT St.am , St.amka
FROM "Student" St , "Register" R , "CourseRun" CR , "Course" C ,"Graduation_rules" G 
WHERE St.amka = R."Student_amka" AND R.register_status = 'pass' AND CR.serial_number = R.serial_number AND CR.course_code = C.course_code AND (date_part('year',St.entry_date)::integer = G.year) AND St.amka NOT IN 
	(SELECT "Student_amka" 
	FROM "Diploma" 
	WHERE diploma_grade is not null AND graduation_date is not null )
GROUP BY St.am , St.amka , min_courses , min_units 
HAVING count(CR.course_code) >= min_courses AND sum(units)>=min_units ;
 END;
$BODY$
  LANGUAGE plpgsql VOLATILE


-- set some low graduation rules 

   INSERT INTO "Register" VALUES ('pass', null, 5 , null , 1262 , 3000041 ) ; -- must appear -- must appear
   INSERT INTO "Register" VALUES ('pass', null, 5 , 5 , 1263 , 3000041 ) ; 
   INSERT INTO "Register" VALUES ('pass', null, 5 , null , 1264 , 3000041 ) ; 
   INSERT INTO "Register" VALUES ('pass', null, 5 , null , 1265 , 3000041 ) ; 

   INSERT INTO "Register" VALUES ('pass', null, 5 , null , 1265 , 3000042 ) ; -- must appear -- will give him diploma with null values so must appear
   INSERT INTO "Register" VALUES ('pass', null, 5 , 5 , 1266 , 3000042 ) ; 
   INSERT INTO "Register" VALUES ('pass', null, 5 , null , 1267 , 3000042 ) ; 
   INSERT INTO "Register" VALUES ('pass', null, 5 , 5 , 1268 , 3000042 ) ; 

   INSERT INTO "Register" VALUES ('pass', null, 5 , null , 1267 , 3000043 ) ; -- must appear -- will give him diploma after so must not appear
   INSERT INTO "Register" VALUES ('pass', null, 5 , 5 , 1268,  3000043 ) ; 
   INSERT INTO "Register" VALUES ('pass', null, 5 , null , 1269 , 3000043 ) ; 
   INSERT INTO "Register" VALUES ('pass', null, 5 , 5 , 1270 , 3000043 ) ; 

   INSERT INTO "Register" VALUES ('pass', null, 5 , null , 1265 , 3000047 ) ; -- must appear
   INSERT INTO "Register" VALUES ('pass', null, 5 , 5 , 1266 , 3000047 ) ; 
   INSERT INTO "Register" VALUES ('pass', null, 5 , null , 1267 , 3000047 ) ; 
   INSERT INTO "Register" VALUES ('pass', null, 5 , 5 , 1268 , 3000047 ) ; 

   -- must not appear -- AΓΓ

   INSERT INTO "Register" VALUES ('pass', null, 5 , null , 1262 , 3000048 ) ; -- not enough min courses and units
   INSERT INTO "Register" VALUES ('pass', null, 5 , null , 1325 , 3000048 ) ; 
   INSERT INTO "Register" VALUES ('pass', null, 5 , null , 1318 , 3000048 ) ;

   INSERT INTO "Register" VALUES ('pass', null, 5 , null , 1262 , 3000051 ) ; -- not enough min courses and units
   INSERT INTO "Register" VALUES ('fail', null, 5 , null , 1270 , 3000051 ) ; 
   INSERT INTO "Register" VALUES ('pass', null, 5 , null , 1318 , 3000051 ) ; 	

   INSERT INTO "Register" VALUES ('pass', null, 5 , null , 1262 , 3000050 ) ;  -- not enough courses
   INSERT INTO "Register" VALUES ('pass', null, 5 , null , 1270 , 3000050 ) ; 
   INSERT INTO "Register" VALUES ('pass', null, 5 , null , 1264 , 3000050 ) ; 	

   INSERT INTO "Register" VALUES ('pass', null, 5 , null , 1262 , 3000052 ) ; -- not units
   INSERT INTO "Register" VALUES ('pass', null, 5 , null , 1269 , 3000052 ) ;
   INSERT INTO "Register" VALUES ('pass', null, 5 , null , 1325 , 3000052 ) ; 
   INSERT INTO "Register" VALUES ('pass', null, 5 , null , 1318 , 3000052 ) ;
   
 -- SELECT insert_courseRun (9) ; 

SELECT grad_students_who_have_not_grad_test() 

-- thesis grade , thesis title , diploma_grade , graduation_date , student amka , Supervisor , Committee_1 , Committee_2
INSERT INTO "Diploma" VALUES (5,'gdghegh',5,null,3000042,1000001,1000002,1000003) ;
INSERT INTO "Diploma" VALUES (5,'gdghegh',5,'12-5-2017',3000043,1000001,1000002,1000003) ;
INSERT INTO "Diploma" VALUES (5,'gdghegh',5,'12-5-2017',3000050,1000001,1000002,1000003) ;

SELECT grad_students_who_have_not_grad_test() -- Πρέπει να εμφανίσει λιγότερους (όχι το 3000043)