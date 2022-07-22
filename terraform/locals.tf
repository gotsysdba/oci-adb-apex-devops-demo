locals {
  compartment_ocid = var.compartment_ocid != "" ? var.compartment_ocid : var.tenancy_ocid
  user_ocid        = var.user_ocid != "" ? var.user_ocid : var.current_user_ocid
  lb_params        = terraform.workspace == "default" ? join(", ", module.adb_prd[*].lb_params) : join(", ", module.adb_dev[*].lb_params)
  lb_deploy_cmd    = format("cicd.py deploy --dbUser %s %s", var.apex_user, local.lb_params)
  lb_generate_cmd  = format("cicd.py generate --dbUser %s %s", var.apex_user, local.lb_params)
}