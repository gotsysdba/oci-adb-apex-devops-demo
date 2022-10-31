-- liquibase formatted sql

-- changeset gotsysdba:Initial endDelimiter:/
DECLARE
  L_USER	VARCHAR2(255);
BEGIN
  SELECT USERNAME INTO L_USER FROM DBA_USERS WHERE USERNAME='DEMO';
EXCEPTION WHEN NO_DATA_FOUND THEN
  execute immediate 'CREATE USER "DEMO" NO AUTHENTICATION';
END;
/

--rollback drop user "DEMO" cascade;