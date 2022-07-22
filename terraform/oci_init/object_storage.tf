data "oci_objectstorage_namespace" "ns" {
  compartment_id = var.compartment_ocid
}

resource "oci_objectstorage_bucket" "bucket" {
  compartment_id = var.compartment_ocid
  namespace      = data.oci_objectstorage_namespace.ns.namespace
  name           = "terraform-backend"
  access_type    = "NoPublicAccess"
  auto_tiering   = "Disabled"
}

resource "oci_objectstorage_object" "stub_state" {
  bucket     = "terraform-backend"
  content    = null
  namespace  = data.oci_objectstorage_namespace.ns.namespace
  object     = "terraform.tfstate"
  depends_on = [oci_objectstorage_bucket.bucket]
}