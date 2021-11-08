# Copyright © 2020, Oracle and/or its affiliates. 
# All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

output "db_ocid" {
    description = "DBCS DB OCID"
    value       = oci_database_db_system.db_system.db_home.0.database.0.id
}

output "system_ocid" {
    description = "DB System OCID"
    value       = oci_database_db_system.db_system.id
}

output "db_tde_wallet_password" {
    description = "TDE Wallet Password"
    value       = oci_database_db_system.db_system.db_home.0.database.0.tde_wallet_password
    sensitive   = true
}

output "db_admin_password" {
    description = "DB Admin Password"
    value       = oci_database_db_system.db_system.db_home.0.database.0.admin_password
    sensitive   = true
}

output "pdbs" {
    value       = data.oci_database_pluggable_databases.pdbs
}