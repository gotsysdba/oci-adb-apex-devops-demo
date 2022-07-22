output "aws_access_key_id" {
  value = format("export AWS_ACCESS_KEY_ID=%s", oci_identity_customer_secret_key.customer_secret_key.id)
}

output "aws_secret_access_key" {
  value = format("export AWS_SECRET_ACCESS_KEY=%s", oci_identity_customer_secret_key.customer_secret_key.key)
}