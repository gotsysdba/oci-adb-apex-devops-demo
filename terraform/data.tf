data "oci_identity_compartments" "prd" {
  compartment_id = var.compartment_ocid
  name           = "prd"
  state          = "ACTIVE"
}

data "oci_identity_compartments" "dev" {
  compartment_id = var.compartment_ocid
  name           = "dev"
  state          = "ACTIVE"
}