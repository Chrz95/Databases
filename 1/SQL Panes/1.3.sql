CREATE OR REPLACE FUNCTION public.years_passed_from_date(entry_date date) -- 1.3
  RETURNS numeric AS
$BODY$
BEGIN
	RETURN (left(((now() - entry_date)::character varying (20)),4)::numeric) / 365 ; -->5 because with equal is minus one day
END;
$BODY$
  LANGUAGE plpgsql VOLATILE

CREATE OR REPLACE FUNCTION public.insert_uncomp_thesis_grade() -- 1.3
  RETURNS void AS
$BODY$
BEGIN
	UPDATE "Diploma"	
	SET thesis_grade = floor(random()*(10-5+1))+5 -- random grade in [5,10]
	WHERE thesis_grade is null AND "Student_amka" IN
	(SELECT St.amka
	FROM "Student" St
	WHERE years_passed_from_date(St.entry_date) > 5) ;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE

-- thesis_grade, thesis_title ,diploma_grade, graduation_date, , Student_amka, Supervisor ,Committee_1 , Committee_2 , (diploma_num)

Check the entry_date of Student_amka student

INSERT INTO "Diploma" VALUES (null,'adadf',null,'12-1-2017',3000001,1000001,1000002,1000003);  
INSERT INTO "Diploma" VALUES (8,'adadf',null,'12-1-2017',3000002,1000001,1000002,1000003); 
INSERT INTO "Diploma" VALUES (null,'adadf',null,'12-1-2017',3000003,1000001,1000002,1000003);   
INSERT INTO "Diploma" VALUES (8,'adadf',null,'12-1-2017',3000004,1000001,1000002,1000003); 
INSERT INTO "Diploma" VALUES (null,'adadf',null,'12-1-2017',3000005,1000001,1000002,1000003);
INSERT INTO "Diploma" VALUES (null,'adadf',null,'12-1-2017',3000006,1000001,1000002,1000003); 
INSERT INTO "Diploma" VALUES (8,'adadf',null,'12-1-2017',3000007,1000001,1000002,1000003); 

SELECT insert_uncomp_thesis_grade();



  ALTER TABLE public."Diploma"
  ADD CONSTRAINT "Diploma_Committee_1_fkey" FOREIGN KEY ("Committee_1")
      REFERENCES public."Professor" (amka) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE;
      
ALTER TABLE public."Diploma"
  ADD CONSTRAINT "Diploma_Committee_2_fkey" FOREIGN KEY ("Committee_2")
      REFERENCES public."Professor" (amka) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE;

      ALTER TABLE public."Diploma"
  ADD CONSTRAINT "Diploma_Supervisor_fkey" FOREIGN KEY ("Supervisor")
      REFERENCES public."Professor" (amka) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE;
