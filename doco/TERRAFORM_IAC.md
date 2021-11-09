# Terraform 
Terraform Infrastructure as Code (IaC) is provided here as an example of provisioning/cloning Autonomous Transaction Processing (ATP) databases, VM Database Cloud Service (DBCS) databases, and Pluggable databases (PDB in a DBCS Container Database (CDB)).

The [`terraform`](../terraform) directory contains all the configuration files to explore this functionality.  All new resource configuration files created during the demonstration will also be created in the  [`terraform`](../terraform) directory  

## Requirements
In addition to **OCI [API Access](../README.md)**:
* **Terraform Binary** - Installation instructions can be found [on Terraforms website](https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/oci-get-started)

## Caveats
### Backend - BEWARE!
This code utilitises a [local backend](https://www.terraform.io/docs/language/settings/backends/index.html) for the Terraform State files.  These files will contain **VERY SENSITIVE** data to enable specific cloning operations.  They *should not* be versioned.  Instead consider utilising a Remote Backed such as [OCI Object Storage](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformUsingObjectStore.htm) for maintaining your Terraform state files.

For more information: [Sensitive Data in State](https://www.terraform.io/docs/language/state/sensitive-data.html)

Note that for DevOps CI/CD; the state file will need to be centralised in a [remote backend](https://www.terraform.io/docs/language/settings/backends/index.html) to ensure proper locking and tracking.

### Ignored IaC Code
The [`.gitignore`](../.gitignore) intentionally targets Terraform files used for demonstration purposes from being versioned.  If adopting this code, take this into account and review the [`.gitignore`](../.gitignore) as you may want to version these files (but **NOT** the tfstate files!).

### Usage of Modules
[Terraform modules](https://www.terraform.io/docs/language/modules/syntax.html), while not necessary, are being used to illustrate a way to enforce (and easily reconcile) database standards.

## Example Use
Once the OCI [API Access](../README.md) has been configured, the [`oci_terraform.py`](../oci_terraform.py) helper script can be used to 

### Create
* ATP:  `./oci_terraform.py create -t atp  -e DEV`
* DBCS: `./oci_terraform.py create -t dbcs -e DEV -p PDB1`
* PDB:  `./oci_terraform.py create -t dbcs -e DEV -p PDB2`

### Clone
* ATP:  `./oci_terraform.py clone -t atp  -e 123 -s DEV`
* DBCS: `./oci_terraform.py clone -t dbcs -e 123 -s DEV`
* PDB:  `./oci_terraform.py clone -t pdb  -e 123 -s DEV -p PDB1`

### Delete
* ATP:  `./oci_terraform.py delete -t atp  -e DEV`
* DBCS: `./oci_terraform.py delete -t dbcs -e 123`
* PDB:  `./oci_terraform.py delete -t pdb  -e 123 -p PDB1`

# Demonstration
The following commands will illustate using IaC for cloning operations

## Clone DBCS PDBs (1TB Allocated - 10GB in use)
[Additional timings in regards to size/shape](doco/TIMINGS.md))
| Step | Description                                   | Script Call                                               |       |
| ---- | ----------------------------------------------| ----------------------------------------------------------| ----- |
| 1.   | Create an intital DBCS called DEV with PDB1   | `./oci_terraform.py create -t dbcs -e DEV -p PDB1`        | 14:59 |
| 2.   | Create an intital DBCS called 123 with PDB1   | `./oci_terraform.py create -t dbcs -e 123 -p PDB1`        | 15:31 |
| 3.   | Delete PDB1 from the 123 CDB (Optional)       | `./oci_terraform.py delete -t pdb  -e 123 -p PDB1`        | 02:49 |
| 4.   | Clone PDB1 from the DEV CDB to the 123 CDB    | `./oci_terraform.py clone  -t pdb  -e 123 -s DEV -p PDB1` | 03:28 |
| 5.   | Re-Clone PDB1 from the DEV CDB to the 123 CDB | `./oci_terraform.py clone  -t pdb  -e 123 -s DEV -p PDB1` | 06:48 |
| 6.   | Create PDB2 in the 123 CDB                    | `./oci_terraform.py create -t pdb  -e 123 -p PDB2`        | 04:24 |
| 7.   | Clone PDB2 from the 123 CDB to the DEV CDB    | `./oci_terraform.py clone  -t pdb  -e DEV -s 123 -p PDB2` | 03:50 |
| 8.   | Clone PDB2 from the DEV CDB to the 123 CDB    | `./oci_terraform.py clone  -t pdb  -e 123 -s DEV -p PDB2` | 06:04 |
| 9.   | Drop PDB2 from the DEV CDB                    | `./oci_terraform.py delete -t pdb  -e DEV -p PDB2`        | 03:14 |
| 10.  | Clean-Up 123 DBCS                             | `./oci_terraform.py delete -t dbcs -e 123`                | 05:21 |
| 11.  | Clean-Up DEV DBCS                             | `./oci_terraform.py delete -t dbcs -e DEV`                | 06:02 |


## Clone DBCS to DBCS (1TB Allocated - 10GB in use)
[Additional timings in regards to size/shape](doco/TIMINGS.md))
> **_NOTE:_** This is more applicable to non-CDB databases; for CDBs; use Clone DBCS PDBs

| Step | Description                                   | Script Call                                               |       |
| ---- | ----------------------------------------------| ----------------------------------------------------------| ----- |
| 1.   | Create an intital DBCS called NONDEV          | `./oci_terraform.py create -t dbcs -e NONDEV -p 11g`      | 40:39 |
| 2.   | Clone the NONDEV DBCS to NON123 DBCS          | `./oci_terraform.py clone  -t dbcs -e NON123 -p 11g`      | 42:32 |
| 3.   | Re-Clone the NONDEV DBCS to NON123 DBCS       | `./oci_terraform.py clone  -t dbcs -e NON123 -p 11g`      | 58:16 |
| 4.   | Clean-Up NONDEV DBCS                          | `./oci_terraform.py delete -t dbcs -e NONDEV`             | 09:04 |
| 5.   | Clean-Up NON123 DBCS                          | `./oci_terraform.py delete -t dbcs -e NON123`             | 11:34 |

### Observations
* 11g/12.1 is only supported on GI Installations (not LVM) - Use Clone DBCS to DBCS
* You cannot create a DBCS with a pluggable called DEFAULT
* You cannot clone a full DBCS (DB_SYSTEM) when it has 0 PDBs - Use Clone DBCS PDBs
* You cannot delete a PDB in a DBCS that was created via a clone - Use Clone DBCS PDBs