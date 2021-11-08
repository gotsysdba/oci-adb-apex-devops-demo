# Copyright © 2020, Oracle and/or its affiliates. 
# All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "random_password" "db_system_password" {
  length           = 16
  min_numeric      = 2
  min_lower        = 2
  min_upper        = 2
  min_special      = 2
  override_special = "_#"
}

resource "oci_database_db_system" "db_system" {
  availability_domain     = var.availability_domain
  compartment_id          = var.compartment_ocid
  shape                   = var.shape
  data_storage_size_in_gb = var.data_storage_size_in_gb
  database_edition        = "ENTERPRISE_EDITION_HIGH_PERFORMANCE"
  db_home {
    database {
      admin_password      = random_password.db_system_password.result
      character_set       = "AL32UTF8"
      ncharacter_set      = "AL16UTF16"
      db_name             = var.db_name
      db_workload         = "OLTP"
      tde_wallet_password = random_password.db_system_password.result
      pdb_name            = var.pdb_name
    }
    db_version   = var.db_version
    display_name = format("dbhome%s", lower(var.display_name))
  }
  db_system_options {
    storage_management = "LVM"
  }
  disk_redundancy = "NORMAL"
  display_name    = var.display_name
  domain          = var.subnet_domain
  hostname        = lower(var.display_name)
  license_model   = var.license_model
  node_count      = "1"
  ssh_public_keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDjU7+4WGZmQ91z8v40NInc0S6MQY+K4ntoBqJb3gtdPOkkBC4U4LFByCARr72THlWrPr4mKU8IWsPlHbF0HAuJRRWeYmAvXrKGGIB+36+d3dvPT9u18q/CgfnKeeTk5aErL8D9zCzH3h0AUAzVSQdczADX8fTnbmuWIPVdTXdIcswf3NMRjViF9C1U3YYfAvQ3AWsilhuExcJlpfEchM6AxpGCRK5f/kXiAyqLh7v4X2xXrCaEkvt9w9rMBGMHSEAWHdZhPoTFEExkRKVJG+IE4QOkTdwC2/XHvpdI72PDt3LWiQPGmIz9BpViEe4U2ohHZpSTAKlpRCj40yiJYRJz john@develophub",
  ]
  subnet_id           = var.subnet_id
  nsg_ids             = [ var.subnet_nsg ]
  time_zone           = "UTC"
  source              = var.db_source
  source_db_system_id = var.system_source_id
  lifecycle {
      ignore_changes = [ db_home.0.database.0.pdb_name ]
  }
}