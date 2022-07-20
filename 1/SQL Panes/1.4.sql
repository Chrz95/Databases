CREATE OR REPLACE FUNCTION diploma_input(am integer, amka_supervisor integer, amka_member1 integer, amka_member2 integer)
RETURNS VOID AS
$$
DECLARE
student_amka := getAmka(am) ;
BEGIN
	INSERT INTO "Diploma" ("Student_amka", "Supervisor", "Committee_1", "Committee_2", thesis_title)
	VALUES (student_amka, amka_supervisor, amka_member1, amka_member2, concat('thesis_of_student_',student_amka :: character varying (10) ));
END;
$$
LANGUAGE 'plpgsql' VOLATILE;

SELECT diploma_input (201100001,1000001,1000002,1000003) 
SELECT diploma_input (201100001,1000001,1000001,1000003) -- error because of same amka

CREATE OR REPLACE FUNCTION getAmka (am_param integer)
RETURNS integer AS
$$
BEGIN
	return (SELECT S.amka FROM "Student" S WHERE am_param = S.am)
END;
$$
LANGUAGE 'plpgsql' VOLATILE;