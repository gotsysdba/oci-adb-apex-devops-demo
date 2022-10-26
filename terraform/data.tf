# Copyright © 2022, Oracle and/or its affiliates. 
# All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

data "oci_identity_compartments" "prd" {
  compartment_id = local.compartment_ocid
  name           = "prd"
  state          = "ACTIVE"
}

data "oci_identity_compartments" "dev" {
  compartment_id = local.compartment_ocid
  name           = "dev"
  state          = "ACTIVE"
}