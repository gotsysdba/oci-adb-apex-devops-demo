# apex-devops-demo

# Instructions
## Provision an ATP-S ADB
## Open APEX
### Sign in with ADMIN Username
### Create Workspace
#### Database User: DEMO
#### Password: <Secure Password>
#### Workspace Name: DEMO

# SQLcl
## set cloudconfig ../tnsadmin/Wallet_APEXPRES.zip
## conn demo/<Secure Password>@<DB>_TP
## cd database
## lb update -changelog controller.xml
## cd ../apex
## lb update -changelog controller.xml