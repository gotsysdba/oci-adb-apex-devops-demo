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