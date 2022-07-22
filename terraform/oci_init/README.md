# oci_init

Helper IaC for the DevOps Demo

## Bucket for Remote Terraform State

This IaC will create an Object Storage bucket to store the Terraform state files.  It will also write a new backend.tf file to the terraform directory for use with the DEMO.  The output of the IaC will provide access and secret keys which will be used to access the bucket from the Demo IaC and CI/CD Pipelines.

## Compartments

This IaC will create two compartments, prd and dev, to show compartment isolation.  In a real-world deployment, IAM policies would be placed on the prd compartment to prevent resource destruction.
