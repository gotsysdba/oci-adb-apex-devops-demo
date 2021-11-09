#!/bin/env python3
import os, logging, subprocess, sys, argparse, re, json, glob, time
from datetime import timedelta
start = time.time()
# Starting timer before import of oci as it seems to take a bit?!
import oci

# Logging Default
logging.basicConfig(format='[%(asctime)s] %(levelname)8s: %(message)s', 
                    datefmt='%Y-%b-%d %H:%M:%S', level=logging.INFO)
log = logging.getLogger(__name__)

""" GLOBALS
"""
res_prefix="DEMO" #OCI Resource Prefix
os.environ['TF_VAR_res_prefix'] = res_prefix
cdb_version = "19.12.0.0"
leg_version = "11.2.0.4.210420"
lvm_storage = "LVM"
asm_storage = "ASM"

config = oci.config.from_file("~/.oci/config", "DEMO")
working_dir = 'terraform/'

# Set Environment for Terraform Scripts
os.environ['TF_VAR_region'] = config["region"]
os.environ['TF_VAR_tenancy_ocid'] = config["tenancy"]
os.environ['TF_VAR_compartment_ocid'] = config["compartment"] or config["tenancy"]
os.environ['TF_VAR_user_ocid'] = config["user"]
os.environ['TF_VAR_fingerprint'] = config["fingerprint"]
os.environ['TF_VAR_private_key_path'] = config["key_file"]

""" Local Functions
"""
# Terraform Output (separated from terraform_run to capture output)
def terraform_output():
    # Ensure our state is up-to-date
    terraform_run(['apply', '-auto-approve', '-refresh-only'])
    cmd = ['terraform', 'output', '-json' ]
    result = subprocess.run(cmd, cwd=f'{working_dir}', universal_newlines=True,
                            stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    return json.loads(result.stdout)

# Terraform Run (ouput is streamed)
def terraform_run(cmd):
    cmd.insert(0,'terraform')
    log.debug('Running: {} from {}'.format(' '.join(cmd),working_dir))
    result = subprocess.Popen(cmd, cwd=f'{working_dir}', universal_newlines=True,
                              stdout=subprocess.PIPE, stderr=subprocess.STDOUT)

    while True:
        result_line = result.stdout.readline()
        if result.poll() is not None:
            break
        if result_line:
            log.info(result_line.strip())

    retval = result.poll()
    if retval:
        raise Exception('Terraform Error')

    log.info('Terraform command successful')

# Determine Terraform resource file name
def get_db_file(db_type, db_name, pdb_name=None):
    if db_type in ('dbcs','atp'):
        db_file  = os.path.join(working_dir,f'{db_type}_{db_name}.tf')
    elif db_type == 'pdb':
        db_file = os.path.join(working_dir,f'pdb_{db_name}_{pdb_name}.tf')

    return db_file

# Write out Terraform resource files
def write_tf(output_file, license, pdbName=None, clone=None, dbSource="NONE", dbSourceId=None, sysSourceId=None):
    log.info(f'Writing File: {output_file}')
    db_details = re.split('\/|_|\.',output_file)
    log.debug(db_details)
    if clone == "PDB":
        template_file = os.path.join(working_dir,'templates',f'{db_details[1]}_rclone.tf.tmpl')
    else:
        template_file = os.path.join(working_dir,'templates',f'{db_details[1]}.tf.tmpl')

    replacements = {
      "<DB_NAME>" : db_details[2],
      "<DB_VERSION>" : cdb_version,
      "<DB_STORAGE>" : lvm_storage,
      "<PDB_NAME>" : pdbName or "null",

      "<NONE|DATABASE|CDB>" : dbSource,
      "<DB_SOURCE_ID>" : dbSourceId or "null",
      "<SYSTEM_SOURCE_ID>" : sysSourceId or "null",
      "<FULL|METADATA>" : clone or "null",
      "<LICENSE>" : license
    }
    regex = re.compile("|".join(map(re.escape, replacements.keys(  ))))

    log.debug(f'Writing {template_file} to {output_file}')
    with open(template_file, "r") as source:
        lines = source.readlines()

    with open(output_file, "w") as target:
        for line in lines:
            target.write(regex.sub(lambda match: replacements[match.group(0)], line))

# Delete Terraform resource files
def remove_tf(output_file):
    log.info(f'Removing file: {output_file}')
    try:
        os.remove(output_file)
    except:
        log.debug(f'Unable to find {output_file} resource file.')

# Get PDBs in a CDB
def get_pdbs(cdb, pdb=None):
    log.info(f'Retrieving PDBs in {cdb}')
    pdbs = {}
    output = terraform_output()
    for indy_pdb in output[f"dbcs_{cdb}_pdbs"]["value"]["pluggable_databases"]:
        log.debug(f'Found PDB: {indy_pdb["pdb_name"]}: {indy_pdb["id"]} ({indy_pdb["state"]})')
        try:
            if pdb and indy_pdb["pdb_name"] != pdb:
                continue
            if indy_pdb["state"] != 'TERMINATED':
                log.debug(f'Adding {indy_pdb["pdb_name"]} to dictionary')
                pdbs[indy_pdb["pdb_name"]] = indy_pdb["id"]
        except KeyError:
            continue

    log.debug(f'Dictionary: {pdbs}')
    return pdbs

# Detele Terraform Resource
def delete_db(db_type, db_file, cdb_name=None):
    remove_tf(db_file)
    if db_type == 'dbcs':
        for pdb_files in glob.glob(os.path.join(working_dir,f'pdb_{cdb_name}_*.tf')):
            remove_tf(pdb_files)
    terraform_run(['apply', '-auto-approve', '-input=false'])


if __name__ == "__main__":
    """ INIT
    """
    # Argument Parser
    parent_parser = argparse.ArgumentParser(description='Terraform Utility', add_help=False)
    parent_parser.add_argument('--compartment', '-c', required=False, action='store', 
        help='Tenancy Compartment')
    parent_parser.add_argument('--environment', '-e', required=True, action='store', type = str.upper,
        help='Environment (i.e. PRD, DEV, UAT, Ticket#)')
    parent_parser.add_argument('--dbType', '-t', required=True, action='store', type = str.lower,
        help='Database Type', choices=['atp','dbcs','pdb'], default='atp')
    parent_parser.add_argument('--debug',  '-d', required=False, action='store_true', help='Enable Debug')

    parser = argparse.ArgumentParser(add_help=False)
    subparsers = parser.add_subparsers(dest='action')


    parser_create = subparsers.add_parser('create', parents = [parent_parser])
    parser_create.add_argument('--license', '-l', required=False, action='store', type = str.upper,
        help='License', choices=['BRING_YOUR_OWN_LICENSE','LICENSE_INCLUDED'], default='BRING_YOUR_OWN_LICENSE')
    parser_create.add_argument('--pdb', '-p', required=False, action='store', type = str.upper,
        help='PDB Name', default='STUB')


    parser_clone = subparsers.add_parser('clone',  parents = [parent_parser])
    parser_clone.add_argument('--source', '-s', required=True, action='store', type = str.upper,
        help='Clone DB Source (i.e. <CDB>, <CBD_PDB>)', default='DEV')
    parser_clone.add_argument('--license', '-l', required=False, action='store', type = str.upper,
        help='License', choices=['BRING_YOUR_OWN_LICENSE','LICENSE_INCLUDED'], default='BRING_YOUR_OWN_LICENSE')
    parser_clone.add_argument('--pdb', '-p', required=False, action='store', type = str.upper,
        help='PDB Name', default='STUB')

    parser_delete = subparsers.add_parser('delete', parents = [parent_parser])
    parser_delete.add_argument('--pdb', '-p', required=False, action='store', type = str.upper,
        help='PDB Name', default='STUB')

    if len(sys.argv[1:])==0:
        parser.print_help()
        parser.exit()

    args = parser.parse_args()

    if args.debug:
        logging.getLogger().setLevel(logging.DEBUG)
        logging.debug("Debugging Enabled")

    logging.debug('Arguments: {}'.format(args))

    """ MAIN
    """
    # Standards
    db_name  = f'{res_prefix}{args.environment}'
    try:
        pdb_name = f'{args.pdb}'
    except AttributeError:
        pdb_name = None

    """ CREATE
    """
    if args.action == 'create':
        db_file = get_db_file(args.dbType, db_name=db_name, pdb_name=pdb_name)
        write_tf(db_file, args.license, pdbName=pdb_name, clone=None, dbSource="NONE", dbSourceId=None, sysSourceId=None)
        terraform_run(['init'])
        terraform_run(['apply', '-auto-approve', '-input=false'])
        if args.dbType == 'dbcs':
            cdb_pdbs = get_pdbs(db_name)
            # Once the DBCS has been created, register its PDBs with the state
            for indy_pdb in cdb_pdbs:
                log.info(f'Verifying {indy_pdb} in {db_name} is registered in state.')
                db_file = get_db_file('pdb', db_name=db_name, pdb_name=indy_pdb)
                if not os.path.isfile(db_file):
                    write_tf(db_file, args.license, pdbName=indy_pdb, clone=None, dbSource="NONE", dbSourceId=None, sysSourceId=None)
                    terraform_run(['import', f'oci_database_pluggable_database.{db_name}_{indy_pdb}', cdb_pdbs[indy_pdb]])                    

    """ CLONE
    """
    if args.action == 'clone':
        db_file = get_db_file(args.dbType, db_name=db_name, pdb_name=pdb_name)
        # Delete Existing target
        delete_db(args.dbType, db_file, db_name)

        # Start the Clone
        if args.dbType == 'dbcs':
            db_ocid=f'module.{args.dbType}_{res_prefix}{args.source}.db_ocid'
            sys_ocid=f'module.{args.dbType}_{res_prefix}{args.source}.system_ocid'
            sleep_time = 0
            write_tf(db_file, args.license, pdbName=None, clone="FULL", dbSource="DB_SYSTEM", dbSourceId=db_ocid, sysSourceId=sys_ocid)
        elif args.dbType == 'pdb':
            source_cdb = f'{res_prefix}{args.source}'
            sleep_time = 60
            write_tf(db_file, args.license, pdbName=pdb_name, clone="PDB", dbSource=source_cdb)

        terraform_run(['apply', '-auto-approve', '-input=false'])
        log.info(f'Sleeping for {sleep_time}... please be patient.')
        time.sleep(sleep_time)    

        # Import the PDB resources (remote PDB clones are not importable as is, update the tf file.)
        cdb_pdbs = get_pdbs(db_name, pdb_name)
        for indy_pdb in cdb_pdbs:
            log.info(f'Verifying {indy_pdb} in {db_name} is registered in state.')
            db_file = os.path.join(working_dir,f'pdb_{db_name}_{indy_pdb}.tf')
            if not os.path.isfile(db_file) or args.dbType == 'pdb':
                write_tf(db_file, args.license, pdbName=indy_pdb, clone=None, dbSource="NONE", dbSourceId=None, sysSourceId=None)
                terraform_run(['import', f'oci_database_pluggable_database.{db_name}_{indy_pdb}', cdb_pdbs[indy_pdb]])
        terraform_run(['apply', '-auto-approve', '-refresh-only'])

    """ DELETE
    """
    if args.action == 'delete':
        db_file = get_db_file(args.dbType, db_name=db_name, pdb_name=pdb_name)
        delete_db(args.dbType, db_file, db_name)
     
terraform_run(['apply', '-auto-approve', '-refresh-only'])
end = time.time()
elapsed = str(timedelta(seconds=(end - start)))
log.info(f'*** Total Elapsed Time: {elapsed}')