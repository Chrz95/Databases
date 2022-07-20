CREATE OR REPLACE FUNCTION insert_students(entry_date_param date, numOfEntries integer) -- 1.1
RETURNS VOID AS
$$
BEGIN  

  IF NOT EXISTS (SELECT * FROM "Student" St WHERE St.entry_date =  entry_date_param) THEN  -- if there is no student of the same year
	PERFORM (setval('"am_seq"',1,'false')) ;
  ELSE 
	PERFORM (setval('"am_seq"',right((SELECT max(am) FROM "Student" St WHERE St.entry_date =  entry_date_param)::character varying (20),6)::bigint))  ;
  END IF ;

  PERFORM (nextval('"Student_amka_seq"')) ;

  INSERT INTO "Student"
  SELECT name , concat( (currval('"Student_amka_seq"') + 1)  :: character varying (20) , random_pick(enum_range(NULL::email_type))) , father_name , adapt_surname(surname,sex), entry_date_param , create_am(date_part('year', entry_date_param)::integer,(nextval('"am_seq"')) ::integer)::integer
  FROM (random_names(numOfEntries) n JOIN random_surnames(numOfEntries) s USING (id) ) JOIN random_father_names (numOfEntries) f USING (id) ;
  
END;
$$
LANGUAGE 'plpgsql' VOLATILE;

SELECT insert_students('12-10-2012',5);
SELECT insert_students('12-10-2012',5);
SELECT insert_students('12-10-2013',5);

SELECT insert_all (10,'12-10-2013') -- 1.1
