CREATE OR REPLACE FUNCTION public.process_valid_lesson_registration()
  RETURNS trigger AS $valid_lesson_registration$
  DECLARE 
   required boolean ;
   numOfLessons integer  ;
  BEGIN			 

	required := (EXISTS(SELECT anc  -- αν υπάρχουν προαπαιτούμενα που δεν τα έχει περάσει ο μαθητής
	FROM required_lessons 
	WHERE des IN 
		(SELECT course_code 
		FROM "CourseRun" CR  
		WHERE NEW.serial_number = CR.serial_number) AND
	      anc NOT IN  -- το course_code του μαθήματος που έκανε αίτηση ο φοιτητής	
		(SELECT course_code -- the courseruns (number of lessons) of the semester the student has applied for 
		FROM "CourseRun" CR 
		WHERE serial_number in   
			(SELECT serial_number FROM "Register" R WHERE R."Student_amka" = NEW."Student_amka" AND register_status = 'pass' )))) ;  -- serial_numbers of all CourseRuns the student has registered for 

	numOfLessons := (SELECT count(course_code) as lessons -- the courseruns (number of lessons) of the semester the student has applied for 
		FROM "CourseRun" CR 
		WHERE CR.serial_number in   
			(SELECT serial_number FROM "Register" R WHERE R."Student_amka" = NEW."Student_amka" AND register_status <> 'rejected' )  -- serial_numbers of all CourseRuns the student has registered for 
		AND CR.semester_id in
			(SELECT CR.semester_id FROM "CourseRun" CR WHERE NEW.serial_number = CR.serial_number)) ; -- the semester_id (one) of the CourseRun the student has applied for  >= 10) )  	

	IF ((required) OR (numOfLessons > 10)) THEN 
		NEW.register_status = 'rejected' ;	
	END IF ; 
	RETURN NEW;
	 			 
   END  
$valid_lesson_registration$
LANGUAGE plpgsql VOLATILE

SELECT anc  -- Εύρεση αλυσίδων συγκεκριμένων μαθημάτων
FROM required_lessons 
WHERE des = 'ΗΡΥ 302' ; 

SELECT anc  -- Εύρεση αλυσίδων συγκεκριμένων μαθημάτων
FROM required_lessons 
WHERE des = 'ΦΥΣ 102' ; 

-- 9 lessons for the same student of the same semester (id = 12)
INSERT INTO "Register" VALUES ('pass', null, 5 , null , 1262 , 3000054 ) ;
INSERT INTO "Register" VALUES ('pass', null, 5 , 5 , 1263 , 3000054 ) ;
INSERT INTO "Register" VALUES ('pass', null, 5 , null , 1264 , 3000054 ) ;
INSERT INTO "Register" VALUES ('pass', null, 5 , null , 1265 , 3000054 ) ;
INSERT INTO "Register" VALUES ('pass', null, 5 , 5, 1266 , 3000054 ) ;
INSERT INTO "Register" VALUES ('pass', null, 5 , null , 1267 , 3000054 ) ;
INSERT INTO "Register" VALUES ('pass', null, 5 , 5 , 1268 , 3000054 ) ;
INSERT INTO "Register" VALUES ('pass', null, 5 , null , 1269 , 3000054 ) ;
INSERT INTO "Register" VALUES ('pass', null, 5 , 5 , 1270 , 3000054 ) ; -- HΡΥ 203
   
--SELECT insert_courseRun (9) ; 

-- The tenth lesson (Update them to approved) of the same semester

-- ΗΡΥ 302 with required : HΡΥ 203 , HΡΥ 101
INSERT INTO "Register" VALUES ('proposed', null, 5 , 5 , 1277 , 3000054 ) ; -- must reject because of prereq (set one of them to fail)
INSERT INTO "Register" VALUES ('requested', null, 5 , 5 , 1277 , 3000054 ) ; -- must accept (fail-> pass)

-- The eleventh lesson of the same semester

INSERT INTO "Register" VALUES ('proposed', null, 5 , 5 , 1277 , 3000054 ) -- must reject because of lessons
INSERT INTO "Register" VALUES ('requested', null, 5 , 5 , 1277 , 3000054 ) -- must reject because of both (set one of them to fail)

SELECT R."Student_amka" , R.register_status
FROM "Register" R
WHERE R."Student_amka" = 3000054

-- Ελέγχω και για διαφορετικά εξάμηνα (Καταχωρώ το ΗΡΥ 101 σε άλλο εξαμηνο και το βάζω ως fail)
--insert_courseRun
INSERT INTO "Register" VALUES ('fail', null, 5 , 5 , 1271 , 3000054) ; -- HΡΥ 101
INSERT INTO "Register" VALUES ('fail', null, 5 , 5 , 1271 , 3000055) ; -- HΡΥ 101
-- Δεν πρέπει να καταμετράει τις εγγραφές , μονο το αν τα έχει περάσει ή όχι

-- Μαθημα χωρίς προαπαιτούμενο

INSERT INTO "Register" VALUES ('pass', null, 5 , 5 , 1268 , 3000054 ) ; -- ΦΥΣ 102
   

		

