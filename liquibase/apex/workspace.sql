-- liquibase formatted sql

-- changeset gotsysdba:Initial endDelimiter:/ rollbackEndDelimiter:/
BEGIN
  APEX_INSTANCE_ADMIN.ADD_WORKSPACE (
     P_WORKSPACE          => 'DEMO'
    ,P_SOURCE_IDENTIFIER  => 'DEMO'
    ,P_PRIMARY_SCHEMA     => '${schema}'
  );
END;
/
-- rollback BEGIN APEX_INSTANCE_ADMIN.REMOVE_WORKSPACE(P_WORKSPACE => 'DEMO'); END;
-- rollback /