--------------------------------------------------------
--  ������ ������ - �����-10��-24-2024   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Table BOARD
--------------------------------------------------------

  CREATE TABLE "BOARD" 
   (	"BNO" NUMBER, 
	"ID" VARCHAR2(50 BYTE), 
	"TITLE" VARCHAR2(150 BYTE), 
	"WRITE_DATE" DATE DEFAULT sysdate, 
	"WRITE_UPDATE_DATE" DATE DEFAULT sysdate, 
	"BCOUNT" NUMBER DEFAULT 0, 
	"CONTENT" CLOB
   ) ;
--------------------------------------------------------
--  DDL for Table BOARD_COMMENT
--------------------------------------------------------

  CREATE TABLE "BOARD_COMMENT" 
   (	"CNO" NUMBER, 
	"BNO" NUMBER, 
	"ID" VARCHAR2(50 BYTE), 
	"CONTENT" VARCHAR2(1000 BYTE), 
	"CDATE" DATE DEFAULT sysdate
   ) ;
--------------------------------------------------------
--  DDL for Table BOARD_COMMENT_HATE
--------------------------------------------------------

  CREATE TABLE "BOARD_COMMENT_HATE" 
   (	"ID" VARCHAR2(50 BYTE), 
	"CNO" NUMBER
   ) ;
--------------------------------------------------------
--  DDL for Table BOARD_COMMENT_LIKE
--------------------------------------------------------

  CREATE TABLE "BOARD_COMMENT_LIKE" 
   (	"ID" VARCHAR2(50 BYTE), 
	"CNO" NUMBER
   ) ;
--------------------------------------------------------
--  DDL for Table BOARD_CONTENT_HATE
--------------------------------------------------------

  CREATE TABLE "BOARD_CONTENT_HATE" 
   (	"BNO" NUMBER, 
	"ID" VARCHAR2(50 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table BOARD_CONTENT_LIKE
--------------------------------------------------------

  CREATE TABLE "BOARD_CONTENT_LIKE" 
   (	"BNO" NUMBER, 
	"ID" VARCHAR2(50 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table BOARD_FILE
--------------------------------------------------------

  CREATE TABLE "BOARD_FILE" 
   (	"FNO" CHAR(10 BYTE), 
	"BNO" NUMBER, 
	"FPATH" VARCHAR2(256 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table BOARD_MEMBER
--------------------------------------------------------

  CREATE TABLE "BOARD_MEMBER" 
   (	"ID" VARCHAR2(50 BYTE), 
	"PASSWORD" CHAR(128 BYTE), 
	"USERNAME" VARCHAR2(50 BYTE), 
	"NICKNAME" VARCHAR2(50 BYTE)
   ) ;
--------------------------------------------------------
--  Constraints for Table BOARD
--------------------------------------------------------

  ALTER TABLE "BOARD" MODIFY ("BNO" NOT NULL ENABLE);
  ALTER TABLE "BOARD" MODIFY ("ID" NOT NULL ENABLE);
  ALTER TABLE "BOARD" MODIFY ("TITLE" NOT NULL ENABLE);
  ALTER TABLE "BOARD" MODIFY ("CONTENT" NOT NULL ENABLE);
  ALTER TABLE "BOARD" MODIFY ("WRITE_DATE" NOT NULL ENABLE);
  ALTER TABLE "BOARD" MODIFY ("WRITE_UPDATE_DATE" NOT NULL ENABLE);
  ALTER TABLE "BOARD" ADD CONSTRAINT "PK_BOARD" PRIMARY KEY ("BNO")
  USING INDEX  ENABLE;
--------------------------------------------------------
--  Constraints for Table BOARD_COMMENT
--------------------------------------------------------

  ALTER TABLE "BOARD_COMMENT" MODIFY ("CNO" NOT NULL ENABLE);
  ALTER TABLE "BOARD_COMMENT" MODIFY ("BNO" NOT NULL ENABLE);
  ALTER TABLE "BOARD_COMMENT" MODIFY ("ID" NOT NULL ENABLE);
  ALTER TABLE "BOARD_COMMENT" ADD CONSTRAINT "PK_BOARD_COMMENT" PRIMARY KEY ("CNO")
  USING INDEX  ENABLE;
--------------------------------------------------------
--  Constraints for Table BOARD_COMMENT_HATE
--------------------------------------------------------

  ALTER TABLE "BOARD_COMMENT_HATE" MODIFY ("ID" NOT NULL ENABLE);
  ALTER TABLE "BOARD_COMMENT_HATE" MODIFY ("CNO" NOT NULL ENABLE);
  ALTER TABLE "BOARD_COMMENT_HATE" ADD CONSTRAINT "PK_BOARD_COMMENT_HATE" PRIMARY KEY ("ID", "CNO")
  USING INDEX  ENABLE;
--------------------------------------------------------
--  Constraints for Table BOARD_COMMENT_LIKE
--------------------------------------------------------

  ALTER TABLE "BOARD_COMMENT_LIKE" MODIFY ("ID" NOT NULL ENABLE);
  ALTER TABLE "BOARD_COMMENT_LIKE" MODIFY ("CNO" NOT NULL ENABLE);
  ALTER TABLE "BOARD_COMMENT_LIKE" ADD CONSTRAINT "PK_BOARD_COMMENT_LIKE" PRIMARY KEY ("ID", "CNO")
  USING INDEX  ENABLE;
--------------------------------------------------------
--  Constraints for Table BOARD_CONTENT_HATE
--------------------------------------------------------

  ALTER TABLE "BOARD_CONTENT_HATE" MODIFY ("BNO" NOT NULL ENABLE);
  ALTER TABLE "BOARD_CONTENT_HATE" MODIFY ("ID" NOT NULL ENABLE);
  ALTER TABLE "BOARD_CONTENT_HATE" ADD CONSTRAINT "PK_BOARD_CONTENT_HATE" PRIMARY KEY ("BNO", "ID")
  USING INDEX  ENABLE;
--------------------------------------------------------
--  Constraints for Table BOARD_CONTENT_LIKE
--------------------------------------------------------

  ALTER TABLE "BOARD_CONTENT_LIKE" MODIFY ("BNO" NOT NULL ENABLE);
  ALTER TABLE "BOARD_CONTENT_LIKE" MODIFY ("ID" NOT NULL ENABLE);
  ALTER TABLE "BOARD_CONTENT_LIKE" ADD CONSTRAINT "PK_BOARD_CONTENT_LIKE" PRIMARY KEY ("BNO", "ID")
  USING INDEX  ENABLE;
--------------------------------------------------------
--  Constraints for Table BOARD_FILE
--------------------------------------------------------

  ALTER TABLE "BOARD_FILE" MODIFY ("FNO" NOT NULL ENABLE);
  ALTER TABLE "BOARD_FILE" MODIFY ("BNO" NOT NULL ENABLE);
  ALTER TABLE "BOARD_FILE" ADD CONSTRAINT "PK_BOARD_FILE" PRIMARY KEY ("FNO")
  USING INDEX  ENABLE;
--------------------------------------------------------
--  Constraints for Table BOARD_MEMBER
--------------------------------------------------------

  ALTER TABLE "BOARD_MEMBER" MODIFY ("ID" NOT NULL ENABLE);
  ALTER TABLE "BOARD_MEMBER" MODIFY ("PASSWORD" NOT NULL ENABLE);
  ALTER TABLE "BOARD_MEMBER" MODIFY ("USERNAME" NOT NULL ENABLE);
  ALTER TABLE "BOARD_MEMBER" MODIFY ("NICKNAME" NOT NULL ENABLE);
  ALTER TABLE "BOARD_MEMBER" ADD CONSTRAINT "PK_BOARD_MEMBER" PRIMARY KEY ("ID")
  USING INDEX  ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table BOARD
--------------------------------------------------------

  ALTER TABLE "BOARD" ADD CONSTRAINT "BOARD_FK_ID" FOREIGN KEY ("ID")
	  REFERENCES "BOARD_MEMBER" ("ID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table BOARD_COMMENT
--------------------------------------------------------

  ALTER TABLE "BOARD_COMMENT" ADD CONSTRAINT "BOARD_COMMENT_FK_BNO" FOREIGN KEY ("BNO")
	  REFERENCES "BOARD" ("BNO") ENABLE;
  ALTER TABLE "BOARD_COMMENT" ADD CONSTRAINT "BOARD_COMMENT_FK_ID" FOREIGN KEY ("ID")
	  REFERENCES "BOARD_MEMBER" ("ID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table BOARD_COMMENT_HATE
--------------------------------------------------------

  ALTER TABLE "BOARD_COMMENT_HATE" ADD CONSTRAINT "BCMH_FK_ID" FOREIGN KEY ("ID")
	  REFERENCES "BOARD_MEMBER" ("ID") ENABLE;
  ALTER TABLE "BOARD_COMMENT_HATE" ADD CONSTRAINT "BCMH_FK_CNO" FOREIGN KEY ("CNO")
	  REFERENCES "BOARD_COMMENT" ("CNO") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table BOARD_COMMENT_LIKE
--------------------------------------------------------

  ALTER TABLE "BOARD_COMMENT_LIKE" ADD CONSTRAINT "BCML_FK_ID" FOREIGN KEY ("ID")
	  REFERENCES "BOARD_MEMBER" ("ID") ENABLE;
  ALTER TABLE "BOARD_COMMENT_LIKE" ADD CONSTRAINT "BCML_FK_CNO" FOREIGN KEY ("CNO")
	  REFERENCES "BOARD_COMMENT" ("CNO") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table BOARD_CONTENT_HATE
--------------------------------------------------------

  ALTER TABLE "BOARD_CONTENT_HATE" ADD CONSTRAINT "BCH_FK_BNO" FOREIGN KEY ("BNO")
	  REFERENCES "BOARD" ("BNO") ENABLE;
  ALTER TABLE "BOARD_CONTENT_HATE" ADD CONSTRAINT "BCH_FK_ID" FOREIGN KEY ("ID")
	  REFERENCES "BOARD_MEMBER" ("ID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table BOARD_CONTENT_LIKE
--------------------------------------------------------

  ALTER TABLE "BOARD_CONTENT_LIKE" ADD CONSTRAINT "BCL_FK_BNO" FOREIGN KEY ("BNO")
	  REFERENCES "BOARD" ("BNO") ENABLE;
  ALTER TABLE "BOARD_CONTENT_LIKE" ADD CONSTRAINT "BCL_FK_ID" FOREIGN KEY ("ID")
	  REFERENCES "BOARD_MEMBER" ("ID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table BOARD_FILE
--------------------------------------------------------

  ALTER TABLE "BOARD_FILE" ADD CONSTRAINT "BOARD_FILE_FK_BNO" FOREIGN KEY ("BNO")
	  REFERENCES "BOARD" ("BNO") ENABLE;
	 
	DELETE FROM BOARD_MEMBER WHERE ID = 'vpxpr9912';
