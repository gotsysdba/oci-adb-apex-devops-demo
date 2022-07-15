resource "oci_identity_compartment" "prd" {
  compartment_id = var.compartment_ocid
  description    = "Production Compartment"
  name           = "prd"
  // As this is a demo, otherwise enable_delete should be false
  enable_delete  = true
}

resource "oci_identity_compartment" "dev" {
  compartment_id = var.compartment_ocid
  description    = "Developement Compartment"
  name           = "dev"
  // As this is a demo, otherwise enable_delete should be false
  enable_delete  = true
}