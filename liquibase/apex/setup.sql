-- liquibase formatted sql

-- changeset gotsysdba:Initial runAlways:true endDelimiter:/
DECLARE
    l_workspace_id number;
    l_sg_id number;
BEGIN
    -- Set Security Group
    l_sg_id := apex_util.find_security_group_id(p_workspace => 'DEMO');
    IF l_sg_id IS NULL THEN
      raise_application_error(-20010,'Unable to find Workspace: DEMO');
    END IF;
    apex_util.set_security_group_id(p_security_group_id => l_sg_id);  

    -- Clear Overrides
    apex_application_install.clear_all;
    
    -- Set the Workspace ID
    -- don't use apex_application_install.get_workspace_id; it returns nothing and breaks all
    select workspace_id into l_workspace_id
      from apex_workspaces
     where workspace = 'DEMO';
    apex_application_install.set_workspace_id(p_workspace_id => l_workspace_id);

    -- Set Additional Overrides
    apex_application_install.generate_offset();
    apex_application_install.set_build_status(p_build_status => 'RUN_AND_BUILD');
    apex_application_install.set_auto_install_sup_obj(p_auto_install_sup_obj => true);
END;
/