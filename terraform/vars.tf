# Copyright © 2020, Oracle and/or its affiliates. 
# All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

// Basic Hidden
variable "tenancy_ocid" {}
variable "compartment_ocid" {}

variable "region" {
  default = ""
}

// Extra Hidden
variable "user_ocid" {
  default = ""
}

variable "current_user_ocid" {
  default = ""
}

variable "fingerprint" {
  default = ""
}
variable "private_key_path" {
  default = ""
}
variable "private_key" {
  default = ""
}

// General Configuration
variable "db_clone_source" {
  // DATABASE | NONE
  default = "NONE"
}

variable "apex_user" {
  default = "DEMO"
}

// ADB Configuration
variable "db_version" {
  default = "19c"
}
variable "is_always_free" {
  default = false
}
variable "license_model" {
  default = "BRING_YOUR_OWN_LICENSE"
}