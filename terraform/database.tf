# Copyright © 2020, Oracle and/or its affiliates. 
# All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "oci_database_autonomous_database" "adb" {
  admin_password           = random_password.adb_password.result
  compartment_id           = terraform.workspace == "default" ? oci_identity_compartment.prd.id : oci_identity_compartment.dev.id
  db_name                  = format("%s%s", upper(var.proj_abrv), upper(local.db_suffix))
  cpu_core_count           = var.cpu_core_count
  data_storage_size_in_tbs = var.storage_size_in_tbs
  db_version               = var.db_version
  db_workload              = "OLTP"
  display_name             = format("%s%s", upper(var.proj_abrv), upper(local.db_suffix))
  is_free_tier             = var.is_always_free
  is_auto_scaling_enabled  = var.is_always_free ? false : true
  license_model            = var.is_always_free ? "LICENSE_INCLUDED" : var.license_model
  whitelisted_ips          = []
  nsg_ids                  = null
  private_endpoint_label   = null
  subnet_id                = null
  source_id                = terraform.workspace == "default" ? null : data.terraform_remote_state.default.outputs.adbprd_id
  lifecycle {
    prevent_destroy = true
  }
}