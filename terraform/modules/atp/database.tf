# Copyright © 2020, Oracle and/or its affiliates. 
# All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "random_password" "autonomous_database_password" {
  length           = 16
  min_numeric      = 1
  min_lower        = 1
  min_upper        = 1
  min_special      = 1
  override_special = "_#"
}

resource "oci_database_autonomous_database" "autonomous_database" {
  admin_password           = random_password.autonomous_database_password.result
  compartment_id           = var.compartment_ocid
  db_name                  = var.db_name
  cpu_core_count           = var.cpu_core_count
  data_storage_size_in_tbs = var.storage_size_in_tbs
  db_version               = var.db_version
  db_workload              = "OLTP"
  display_name             = var.display_name
  is_free_tier             = var.is_always_free 
  is_auto_scaling_enabled  = var.is_always_free ? false : true
  license_model            = var.is_always_free ? "LICENSE_INCLUDED" : var.license_model
  whitelisted_ips          = null
  nsg_ids                  = null
  private_endpoint_label   = null
  subnet_id                = null
  source                   = var.adb_source
  source_id                = var.adb_source_id
  clone_type               = var.adb_clone_type
  lifecycle {
    ignore_changes = all
  }
}
