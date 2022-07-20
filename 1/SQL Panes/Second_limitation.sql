
-- new test

-- semester_id , exam_min , lab_min , exam_percentage , amka1 , lab_id , course_code , amka2 , (serial_number)

INSERT INTO "CourseRun" VALUES (10,null, null, null,1000010,null,'ΑΓΓ 202',null); -- Check what happens if only one amka is null  (accepted) since it has no lab

INSERT INTO "CourseRun" VALUES (10,null, null, null,1000010,null,'ΑΓΓ 101',null); -- Check what happens if both amkas are null  (accepted)  - doesn't have lab 
INSERT INTO "CourseRun" VALUES (10,null, null, null,1000010,null,'ΑΓΓ 102',null);
INSERT INTO "CourseRun" VALUES (10,null, null, null,1000010,null,'ΜΑΘ 101',null);
INSERT INTO "CourseRun" VALUES (10,null, null, null,1000010,null,'ΑΓΓ 201',null); 
INSERT INTO "CourseRun" VALUES (10,null, null, null, 1000010,null,'ΑΓΓ 202',null); 

INSERT INTO "CourseRun" VALUES (10,1, 1, 1,null,2,'HPY 416',null);  -- Check what happens if both amkas are null  (accepted)    - has lab -- lab assigned and in supports -- Will allow assignment
INSERT INTO "CourseRun" VALUES (10,1, 1, 1,null,null,'ΗΡΥ 101',null);  -- Check what happens if both amkas are null    - has lab -- lab not assigned and in supports -- Will allow assignment
INSERT INTO "CourseRun" VALUES (10,1, 1, 1,null,3,'ΗΡΥ 102',null);  -- Check what happens if both amkas are null    - has lab -- lab assigned and not in supports -- Will not allow assignment
INSERT INTO "CourseRun" VALUES (10,1, 1, 1,null,null,'ΗΡΥ 201',null);  -- Check what happens if both amkas are null    - has lab -- lab not assigned and not in supports -- Will not allow assignment

SELECT insert_labstaff(40);

-- serial_number , Labstaff_amka

INSERT INTO "Supports" VALUES (54, 2000010) ; 
INSERT INTO "Supports" VALUES (55, 2000010 ) ;

-- Test update (με το χέρι στον πίνακα)


