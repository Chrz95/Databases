CREATE INDEX student_surname_idx ON "Student_small" USING btree (surname)
CREATE INDEX student_name_idx ON "Student_small" USING  btree(name)
CLUSTER "Student_small" USING student_name_idx
DROP INDEX student_surname_idx ;
EXPLAIN ANALYSE (SELECT * FROM "Student_small" WHERE surname='ΙΝΕΜΠΟΛΙΔΗ'and name = 'ΜΥΡΟΠΗ');

CLUSTER "Student_small" USING "Student_small_pkey" ; -- Αυτό αναιρεί το clustering

-- Εκτελούμε το explain πολλες φορές και βάζουμε τον ελάχιστο χρόνο στην αναφορά 
-- Μας νοιάζει μονο το actual time
-- Στο δευτερο ερώτημα μόνο analyse
-- O πρώτος αριθμός στο actual time είναι χρόνος που χρειαστηκε για την πρώτη πλειάδα
-- Βαζω και την γραφική εξήγηση

-- Δοκιμαζω 0)χωρις τίποτα 1)b-tree 2)b-tree με clustering 3)hash χωρις clustering 4)hash με clustering (μπορει να μην γίνεται κρατω όμως σημειωση οτι με hash
--δεν μπορει να κανει clustering η Postgres) 

-- Με clustering οι πλειαδες με το ιδιο name (κλειδι επειδη στο clustering χρησιμοποιήσαμε το ευρετήριο του name)  θα εμφανίζονται στην ιδια σελίδα
-- ΠΡΟΣΟΧΗ Αν εχουμε βάλει index σε δυο attribute του ιδιου πίνακα θα χρησιμοποιηθει ένα απο τα δυο για την εκτέλεση του ερωτήματος αναλογα με το selectivity απο το pg_catalog
-- Κανουμε πολλες δοκιμες , να είμαστε αναλυτικοί

EXPLAIN ANALYSE (SELECT s.surname, s.name, n.sex FROM "Student_small" s JOIN "Name" n using (name)); 
-- Eιναι περιττο να μπεί ευρετήριο στο name γιατι υπάρχει ήδη΄στο n.name καθώς είναι κλειδι στον πίνακα name αρα εχει δημιουργηθεί αυτόματα
-- Μπορώ να κάνω off τα hash join για να τον αναγκάσουμε να χρησιμοποιήσει τα ευρετηριά μας . 

set enable_hashjoin = off -- O χρονος αυξήθηκε  (χρησιμοποιησε το merge join)
set enable_mergejoin = off -- o χρονος μειωθηκε (χρησιμοποιησε το nested loop join)

