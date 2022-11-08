-- liquibase formatted sql

-- changeset gotsysdba:Initial runAlways:true
truncate table ${schema}.UXI_DATA_SRC_LU;
insert into ${schema}.UXI_DATA_SRC_LU (ID,SOURCE,POSSIBLE) values (1,'Database Links (SQL*Net)','Y');
insert into ${schema}.UXI_DATA_SRC_LU (ID,SOURCE,POSSIBLE) values (2,'Local Data Sources (SQL, PL/SQL)','Y');
insert into ${schema}.UXI_DATA_SRC_LU (ID,SOURCE,POSSIBLE) values (3,'REST Enabled Databases','Y');
insert into ${schema}.UXI_DATA_SRC_LU (ID,SOURCE,POSSIBLE) values (4,'External REST API''s','Y');
insert into ${schema}.UXI_DATA_SRC_LU (ID,SOURCE,POSSIBLE) values (5,'Desktop Files (CSV, XML, XLS)','Y');
insert into ${schema}.UXI_DATA_SRC_LU (ID,SOURCE,POSSIBLE) values (6,'Space Satallites','Y');