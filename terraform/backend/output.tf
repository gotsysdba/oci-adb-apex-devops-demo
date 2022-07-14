output "aws_access_key_id" {
  value = oci_identity_customer_secret_key.customer_secret_key.id
}

output "aws_secret_access_key" {
  value = oci_identity_customer_secret_key.customer_secret_key.key
}