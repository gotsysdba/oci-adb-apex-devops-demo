# Copyright © 2020, Oracle and/or its affiliates. 
# All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "oci_bastion_bastion" "Bastion" {
  bastion_type = "STANDARD"
  client_cidr_block_allow_list = [
    "0.0.0.0/0",
  ]
  compartment_id = var.compartment_ocid
  max_session_ttl_in_seconds = "10800"
  name                       = "Bastion"
  target_subnet_id = oci_core_subnet.subnet_private.id
}