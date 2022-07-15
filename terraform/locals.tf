locals {
  compartment_ocid = var.compartment_ocid != "" ? var.compartment_ocid : var.tenancy_ocid
  user_ocid        = var.user_ocid != "" ? var.user_ocid : var.current_user_ocid
  adb_name         = oci_database_autonomous_database.adb.db_name
  lb_params        = format("--dbName %s --dbUser %s --dbPass %s --dbWallet %s", local.adb_name, var.apex_user, random_password.adb_password.result, local_sensitive_file.database_wallet_file.filename)
  lb_deploy_cmd    = format("cicd.py deploy %s", local.lb_params)
  lb_generate_cmd  = format("cicd.py generate %s", local.lb_params)
  db_suffix        = terraform.workspace == "default" ? "prd" : terraform.workspace
}