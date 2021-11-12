#!/bin/env python3
import oci, os, argparse, sys, logging, re, string, datetime
from random import *

# Logging Default
logging.basicConfig(format='[%(asctime)s] %(levelname)8s: %(message)s', 
                    datefmt='%Y-%b-%d %H:%M:%S', level=logging.INFO)
log = logging.getLogger(__name__)


""" GLOBALS
"""
atp_status = "NONE"


""" Local Functions
"""
def passGen(upper,lower,spec,num,min,max):
    letters = string.ascii_letters
    digits  = string.digits
    special = "_#"

    comp_chars = upper+lower+spec
    if upper > 0 or lower > 0:
        pass_chars = letters
    if spec > 0:
        pass_chars = pass_chars + special
    if num > 0:
        pass_chars = pass_chars + digits
    init_password = "".join(choice(pass_chars) for t in range(randint(min-comp_chars,max-comp_chars)))
    for i in range(upper):
        init_password += choice(letters).upper()
    for i in range(lower):
        init_password += choice(letters).lower()
    for x in range(spec):
        init_password += choice(special)
    for y in range(num):
        init_password += choice(digits)

    list_password = list(init_password)
    shuffle(list_password)
    list_password.insert(0,choice(letters))
    password = "".join(list_password)

    # Write password to .secret
    f = open(".secret", "w")
    f.write(f'password = {password}')
    f.close()

    return password


def get_atp_ocid(db_client, compartment_id, display_name, order='DESC'):
    log.debug(f'Looking for {display_name} in {compartment_id}')
    atp_info = db_client.list_autonomous_databases(
        compartment_id=compartment_id, display_name=display_name, sort_by='TIMECREATED', sort_order=order)

    log.debug(f'Found: {atp_info.data[0].display_name} in state: {atp_info.data[0].lifecycle_state}')
    return atp_info.data[0].id, atp_info.data[0].lifecycle_state


def create_atp(db_client, atp_details):
    # Provision a new ATP Database
    try:
        atp_response = db_client.create_autonomous_database(
            create_autonomous_database_details=atp_details)
    except:
        raise

    # Get the OCID for the new ATP Database
    atp_id = atp_response.data.id
    wait(db_client, atp_id, 'AVAILABLE')

    get_wallet(db_client, atp_id, atp_details.admin_password, walletFile)

def wait_callback(attempts, results):
    global atp_status
    if atp_status != results.data.lifecycle_state:
        atp_status = results.data.lifecycle_state
        #cheeky
        now = datetime.datetime.now().strftime('%Y-%b-%d %H:%M:%S')
        print('[{}] {:>8}: {}'.format(now, 'INFO', atp_status), end='', flush=True)
    else:
        print('.', end='', flush=True)

def wait(db_client, atp_id, lifecycle_wait):
    # Wait for the OCI Process to finish
    get_atp_response = oci.wait_until(
        db_client,
        db_client.get_autonomous_database(atp_id),
        'lifecycle_state',
        lifecycle_wait,
        max_interval_seconds=60,
        max_wait_seconds=21600,
        wait_callback = wait_callback
    )
    print(lifecycle_wait)

def get_wallet(db_client, atp_id, password, fileName):
    # Create a wallet details object
    atp_wallet = oci.database.models.GenerateAutonomousDatabaseWalletDetails()

    # Set the password
    atp_wallet.password = password

    # Generate the wallet and store the response object
    atp_wallet_response = db_client.generate_autonomous_database_wallet(
        autonomous_database_id = atp_id,
        generate_autonomous_database_wallet_details = atp_wallet,
    )

    # Create the new .zip file using the atp_wallet_response data
    try:
        os.makedirs('wallet', exist_ok = True)
    except OSError as error:
        raise

    walletFile = os.path.join('wallet',fileName)
    with open(walletFile, "wb") as f:
        for data in atp_wallet_response.data:
            f.write(data)

    log.info(f'Wallet Downloaded \x1b[31m***Keep {walletFile} secure. It can be used to access your Database!***\x1b[0m')

def popluate_model(model, compartment_id, display_name, db_name, license):
    # Generate a Password for ADMIN/WALLET
    atp_password = passGen(1,1,1,1,8,26)

    # Populate the details used to create/clone the ATP Database
    model.compartment_id = compartment_id
    model.display_name = display_name
    model.db_name = db_name
    model.admin_password = atp_password
    model.cpu_core_count = 1
    model.data_storage_size_in_tbs = 1
    model.license_model = license


# CI/CD Actions
def clone(db_client, atp_lifecycle, display_name, db_name, compartment_id, license, source):
    if atp_lifecycle in ('AVAILABLE','STOPPED','PROVISIONING'):
        sys.exit(log.fatal(f'ATP {display_name} already exists ({atp_lifecycle})'))

    # Create the Model object
    atp_details = oci.database.models.CreateAutonomousDatabaseCloneDetails()
    popluate_model(atp_details, compartment_id, display_name, db_name, license)

    source_name = f'{display_prefix}-{source}'
    source_id, clone_lifecycle = get_atp_ocid(db_client, compartment_id, source_name, 'DESC')
    if not clone_lifecycle in ('AVAILABLE','STOPPED'):
        sys.exit(log.fatal(f'ATP {source_name} cannot be cloned ({clone_lifecycle})'))
    
    # Add additional details for cloning
    atp_details.source     = "DATABASE"
    atp_details.source_id  = f'{source_id}'
    atp_details.clone_type = "FULL"

    log.info(f'Cloning ATP Database: {source_name} to {db_name}')
    create_atp(db_client, atp_details)

def create(db_client, atp_lifecycle, display_name, db_name, compartment_id, license ):
    if atp_lifecycle in ('AVAILABLE','STOPPED','PROVISIONING'):
        sys.exit(log.fatal(f'ATP {display_name} already exists ({atp_lifecycle})'))

    # Create the Model object
    atp_details = oci.database.models.CreateAutonomousDatabaseDetails()
    popluate_model(atp_details, compartment_id, display_name, db_name, license)

    log.info(f'Creating ATP Database: {db_name}')
    create_atp(db_client, atp_details)


def delete(db_client, atp_id, atp_lifecycle, walletFile, display_name, db_name, compartment_id):
    # Delete Wallet
    try:
        os.remove(os.path.join('wallet',walletFile))
    except:
        pass

    if atp_lifecycle in ('NOT_PROVISIONED','TERMINATED','TERMINATING','PROVISIONING'):
        sys.exit(log.fatal(f'Unable to delete {display_name} ({atp_lifecycle})'))

    # Delete the ATP
    log.info(f'Deleting ATP Database: {db_name}')
    db_client.delete_autonomous_database(atp_id)
    wait(db_client, atp_id, 'TERMINATED')


if __name__ == "__main__":
    """ INIT
    """
    # Argument Parser
    parent_parser = argparse.ArgumentParser(description='ATP Utility', add_help=False)
    parent_parser.add_argument('--config', '-c', required=False, action='store', 
        help='Config file Profile', default='DEMO')
    parent_parser.add_argument('--environment', '-e', required=True, action='store', type = str.upper,
        help='ATP Environment (i.e. PRD, DEV, UAT, Ticket#)')
    parent_parser.add_argument('--debug',  '-d', required=False, action='store_true', help='Enable Debug')


    parser = argparse.ArgumentParser(add_help=False)
    subparsers = parser.add_subparsers(dest='action')

    parser_create = subparsers.add_parser('create', parents = [parent_parser])
    parser_create.add_argument('--license', '-l', required=False, action='store', type = str.upper,
        help='ATP License', choices=['BRING_YOUR_OWN_LICENSE','LICENSE_INCLUDED'], default='BRING_YOUR_OWN_LICENSE')
    parser_create.add_argument('--always-free', '-f', action='store_true', default=False, required=False, 
        help="Always Free Tier")

    parser_clone = subparsers.add_parser('clone',  parents = [parent_parser])
    parser_clone.add_argument('--source', '-s', required=True, action='store', type = str.upper,
        help='ATP Clone DB Source (i.e. PRD, DEV, UAT)', default='DEV')
    parser_clone.add_argument('--license', '-l', required=False, action='store', type = str.upper,
        help='ATP License', choices=['BRING_YOUR_OWN_LICENSE','LICENSE_INCLUDED'], default='BRING_YOUR_OWN_LICENSE')

    parser_delete = subparsers.add_parser('delete', parents = [parent_parser])

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
    # Get the configuration
    config = oci.config.from_file("~/.oci/config", args.config)
    display_prefix = args.config
    log.debug(config)

    # Initialize the OCI DatabaseClient witht the configuration file
    db_client = oci.database.DatabaseClient(config)

    # Set the Compartment, DisplayName, WalletFile
    compartment_id = config["compartment"] or config["tenancy"]
    display_name   = f'{display_prefix}-{args.environment}'
    db_name        = re.sub(r'\W+', '', display_name)
    walletFile     = f'{db_name}_wallet.zip'

    # Lookup the ATP, based on action, may need to fail
    try:
        atp_id, atp_lifecycle = get_atp_ocid(db_client, compartment_id, display_name, 'DESC')
    except:
        atp_lifecycle = 'NOT_PROVISIONED'

    if args.action == 'delete':
        delete(db_client, atp_id, atp_lifecycle, walletFile, display_name, db_name, compartment_id)
    elif args.action == 'create':
        create(db_client, atp_lifecycle, display_name, db_name, compartment_id, args.license)
    elif args.action == 'clone':
        clone(db_client, atp_lifecycle, display_name, db_name, compartment_id, args.license, args.source)

    sys.exit(0)