# Copyright © 2022, Oracle and/or its affiliates. 
# All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "oci_identity_compartment" "prd" {
  compartment_id = var.compartment_ocid
  description    = "Production Compartment"
  name           = "prd"
  // As this is a demo, otherwise enable_delete should be false
  enable_delete = true
}

resource "oci_identity_compartment" "dev" {
  compartment_id = var.compartment_ocid
  description    = "Developement Compartment"
  name           = "dev"
  // As this is a demo, otherwise enable_delete should be false
  enable_delete = true
}