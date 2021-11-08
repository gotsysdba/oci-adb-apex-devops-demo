# Timings
The below timings are to give a general idea of how long it takes to both stand-up a new database and to clone it.  

Timings are taken directly from the Terraform output, for example:
``module.devops_dbcs.oci_database_db_system.db_system: Creation complete after 14m8s [id=ocid1.dbsystem.oc1...]``

## Creation

| dbType      | Duration | Storage  | Storage Size | Nodes | CPU | Shape          |
| ----------- | -------- | -------- | ------------ | ----- | --- | -------------- |
| DBCS        | 16m19s   | LVM      | 1 TB         | 1     | 4   | VM.Standard2.4 |
| DBCS        | 14m10s   | LVM      | 2 TB         | 1     | 4   | VM.Standard2.4 |
| DBCS        | 15m12s   | LVM      | 1 TB         | 1     | 8   | VM.Standard2.8 |
| DBCS        | 14m16s   | LVM      | 2 TB         | 1     | 8   | VM.Standard2.8 |

### Creation Observations
Timings to provision a new DBCS are wholey dependant on the number of nodes and Storage Type (Oracle Grid Infrastructure (GI) vs Logical Volumn Manager (LVM)).  Shape and Storage Size have no impact on timings.

## Cloning
Note: `DBCS - PDB` indicates remote cloning of a PDB from one DBCS to another, not local cloning within the same CDB.

| dbType      | Duration | Storage  | Storage Size | Nodes | CPU | Shape          |
| ----------- | -------- | -------- | ------------ | ----- | --- | -------------- |
| DBCS        | 22m14s   | LVM      | 1 TB         | 1     | 4   | VM.Standard2.4 |
| DBCS        | 25m55s   | LVM      | 2 TB         | 1     | 4   | VM.Standard2.4 |
| DBCS        | 24m32s   | LVM      | 1 TB         | 1     | 8   | VM.Standard2.8 |
| DBCS        | 25m4s    | LVM      | 2 TB         | 1     | 8   | VM.Standard2.8 |
| DBCS - PDB  |          | LVM      | 1 TB         | 1     | 4   | VM.Standard2.4 |
| DBCS - PDB  |          | LVM      | 2 TB         | 1     | 4   | VM.Standard2.4 |
| DBCS - PDB  |          | LVM      | 1 TB         | 1     | 8   | VM.Standard2.8 |
| DBCS - PDB  |          | LVM      | 2 TB         | 1     | 8   | VM.Standard2.8 |

### Cloning Observations
Timings to clone a new DBCS are wholey dependant on the number of nodes and Storage Type (Oracle Grid Infrastructure (GI) vs Logical Volumn Manager (LVM)).  Shape and Storage Size have no impact on timings.


# References
The specification of Compute Shapes can be found (here)[https://docs.oracle.com/en-us/iaas/Content/Compute/References/computeshapes.htm].