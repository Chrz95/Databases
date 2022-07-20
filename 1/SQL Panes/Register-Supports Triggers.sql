INSERT INTO "Supports" VALUES (54, 2000015) ; -- Accepted because the lesson has lab
INSERT INTO "Supports" VALUES (51, 2000015 ) ;-- Rejected because the lesson has not lab

INSERT INTO "Register" VALUES ('approved',null,6,7,54,3000010) ; -- has lab accepted
INSERT INTO "Register" VALUES ('approved',null,5,null,51,3000010) ; -- has not lab accepted
INSERT INTO "Register" VALUES ('approved',null,3,5,51,3000010) ; -- -- has not lab rejected


-- make updates too
