CREATE TABLE "APP"."PROJECT"(
ID BIGINT NOT NULL PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY (START WITH 100),
NAME VARCHAR(64) not null,
UNIQUE(NAME),
START_DATE TIMESTAMP not null,
VERSION INTEGER,
RESEARCHER_ID BIGINT,
FOREIGN KEY (RESEARCHER_ID) REFERENCES RESEARCHER(ID))

