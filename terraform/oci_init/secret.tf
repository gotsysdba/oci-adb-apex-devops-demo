resource "oci_identity_customer_secret_key" "customer_secret_key" {
  display_name = "DEMO-TFState"
  user_id      = var.user_ocid
}