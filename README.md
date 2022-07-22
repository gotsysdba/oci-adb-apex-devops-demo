# oci-adb-apex-devops-demo

This repository stores code to:

1. Create an APEX Application in [Oracle Cloud Infrastructure (OCI)](www.oracle.cloud) to demonstrate Oracle Application Express (APEX) functionality
2. Demonstrate using [SQLcl](https://www.oracle.com/uk/database/technologies/appdev/sqlcl.html), integrated with [Liquibase](https://www.liquibase.org/), to do APEX/Schema version control
3. Illustrate OCI Database creation/cloning using Terraform Infrastructure as Code (IaC); often used for DevOps "feature branch" isolation.

## Assumptions

* An existing paid or free-tier OCI tenancy
* General proficiency with OCI

## Prerequisites

### Terraform Backend for Remote State

DevOps with Infrastructure as Code (IaC) requires the Terraform state file to be stored in a shared backend so that it is accessible to all developers and the CI/CD Pipeline (i.e. not a local backend).  While there are different backend options, this demo can use OCI Object Storage.  There is helper code in terraform/backend, which will create a bucket and write a backend.tf file to the terraform directory.  The output of the bucket IaC will provide access and secret keys which will be used later in the demo.

If you have an existing backend, or want to use something different, manually create a backend.tf file in the terraform directory.

### Git Remote Repository

You will need your own Git Repository, currently this demo only supports GitHub.  Support for additional repositories are in progress.

## Instructions

Fork this repository to your own GitHub Repository.
