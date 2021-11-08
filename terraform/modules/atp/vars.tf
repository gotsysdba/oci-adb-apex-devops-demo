# Copyright © 2020, Oracle and/or its affiliates. 
# All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

// Carry through from main module
variable "tenancy_ocid" {}
variable "compartment_ocid" {}
variable "license_model" {}
variable "cpu_core_count" {}
variable "storage_size_in_tbs" {}
variable "db_version" {}
variable "environment" {}
variable "is_always_free" {}

// Dynamic for Module
variable "db_name" {  
    description = "DB Name. Must be unique."  
    type        = string
    default     = ""
}

variable "display_name" {  
    description = "DB Display Name. Must be unique."  
    type        = string
    default     = ""
}

variable "db_source" {  
    description = "Set if Cloning"  
    type        = string
    default     = "NONE"
}

variable "db_source_id" {  
    description = "Set if Cloning"  
    default     = ""
}

variable "adb_clone_type" {  
    description = "Set if Cloning"  
    default     = ""
}