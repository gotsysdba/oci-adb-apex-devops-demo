# Copyright © 2020, Oracle and/or its affiliates. 
# All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

// Basic Hidden
variable "tenancy_ocid" {}
variable "compartment_ocid" {}
variable "region" {}

// Extra Hidden
variable "user_ocid" {
  default = ""
}
variable "fingerprint" {
  default = ""
}
variable "private_key_path" {
  default = ""
}

// General Configuration
variable "res_prefix" {
  description = "Prefix to all OCI Resources created with this code"
  default     = "DEMO"
}

variable "license_model" {
  default = "BRING_YOUR_OWN_LICENSE"
}

variable "cpu_core_count" {
  default = 1
}

variable "storage_size_in_tbs" {
  default = 1
}

variable "db_version" {
  default = "19c"
}

variable "environment" {
  default = "DEV"
}

variable "is_always_free" {
    default = false
}

// VCN Configurations Variables
variable "vcn_cidr" {
  default = "10.0.0.0/16"
}

variable "vcn_is_ipv6enabled" {
  default = false
}

variable "private_subnet_cidr" {
  default = "10.0.2.0/24"
}
