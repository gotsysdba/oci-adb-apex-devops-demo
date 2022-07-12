-- liquibase formatted sql

-- changeset john:Initial context:${schema} endDelimiter="/" rollbackEndDelimiter:"/"
DECLARE
  l_sg_id number;
BEGIN
    l_sg_id := apex_util.find_security_group_id(p_workspace => '${schema}');
    apex_util.set_security_group_id(p_security_group_id => l_sg_id);
    apex_util.create_user (
       p_user_name                    => '${schema}'
      ,p_web_password                 => 'Exp1r3d_n_L0ck3d!'
      ,p_developer_privs              => 'ADMIN:CREATE:DATA_LOADER:EDIT:HELP:MONITOR:SQL'
      ,p_default_schema               => '${schema}'
      ,p_account_locked               => 'Y'
      ,p_first_password_use_occurred  => 'Y'
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
-- rollback     apex_util.remove_user(p_user_name =>'${schema}');
-- rollback END;
-- rollback /