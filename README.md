# apex-devops-demo
This code has used to:
1. Create an APEX Application in OCI to demonstrate APEX functionality
2. Demonstrate using [SQLcl](https://www.oracle.com/uk/database/technologies/appdev/sqlcl.html), integrated with [Liquibase](https://www.liquibase.org/), to do database version control<sup>*</sup>
3. Illustrate OCI Database creation/cloning methods often used for DevOps "feature branch" isolation.
<sup>*Not yet documented here</sup>

# Assumptions
* An existing OCI tenancy; either Paid or Always Free<sup>*</sup>
* General proficiency with OCI
* A Linux environment with sqlcl installed (_recommended_: an OCI Developer Image Compute Instance)
<sup>*Always Free - Only the APEX Demonstration Application; Use the pre-existing ATP method.</sup>

# Installation
The APEX Demonstration Application can be installed in a pre-existing Autonomous Database (_recommended_: ATP), or you can use this code to provision a new Autonomous Database (ATP) and load the demonstration application.

Download or Clone this repository to your Linux environment.

# Instructions
<details>
<summary>Pre-Existing Autonomous Database</summary>

## Ensure SQLcl is Installed
You should be able to run `sql /nolog` from the command line.  If not, install sqlcl either using your linux package manager (i.e. `dnf install sqlcl.noarch`, `yum install sqlcl.noarch`).  Alternatively, SQLcl can be downloaded from [here](https://www.oracle.com/uk/tools/downloads/sqlcl-downloads.html).

## Download the ATP Wallet
From the OCI Console, download the wallet file for the Autonomous Database and stage in the [wallet](wallet/) directory in its \<DBNAME\>_wallet.zip format

## ADMIN Password
Create a file called `.secret` with the following text (replace \<ADMIN_PASS\> with unquoted, real password):
```
password = <ADMIN_PASS>
```

## Install Demonstration Application
To install the demonstration application into your existing Autonomous Database, where \<DBNAME\> matches your wallet file and service names:
```
./sqlcl_cicd.py deploy --dbName <DBNAME>
```

## Review Post-Installation Notes
Post-Installation [Notes](#Post--Installation-Notes)
</details>


<details>
<summary>Install from Scratch</summary>

## Python Environment
On your linux machine, create an python virtual environment and install OCI
```
python3 -m venv .venv
source .venv/bin/activate
pip install --upgrade pip wheel
pip install oci python-terraform
source .venv/bin/activate
```

# API Access
You will need to generate an API Signing Key as documemented [here](https://docs.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm#apisigningkey_topic_How_to_Generate_an_API_Signing_Key_Console).

The config file should be stored in your home directory's .oci directory (~/.oci/config) and the profile should be called [DEMO]; below is an example:
```
[DEMO]
user=ocid1.user.oc1.....
fingerprint=<fingerprint:...>
tenancy=ocid1.tenancy.oc1.....
compartment=ocid1.compartment.oc1.....
region=eu-frankfurt-1
key_file=~/.oci/key.pem
```

If you would like the ATP to be placed into a specific compartment, add `compartment=<compartment OCID>` into the ~/.oci/config file; If compartment is not specified, resources will be provisioned in the tenancies root compartment.

# Create the ATP
Run the [oci_atp_api.py](oci_atp_api.py) script, as follows:
`./oci_atp_api.py create -e DEV`

The above will create an Autonomous Database called DEMODEV with an ADMIN password stored in the `.secret` file, and download the wallet.

## Install Demonstration Application
To install the demonstration application into the new Autonomous Database:
```
./sqlcl_cicd.py deploy --dbName DEMODEV
```

## Review Post-Installation Notes
Post-Installation [Notes](#Post--Installation-Notes)

</details>

# Post-Installation Notes
## Users and Passwords
The database will have two database users: 
* ADMIN 
* DEMO
Their passwords will be the same as found in the .secret file.

The APEX Application will have a Developer Account called DEMO, which will also have the same password as found in the .secret file.
**It is recommended to change the passwords to be unique for each user**

## APEX Access
1. Log into the OCI console and navigate to the Autonomous Database.  
2. Change to the Tools tab and "Open APEX".
3. On the Adminstration Services page, *click* the link "Workspace Login" link:
	* Workspace: `DEMO`
	* Username:  `DEMO`
	* Password: `<As found in the .secret file>`

## APEX Application Security (AuthN)
The demonstration applications authentication will be set to "OpenAccess"; while there is no sensitive data in the application, it is advised to change the Authorization Scheme to only allow authenticated users as per your requirements.

## Customise
You can customise the demonstration application with you Name/Title and additional Sample Applications.  Sample Applications will dynamically appear on Page 16 (Demonstration) and Page 2 (Application Links).

### Set Name/Title
1. Click on Application 103 - Oracle Application Express
2. Click on Shared Components
3. Click on Application Definition Attributes
4. Under Substitutions, set:
	* PRESENTER_NAME
	* PRESENTER_TITLE


# Terraform 
Terraform IaC code is provided to provision/clone ATP and DBCS databases to demonstrate CI/CD.  There are additional requirements, including installing the terraform software.  This is not covered here. 

### Backend - BEWARE!
This code utilitises a local backend for the Terraform State files.  These files will contain **VERY SENSITIVE** data to enable specific cloning operations.  They *should not* be versioned.  Instead consider utilising a Remote Backed (such as OCI Object Storage) for maintain your Terraform state files.

For more information: (Sensitive Data in State)[https://www.terraform.io/docs/language/state/sensitive-data.html]

### Ignored IaC Code
The [.gitignore] intentionally targets Terraform files used for demonstration purposes from being versioned.  If adopting this code, take this into account and review the [.gitignore] as you may want to version these files (but **NOT** the tfstate files!).


## Example Use
### Create
AATP: `./oci_terraform.py create -t atp  -e DEV`
DBCS: `./oci_terraform.py create -t dbcs -e DEV`
PDB:  `./oci_terraform.py create -t dbcs -e DEV_PDB1`

### Clone
AATP: `./oci_terraform.py clone -t atp  -e 1234 -s DEV`
DBCS: `./oci_terraform.py clone -t dbcs -e 1234 -s DEV`
PDB:  `./oci_terraform.py clone -t pdb  -e 1234_PDB1 -s DEV_PBB1`

### Delete
AATP: `./oci_terraform.py delete -t atp  -e DEV`
DBCS: `./oci_terraform.py delete -t dbcs -e 1234`
PDB:  `./oci_terraform.py delete -t pdb  -e 1234_PDB1`


## Clone DBCS PDBs
| Step | Description                                    | Script Call                                               |       |
| ---- | -----------------------------------------------| ----------------------------------------------------------| ----- |
| 1.   | Create an intital DBCS called DEV with PDB1    | `./oci_terraform.py create -t dbcs -e DEV -p PDB1`        | 17:05 |
| 2.   | Create an intital DBCS called 123 with PDB1    | `./oci_terraform.py create -t dbcs -e 123 -p PDB1`        | 15:31 |
| 3.   | Delete PDB1 from the 123 CDB (Optional)        | `./oci_terraform.py delete -t pdb  -e 123 -p PDB1`        | 02:52 |
| 3.   | Clone PDB1 from the DEV CDB to the 123 CDB     | `./oci_terraform.py clone  -t pdb  -e 123 -s DEV -p PDB1` | 03:19 |
| 4.   | Re-Clone PDB1 from the DEV CDB to the 123 CDB  | `./oci_terraform.py clone  -t pdb  -e 123 -s DEV -p PDB1` | 05:41 |
| 5.   | Create PDB2 in the 123 CDB                     | `./oci_terraform.py create -t pdb  -e 123 -p PDB2`        | 02:52 |
| 6.   | Clone PDB2 from the 123 CDB to the DEV CDB     | `./oci_terraform.py clone  -t pdb  -e DEV -s 123 -p PDB2` |   |
| 7.   | Clone PDB2 from the DEV CDB to the 123 CDB     | `./oci_terraform.py clone  -t pdb  -e 123 -s DEV -p PDB2` |   |
| 8.   | Drop PDB2 from the DEV CDB                     | `./oci_terraform.py delete -t pdb  -e DEV -p PDB2`        |   |
| 9.   | Clean-Up 123 DBCS                              | `./oci_terraform.py delete -t dbcs -e 123`                | 10:14 |
| 10.  | Clean-Up DEV DBCS                              | `./oci_terraform.py delete -t dbcs -e DEV`                | 12:45 |


## Clone DBCS to DBCS
> **_NOTE:_** This is more applicable to non-CDB databases; for CDBs; use Clone DBCS PDBs

| Step | Description                                    | Script Call                                               |       |
| ---- | -----------------------------------------------| ----------------------------------------------------------| ----- |
| 1.   | Create an intital DBCS called DEV              | `./oci_terraform.py create -t dbcs -e NONDEV`             |       |
| 2.   | Clone the DEV DBCS to 123 DBCS                 | `./oci_terraform.py clone  -t dbcs -e NON123`             |       |
| 3.   | Re-Clone the DEV DBCS to 123 DBCS              | `./oci_terraform.py clone  -t dbcs -e NON123`             |       |
| 4.   | Clean-Up DEV DBCS                              | `./oci_terraform.py delete -t dbcs -e NONDEV`             |       |
| 5.   | Clean-Up 123 DBCS                              | `./oci_terraform.py delete -t dbcs -e NON123`             |       |


## Observations
* 11g/12.1 is only supported on GI Installations (not LVM) - Use Clone DBCS to DBCS
* You cannot create a DBCS with a pluggable called DEFAULT
* You cannot clone a full DBCS (DB_SYSTEM) when it has 0 PDBs - Use Clone DBCS PDBs
* You cannot delete a PDB in a DBCS that was created via a clone - Use Clone DBCS PDBs
