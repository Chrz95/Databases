INSERT INTO "Semester" VALUES (null,null, '06-02-2013', '30-5-2013','future'); -- change into present
INSERT INTO "Semester" VALUES (null,null, '19-09-2013', '25-12-2013','future'); -- remains future
INSERT INTO "Semester" VALUES (null,null, '19-09-2014', '25-12-2014','future'); -- remains future

-- semester_id , exam_min , lab_min , exam_percentage , amka1 , lab_id , course_code , amka2 , (serial_number)
INSERT INTO "CourseRun" VALUES (7,5, 5, 70,1000001,null,'ΑΓΓ 101',null); -- has not lab -- rejected because of courserun_rules
INSERT INTO "CourseRun" VALUES (7,null, null, null,1000001,null,'ΑΓΓ 101',null); -- has not lab
INSERT INTO "CourseRun" VALUES (8,null, null, null,1000001,null,'ΑΓΓ 101',null); -- has not lab
INSERT INTO "CourseRun" VALUES (7,null, null, null,1000001,null,'ΑΓΓ 102',null); -- has not lab
INSERT INTO "CourseRun" VALUES (7,null, null, null,1000001,null,'ΕΝΕ 301',null); -- has lab -- rejected because of courserun_rules
INSERT INTO "CourseRun" VALUES (7,5, 5, 70,1000001,1,'ΕΝΕ 301',null); -- has lab
INSERT INTO "CourseRun" VALUES (7,5, 5, 70,1000001,2,'ΗΡΥ 302',null); -- has lab
INSERT INTO "CourseRun" VALUES (8,5, 5, 10,1000001,3,'ΗΡΥ 302',null); -- has lab

--Register_status , final_grade , exam_grade , lab_grade,  Serial_number , Student_amka

--AΓΓ 101 - same serial_number
INSERT INTO "Register" VALUES ('approved',null,5,5,15,3000001) ; -- final_grade = null
INSERT INTO "Register" VALUES ('approved',null,6,null,15,3000002) ; -- final_grade = lab_grade =  null
INSERT INTO "Register" VALUES ('approved',null,null,null,15,3000003) ; -- final_grade =  exam_grade = lab_grade  = null
INSERT INTO "Register" VALUES ('approved',null,null,null,15,3000004) ; -- final_grade = exam_grade =  null

--ΑΓΓ 102
INSERT INTO "Register" VALUES ('approved',null,5,5,17,3000001) ; -- final_grade = null
INSERT INTO "Register" VALUES ('approved',null,6,null,17,3000002) ; -- final_grade = lab_grade =  null
INSERT INTO "Register" VALUES ('approved',null,null,null,17,3000003) ; -- final_grade =  exam_grade = lab_grade  = null
INSERT INTO "Register" VALUES ('approved',null,null,null,17,3000004) ; -- final_grade = exam_grade =  null

--ΕΝΕ 301
INSERT INTO "Register" VALUES ('approved',null,5,5,19,3000001) ; -- final_grade = null
INSERT INTO "Register" VALUES ('approved',null,6,null,19,3000002) ; -- final_grade = lab_grade =  null
INSERT INTO "Register" VALUES ('approved',null,null,null,19,3000003) ; -- final_grade =  exam_grade = lab_grade  = null
INSERT INTO "Register" VALUES ('approved',null,null,null,19,3000004) ; -- final_grade = exam_grade =  null

--ΗΡΥ 302
INSERT INTO "Register" VALUES ('approved',null,5,5,20,3000001) ; -- final_grade = null
INSERT INTO "Register" VALUES ('approved',null,6,null,20,3000002) ; -- final_grade = lab_grade =  null
INSERT INTO "Register" VALUES ('approved',null,null,null,20,3000003) ; -- final_grade =  exam_grade = lab_grade  = null
INSERT INTO "Register" VALUES ('approved',null,null,null,20,3000004) ; -- final_grade = exam_grade =  null


SELECT grade_input() ;


CREATE TRIGGER courserun_assigned_labstaff_lab
  BEFORE INSERT OR UPDATE
  ON public."CourseRun"
  FOR EACH ROW
  EXECUTE PROCEDURE public.process_courserun_assigned_labstaff_and_lab();

