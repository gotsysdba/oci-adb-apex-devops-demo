# oci-adb-apex-devops-demo

This repository stores code to:

1. Create an APEX Application in [Oracle Cloud Infrastructure (OCI)](www.oracle.cloud) to demonstrate Oracle Application Express (APEX) functionality
2. Demonstrate using [SQLcl](https://www.oracle.com/uk/database/technologies/appdev/sqlcl.html), integrated with [Liquibase](https://www.liquibase.org/), to do database version control
3. Illustrate OCI Database creation/cloning using Terraform Infrastructure as Code (IaC); often used for DevOps "feature branch" isolation.

## Assumptions

* An existing paid or free-tier OCI tenancy
* General proficiency with OCI

## Prequisites

DevOps with Infrastructure as Code (IaC) requires the Terraform state file to be stored in a shared backend so that it is accessible to all developers.  While there are different backend options, this demo will use OCI Object Storage.  There is helper code in terraform/backend, which will create a bucket and write a backend.tf file to the terraform directory.  Note that this file will have secrets imbeded and should not be included in a public repository.



For all demonstrations, it is required to generate a OCI API Signing Key as documemented [here](https://docs.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm#apisigningkey_topic_How_to_Generate_an_API_Signing_Key_Console).

The config file should be stored in your home directory's .oci directory (~/.oci/config) and the profile should be called `[DEMO]`; below is an example:
```
[DEMO]
user=ocid1.user.oc1.....
fingerprint=<fingerprint:...>
tenancy=ocid1.tenancy.oc1.....
region=eu-frankfurt-1
key_file=~/.oci/key.pem
compartment=ocid1.compartment.oc1.....
```

If you would like the databases to be placed into a specific compartment, add `compartment=<compartment OCID>` into the ~/.oci/config file; If compartment is not specified, resources will be provisioned in the tenancies root compartment.

# Instructions
Download or Clone this repository to your Linux environment where you will run the code.  The Linux environment can be a desktop, OCI Compute Instance (CI) (_recommended_: CI with Oracle Development image).  It does not have to be associated with your tenancy.  Other OS environments can be used but are not documented here.

## Terraform IaC
The Terraform IaC demonstration documentation can be found [here](doco/TERRAFORM_IAC.md)

## APEX Demonstration Application
The APEX Demonstration Application can be installed in a pre-existing Autonomous Transaction Processing Database (ATP), or you can use this code to provision a new ATP and load the Demonstration Application.

Installing the APEX Demonstration Application is documented [here](doco/APEX_DEMO.md)

## Database Version Control
_Not yet documented..._