-- liquibase formatted sql

-- changeset gotsysdba:Initial runAlways:true
truncate table UXI_FEATURE_CARDS_LU;
insert into UXI_FEATURE_CARDS_LU (CARD_TEXT,CARD_IMAGE,CARD_CATEGORY,CARD_SUBTEXT,CARD_ORDER) values ('App definitions are stored in the database as meta data.','appdef.png','Features','Declarative - No code generation',5);
insert into UXI_FEATURE_CARDS_LU (CARD_TEXT,CARD_IMAGE,CARD_CATEGORY,CARD_SUBTEXT,CARD_ORDER) values ('Develop desktop and mobile web apps','develop.png','Features',null,1);
insert into UXI_FEATURE_CARDS_LU (CARD_TEXT,CARD_IMAGE,CARD_CATEGORY,CARD_SUBTEXT,CARD_ORDER) values ('Leverage SQL Skills and database capabilities','leverage.png','Features',null,2);
insert into UXI_FEATURE_CARDS_LU (CARD_TEXT,CARD_IMAGE,CARD_CATEGORY,CARD_SUBTEXT,CARD_ORDER) values ('App Development IDE is a web browser','appdev.png','Features','No client software needed',4);
insert into UXI_FEATURE_CARDS_LU (CARD_TEXT,CARD_IMAGE,CARD_CATEGORY,CARD_SUBTEXT,CARD_ORDER) values ('Page generation is efficient with only one request and one response.','pagegen.png','Features','Data processing done in the Database',6);
insert into UXI_FEATURE_CARDS_LU (CARD_TEXT,CARD_IMAGE,CARD_CATEGORY,CARD_SUBTEXT,CARD_ORDER) values ('Visualise and maintain database data','visualise.png','Features',null,3);