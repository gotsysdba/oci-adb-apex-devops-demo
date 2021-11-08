# Copyright © 2020, Oracle and/or its affiliates. 
# All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

// The default PDB created during prov'ing has very little state data, get more 
// Specifically we need its OCID for cloning operations
data "oci_database_pluggable_databases" "pdbs" {
    database_id    = oci_database_db_system.db_system.db_home.0.database.0.id
}