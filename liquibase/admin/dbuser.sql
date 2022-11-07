-- liquibase formatted sql

-- changeset gotsysdba:Initial endDelimiter:/
DECLARE
  L_USER	VARCHAR2(255);
BEGIN
  SELECT USERNAME INTO L_USER FROM DBA_USERS WHERE USERNAME='${schema}';
EXCEPTION WHEN NO_DATA_FOUND THEN
  execute immediate 'CREATE USER "${schema}" NO AUTHENTICATION';
END;
/

--rollback drop user "${schema}" cascade;