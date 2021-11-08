-- liquibase formatted sql

-- changeset john:Initial context:demo runAlways:true endDelimiter="/"
DECLARE
    l_workspace_id number;
    l_sg_id number;
BEGIN
    apex_util.set_workspace(p_workspace => 'DEMO');
    l_workspace_id := apex_application_install.get_workspace_id;
    l_sg_id := apex_util.find_security_group_id (p_workspace => 'DEMO');
    apex_util.set_security_group_id (p_security_group_id => l_sg_id);
    apex_application_install.set_workspace_id(p_workspace_id => l_workspace_id);
    apex_application_install.set_schema(p_schema => 'DEMO');
    apex_application_install.set_application_id(p_application_id => 103);
    apex_application_install.generate_offset();
    apex_application_install.set_build_status(p_build_status => 'RUN_AND_BUILD');
    apex_application_install.set_auto_install_sup_obj( p_auto_install_sup_obj => true );
END;
/