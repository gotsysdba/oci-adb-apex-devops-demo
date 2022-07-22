# Copyright © 2020, Oracle and/or its affiliates. 
# All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

// Carry through from main module
variable "license_model" {}
variable "db_version" {}
variable "is_always_free" {}

// Dynamic for Module
variable "adb_compartment" {
  description = "The compartment to create the ADB in"
  type        = string
  default     = ""
}

variable "adb_name" {
  description = "ADB Name. Must be unique."
  type        = string
  default     = ""
}

variable "adb_source" {
  description = "Set if Cloning"
  type        = string
  default     = "NONE"
}

variable "adb_source_id" {
  description = "Set if Cloning"
  default     = ""
}

variable "adb_clone_type" {
  description = "Set if Cloning"
  default     = ""
}
