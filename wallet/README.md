# Wallet Storage
OCI Database wallet files should be stored here, in their .zip format.  
The standard name is `\<DBNAME\>_wallet.zip` and the file **must** match that standard naming.

Example:
* `APEXDEMODEV_wallet.zip`

Due to a bug in SQLcl, the wallet will be unzip and sqlnet.ora modified.  This also aligns with non-wallet setups.