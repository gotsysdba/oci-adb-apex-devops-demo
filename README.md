# oci-adb-apex-devops-demo

This repository stores code to:

1. Create an APEX Application in [Oracle Cloud Infrastructure (OCI)](www.oracle.cloud) to demonstrate Oracle Application Express (APEX) functionality
2. Demonstrate using [SQLcl](https://www.oracle.com/uk/database/technologies/appdev/sqlcl.html), integrated with [Liquibase](https://www.liquibase.org/), to do database version control
3. Illustrate OCI Database creation/cloning using Terraform Infrastructure as Code (IaC); often used for DevOps "feature branch" isolation.

## Assumptions

* An existing paid or free-tier OCI tenancy
* General proficiency with OCI

## Prequisites

### Terraform Backend for Remote State

DevOps with Infrastructure as Code (IaC) requires the Terraform state file to be stored in a shared backend so that it is accessible to all developers (i.e. not a local backend).  While there are different backend options, this demo can use OCI Object Storage.  There is helper code in terraform/backend, which will create a bucket and write a backend.tf file to the terraform directory.  The state for the bucket IaC will contain access and secret keys which will be used later in the demo.

If you have an existing backend, or want to use something different, manually create a backend.tf file in the terraform directory.

### Git Remote Repository

You will need your own Git Repository, currently this demo only supports GitHub.  Support for additional repositories are in progress.

# Instructions

Fork this repository to your own GitHub Repository.

## Terraform IaC
The Terraform IaC demonstration documentation can be found [here](doco/TERRAFORM_IAC.md)

## APEX Demonstration Application
The APEX Demonstration Application can be installed in a pre-existing Autonomous Transaction Processing Database (ATP), or you can use this code to provision a new ATP and load the Demonstration Application.

Installing the APEX Demonstration Application is documented [here](doco/APEX_DEMO.md)

## Database Version Control
_Not yet documented..._