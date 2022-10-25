# Copyright © 2022, Oracle and/or its affiliates. 
# All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

data "oci_identity_users" "identity_users" {
    compartment_id = var.tenancy_ocid
    identity_provider_id = var.identity_provider_id
}

resource "oci_identity_customer_secret_key" "customer_secret_key" {
  display_name = "DEMO-TFState"
  user_id      = data.oci_identity_users.identity_users.users[0].id
}