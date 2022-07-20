CREATE OR REPLACE FUNCTION insert_labstaff(numOfEntries integer) -- Labstaff
RETURNS VOID AS
$$
BEGIN
	INSERT INTO "Labstaff"
	-- name email father_name , surname ,  lab_id , level , (amka)	
	SELECT n.name , concat( (currval('"Labstaff_amka_seq"') + 1)  :: character varying (20) , random_pick(enum_range(NULL::email_type))) , father_name ,  adapt_surname(s.surname,n.sex) ,  random_lab_id()  , random_pick(enum_range(NULL::level_type))::level_type 
	FROM ((random_names(numOfEntries) n JOIN random_surnames(numOfEntries) s USING (id)) JOIN random_father_names (numOfEntries) f USING (id)) ;
END;
$$
LANGUAGE 'plpgsql' VOLATILE;

SELECT insert_labstaff(40);

CREATE OR REPLACE FUNCTION insert_students(entry_date date, numOfEntries integer) -- Student
RETURNS VOID AS
$$
BEGIN
	INSERT INTO "Student"
	SELECT name , concat( (currval('"Student_amka_seq"') + 1)  :: character varying (20) , random_pick(enum_range(NULL::email_type))) , father_name , adapt_surname(surname,sex), entry_date , create_am(date_part('year', entry_date)::integer,n.id)::integer
	FROM (random_names(numOfEntries) n JOIN random_surnames(numOfEntries) s USING (id) ) JOIN random_father_names (numOfEntries) f USING (id) ;
END;
$$
LANGUAGE 'plpgsql' VOLATILE;

SELECT insert_students('12-10-2014',40);

CREATE OR REPLACE FUNCTION insert_professors(numOfEntries integer) -- Professor
RETURNS VOID AS
$$
BEGIN
	INSERT INTO "Professor"
	-- name email father_name , surname , rank,  lab_id , (amka)	
	SELECT n.name , concat( (currval('"Professor_amka_seq"') + 1)  :: character varying (20) , random_pick(enum_range(NULL::email_type))), father_name ,  adapt_surname(s.surname,n.sex) ,  random_pick(enum_range(NULL::rank_type))::rank_type  ,  random_lab_id()
	FROM ((random_names(numOfEntries) n JOIN random_surnames(numOfEntries) s USING (id)) JOIN random_father_names (numOfEntries) f USING (id)) ;
END;
$$
LANGUAGE 'plpgsql' VOLATILE;

SELECT insert_professors(40);

 CREATE OR REPLACE FUNCTION random_lab_id() -- DONE
RETURNS double precision AS
$$	
	SELECT floor(random()*(lb.max-lb.min+1))+lb.min 
	FROM (SELECT max(L.lab_code)  max, min(L.lab_code )  as min
	FROM "Lab" L) as lb;
$$
LANGUAGE 'sql' ; 