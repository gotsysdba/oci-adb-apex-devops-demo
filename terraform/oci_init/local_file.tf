# Copyright © 2022, Oracle and/or its affiliates. 
# All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

// This will update the backend.tf file with the centralised location in Object Storage
resource "local_file" "backend" {
  filename = "${path.root}/../backend.tf"
  content = templatefile("${path.root}/templates/backend.tf.tftpl",
    {
      region     = var.region
      namespace  = data.oci_objectstorage_namespace.ns.namespace
      access_key = oci_identity_customer_secret_key.customer_secret_key.id
      secret_key = oci_identity_customer_secret_key.customer_secret_key.key
    }
  )
}