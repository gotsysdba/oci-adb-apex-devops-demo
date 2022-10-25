# Copyright © 2020, Oracle and/or its affiliates. 
# All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

output "TF_VAR_tenancy_ocid" {
  value = var.tenancy_ocid
}

output "TF_VAR_region" {
  value = var.region
}

output "TF_VAR_user_ocid" {
  value = data.oci_identity_users.identity_users.users[0].id
}

output "TF_VAR_fingerprint" {
  value = oci_identity_api_key.api_key.fingerprint
}

output "AWS_ACCESS_KEY_ID" {
  value = oci_identity_customer_secret_key.customer_secret_key.id
}

output "AWS_SECRET_ACCESS_KEY" {
  value = oci_identity_customer_secret_key.customer_secret_key.key
}

output "TF_VAR_private_key" {
  value     = tls_private_key.rsa_4096.private_key_pem
  sensitive = true
}