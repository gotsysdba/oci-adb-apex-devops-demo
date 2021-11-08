# Copyright © 2020, Oracle and/or its affiliates. 
# All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "oci_core_vcn" "vcn" {
  compartment_id = var.compartment_ocid
  display_name   = format("%s-vcn", lower(var.res_prefix))
  cidr_block     = var.vcn_cidr
  is_ipv6enabled = var.vcn_is_ipv6enabled
  dns_label      = replace(lower(var.res_prefix),"-","")
}

resource "oci_core_nat_gateway" "nat_gateway" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = format("%s-nat-gateway", lower(var.res_prefix))
}

resource "oci_core_route_table" "route_table_nat_gw" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = format("%s-route-table-nat-gw", lower(var.res_prefix))
  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_nat_gateway.nat_gateway.id
  }
}

resource "oci_core_subnet" "subnet_private" {
  compartment_id             = var.compartment_ocid
  vcn_id                     = oci_core_vcn.vcn.id
  display_name               = format("%s-subnet-private", lower(var.res_prefix))
  cidr_block                 = var.private_subnet_cidr
  route_table_id             = oci_core_route_table.route_table_nat_gw.id
  dhcp_options_id            = oci_core_vcn.vcn.default_dhcp_options_id
  dns_label                  = "priv"
  prohibit_public_ip_on_vnic = true
}

resource "oci_core_network_security_group" "private_nsg" {
  compartment_id = var.compartment_ocid
  display_name = format("%s-subnet-private-nsg", lower(var.res_prefix))
  vcn_id = oci_core_vcn.vcn.id
}

resource "oci_core_network_security_group_security_rule" "private_nsg_ingress" {
  description               = "Allow resources in private network to talk for cloning purposes"  
  direction                 = "INGRESS"
  source_type               = "CIDR_BLOCK"
  source                    = "10.0.2.0/24"
  network_security_group_id = oci_core_network_security_group.private_nsg.id
  protocol                  = "all"
  stateless                 = "false"
}

resource "oci_core_network_security_group_security_rule" "private_nsg_egress" {
  description               = "Allow resources in private network to talk for cloning purposes"
  direction                 = "EGRESS"
  destination_type          = "CIDR_BLOCK"
  destination               = "10.0.2.0/24"
  network_security_group_id = oci_core_network_security_group.private_nsg.id
  protocol                  = "all"
  stateless                 = "false"
}