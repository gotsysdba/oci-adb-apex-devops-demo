# Copyright © 2020, Oracle and/or its affiliates. 
# All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

// Carry through from main module
variable "tenancy_ocid" {}
variable "compartment_ocid" {}
variable "license_model" {}
variable "availability_domain" {}
variable "subnet_id" {}
variable "subnet_domain" {}
variable "subnet_nsg" {}

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

variable "pdb_name" {  
    description = "PDB Name. Must be unique per container."  
    type        = string
    default     = ""
}

// Dynamic for Module - Sizing/Version Specific
variable "db_version" {}
variable "storage_management" {}

variable "shape" {
    default = "VM.Standard2.8"
}

variable "data_storage_size_in_gb" {
    default = "1024"
}

// Dynamic for Module - Cloning Specific
variable "db_source" {  
    description = "Set if Cloning"  
    type        = string
    default     = "NONE"
}

variable "db_source_id" {  
    description = "Set if Cloning"  
    default     = ""
}

variable "system_source_id" {  
    description = "Set if Cloning"  
    default     = ""
}