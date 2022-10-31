-- liquibase formatted sql

-- changeset gotsysdba:Initial runOnChange:true endDelimiter:/ rollbackEndDelimiter:/
DECLARE
  l_sg_id number;
BEGIN
    l_sg_id := apex_util.find_security_group_id(p_workspace => '${schema}');
    apex_util.set_security_group_id(p_security_group_id => l_sg_id);
    apex_util.create_user (
       p_user_name                    => 'ADMIN'
      ,p_web_password                 => '${password}'
      ,p_email_address                => 'noreply@oracle.com'
      ,p_developer_privs              => 'ADMIN:CREATE:DATA_LOADER:EDIT:HELP:MONITOR:SQL'
      ,p_default_schema               => '${schema}'
      ,p_account_locked               => 'N'
      ,p_change_password_on_first_use => 'Y'
      ,p_first_password_use_occurred  => 'N'
      ,p_account_expiry               => TRUNC(SYSDATE-1)
      ,p_allow_app_building_yn        => 'Y'
      ,p_allow_sql_workshop_yn        => 'Y'
      ,p_allow_websheet_dev_yn        => 'Y'
      ,p_allow_team_development_yn    => 'Y'
    );
EXCEPTION 
    WHEN DUP_VAL_ON_INDEX THEN
        NULL; -- User already exists
    WHEN OTHERS THEN RAISE;
END;
/

-- rollback DECLARE
-- rollback   l_sg_id number;
-- rollback BEGIN
-- rollback     l_sg_id := apex_util.find_security_group_id(p_workspace => '${schema}');
-- rollback     apex_util.set_security_group_id(p_security_group_id => l_sg_id);
-- rollback     apex_util.remove_user(p_user_name =>'ADMIN');
-- rollback END;
-- rollback /
