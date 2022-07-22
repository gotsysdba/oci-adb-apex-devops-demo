# Copyright © 2020, Oracle and/or its affiliates. 
# All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

module "adb_prd" {
  count           = terraform.workspace == "default" ? 1 : 0
  source          = "./modules/adb"
  db_version      = var.db_version
  is_always_free  = var.is_always_free
  license_model   = var.license_model
  adb_compartment = data.oci_identity_compartments.prd.compartments[0].id
  adb_name        = upper(format("%sPRD", random_pet.prefix[0].id))
}

module "adb_dev" {
  count           = terraform.workspace == "default" ? 0 : 1
  source          = "./modules/adb"
  db_version      = var.db_version
  is_always_free  = var.is_always_free
  license_model   = var.license_model
  adb_compartment = data.oci_identity_compartments.dev.compartments[0].id
  adb_name        = format("%s%s", replace(data.terraform_remote_state.default[0].outputs.adbprd_name, "PRD", "DEV"), replace(terraform.workspace, "/-.*/", ""))
  adb_source      = var.db_clone_source
  adb_source_id   = data.terraform_remote_state.default[0].outputs.adbprd_id
  adb_clone_type  = "FULL"
}