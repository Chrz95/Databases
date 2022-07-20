SELECT insert_professors(40);


     CREATE VIEW lessons_of_current_semester (Code , Title , Names ) AS -- 4.1
(SELECT DISTINCT C.course_code , C.course_title , concat('(',P1.surname,',',P1.name,'),(',P2.surname,',', P2.name, ')' )  -- The tuples whose prof_amka 2 is not null
FROM "Course" C,  "CourseRun" CR , "Semester" S , "Professor" P1 ,"Professor" P2 
WHERE C.course_code =  CR.course_code AND S.semester_status = 'present' AND  CR.semester_id = S.semester_id AND CR."Professor_amka1" = P1.amka AND CR."Professor_amka2" = P2.amka AND (CR."Professor_amka2" is not null ))
UNION
(SELECT DISTINCT C.course_code , C.course_title , concat('(',P1.surname,',',P1.name,'),(',null,',', null, ')' )  -- The tuples whose prof_amka 2 is null
FROM "Course" C,  "CourseRun" CR , "Semester" S , "Professor" P1 
WHERE C.course_code =  CR.course_code AND S.semester_status = 'present' AND  CR.semester_id = S.semester_id AND CR."Professor_amka1" = P1.amka AND (CR."Professor_amka2" is null ));


-- semester_id , exam_min , lab_min , exam_percentage , amka1 , lab_id , course_code , amka2 , (serial_number)
INSERT INTO "CourseRun" VALUES (10,1, 1,1, 1000001, 1,'HPY 416', 1000002); --different amkas not present semester
INSERT INTO "CourseRun" VALUES (10,null, null,null, 1000003, 1,'ΑΓΓ 101', 1000004); --different amkas 
INSERT INTO "CourseRun" VALUES (10,null, null,null, null, null,'ΑΓΓ 102', 1000005); -- one is null - rejected
INSERT INTO "CourseRun" VALUES (10,null, null,null,1000006, 3,'ΑΓΓ 201', null); -- one is null
INSERT INTO "CourseRun" VALUES (10,null, null,null, null, null,'ΑΓΓ 202', null); -- both are null - rejected

INSERT INTO "Semester" VALUES (2006,'spring', '06-02-2013', '30-5-2013','past'); 
INSERT INTO "Semester" VALUES (2007,'winter', '19-9-2012', '16-12-2012','present'); 
INSERT INTO "Semester" VALUES (2008,'spring', '06-02-2013', '30-5-2013','future'); 
