# Copyright © 2022, Oracle and/or its affiliates. 
# All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

ata "oci_objectstorage_namespace" "ns" {
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