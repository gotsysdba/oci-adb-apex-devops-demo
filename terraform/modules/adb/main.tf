# Copyright © 2020, Oracle and/or its affiliates. 
# All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "oci_database_autonomous_database" "adb" {
  admin_password           = random_password.adb_password.result
  compartment_id           = var.adb_compartment
  db_name                  = var.adb_name
  cpu_core_count           = 1
  data_storage_size_in_tbs = 1
  db_version               = var.db_version
  db_workload              = "OLTP"
  display_name             = var.adb_name
  is_free_tier             = var.is_always_free
  is_auto_scaling_enabled  = var.is_always_free ? false : true
  license_model            = var.is_always_free ? "LICENSE_INCLUDED" : var.license_model
  whitelisted_ips          = []
  nsg_ids                  = null
  private_endpoint_label   = null
  subnet_id                = null
  source                   = var.adb_source
  source_id                = var.adb_source_id
  clone_type               = var.adb_clone_type
}