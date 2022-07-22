# Copyright © 2020, Oracle and/or its affiliates. 
# All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl
resource "random_pet" "prefix" {
  count  = terraform.workspace == "default" ? 1 : 0
  length = 1
}