# Installation Methods
- [Pre-Existing Autonomous Database](#Pre--Existing-Autonomous-Database)
- [Install from Scratch](#From-Scratch)

# SQLcl Requriement
For both installation methods SQLcl is required.  

If using the (OL Cloud Developer Image)[https://docs.oracle.com/en-us/iaas/oracle-linux/developer/index.htm#About-the-Oracle-Linux-Cloud-D] on a Compute Instance, this will already be installed.

You should be able to run `sql /nolog` from the command line.  If not, install SQLcl either using your linux package manager (i.e. `dnf install sqlcl.noarch`, `yum install sqlcl.noarch`).  Alternatively, SQLcl can be downloaded from [here](https://www.oracle.com/uk/tools/downloads/sqlcl-downloads.html).


## Pre-Existing Autonomous Database
Applicable for both Always Free and Paid Tenancies.

### Download the ATP Wallet
From the OCI Console, download the wallet file for the Autonomous Database and stage in the [wallet](../wallet/) directory in its \<DBNAME\>_wallet.zip format

### ADMIN Password
Create a file called `.secret` with the following text (replace \<ADMIN_PASS\> with unquoted, real password):
```
password = <ADMIN_PASS>
```
in the same directory as the [`sqlcl_cicd.py`](../sqlcl_cicd.py) script

### Install Demonstration Application
To install the demonstration application into your existing Autonomous Database, where \<DBNAME\> matches your wallet file and service names:
```
./sqlcl_cicd.py deploy --dbName <DBNAME>
```

### Review Post-Installation Notes
Post-Installation [Notes](#post-installation-notes)

## Install from Scratch
Only applicable for Paid Tenancies.

### Python Environment
On your linux machine, create an python virtual environment and install the OCI python module
```
python3 -m venv .venv
source .venv/bin/activate
pip install --upgrade pip wheel
pip install oci python-terraform
source .venv/bin/activate
```

### Create the ATP
Run the [`oci_atp_api.py`](../oci_atp_api.py) script, as follows:
`./oci_atp_api.py create -e DEV`

The above will create an Autonomous Database called DEMODEV with an ADMIN password stored in the `.secret` file, and download the wallet.

### Install Demonstration Application
To install the demonstration application into the new Autonomous Database:
```
./sqlcl_cicd.py deploy --dbName DEMODEV
```

### Review Post-Installation Notes
Post-Installation [Notes](#post-installation-notes)

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
