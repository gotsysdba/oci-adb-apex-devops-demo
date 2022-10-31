#!/bin/env python3
import argparse, logging, subprocess, os, sys, glob 
from datetime import datetime

# Logging Default
level    = logging.INFO
format   = '[%(asctime)s] %(levelname)8s: %(message)s'
handlers = [logging.StreamHandler()]
datefmt  = '%Y-%b-%d %H:%M:%S'
logging.basicConfig(level = level, format = format, handlers = handlers, datefmt=datefmt)
log = logging.getLogger(__name__)

""" Functions
"""
def run_sqlcl(schema, password, service, path, cmd, resolution, conn_file, run_as):
    lb_env = os.environ.copy()
    lb_env['password']  = password

    if resolution == 'wallet':
        wallet = f'set cloudconfig {conn_file}'
    else:
        wallet = '-- Using tnsnames.ora'
        lb_env['TNS_ADMIN'] = tns_admin #<-Global

    # Keep password off the command line/shell history
    sql_cmd = f'''
        {wallet}
        conn {run_as}/{password}@{service}_high
        {cmd}
    '''

    log.debug(f'Running: {sql_cmd}')
    result = subprocess.run(['sql', '/nolog'], universal_newlines=True, cwd=f'./{path}', input=f'{sql_cmd}', env=lb_env,
                            stdout=subprocess.PIPE, stderr=subprocess.PIPE)

    exit_status = 0
    error_matches = ['Error Message','ORA-','SQL Error','Validation Failed']
    result_list = result.stdout.splitlines();
    for line in filter(None, result_list):
        log.info(line)
        if any(x in line for x in error_matches):
            exit_status = 1
    if result.returncode or exit_status:
        log.fatal('Exiting...')
        sys.exit(1)

    log.info('SQLcl command successful')


def deploy_call(path, user, password, resolution, conn_file, args):
    if os.path.exists(os.path.join(path, 'controller.xml')):
        log.info(f'Running {path}/controller.xml as {user}')
        cmd = f'lb update -changelog-file controller.xml;'
        run_sqlcl(args.dbUser, password, args.dbName, path, cmd, resolution, conn_file, user)
        
def deploy(password, resolution, conn_file, args):
    deploy_call('admin', 'ADMIN', password, resolution, conn_file, args)
    deploy_call('schema', f'ADMIN[{args.dbUser}]', password, resolution, conn_file, args)
    deploy_call('data', f'ADMIN[{args.dbUser}]', password, resolution, conn_file, args)
    deploy_call('apex', f'ADMIN[{args.dbUser}]', password, resolution, conn_file, args)   

def generate(password, resolution, conn_file, args):
    cmd = 'lb generate-schema -grants -split -runonchange -fail-on-error'  
    run_sqlcl(args.dbUser, password, args.dbName, 'schema', cmd, resolution, conn_file, f'ADMIN[{args.dbUser}]')

    cmd = 'apex export -applicationid 103 -skipExportDate -expOriginalIds -expSupportingObjects Y'
    run_sqlcl(args.dbUser, password, args.dbName, 'apex', cmd, resolution, conn_file, f'ADMIN[{args.dbUser}]')

    # To avoid false changes impacting version control, replace schema names
    # You do you, here:
    log.info('Cleaning up genschema...')
    for filepath in glob.iglob('./**/*.xml', recursive=True):
        # I don't know when runInTransaction started showing up, but it's bad for this
        # and there doesn't seem to be a way to turn it off
        if filepath.startswith('./apex/f'):
          log.info(f'Extra Processing of APEX Application File {filepath}')
          s = s.replace('runInTransaction="false"', '')
        with open(filepath, "w") as file:
            file.write(s)

def destroy(password, resolution, conn_file, args):
    cmd = 'lb rollback -changelog controller.xml -count 999;'
    run_sqlcl(args.dbUser, password, args.dbName, 'admin', cmd, resolution, conn_file, 'ADMIN')
    
""" INIT
"""
if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='CI/CD Liquibase Helper')
    parent_parser = argparse.ArgumentParser(add_help=False)
    parent_parser.add_argument('--dbName',   required=True,  action='store',      help='Database Name')
    parent_parser.add_argument('--dbUser',   required=True,  action='store',      help='Schema User')
    parent_parser.add_argument('--dbPass',   required=False, action='store',      help='ADMIN Password')
    parent_parser.add_argument('--dbWallet', required=False, action='store',      help='Database Wallet')
    parent_parser.add_argument('--debug',    required=False, action='store_true', help='Enable Debug')

    subparsers = parser.add_subparsers(help='Actions')
    # Deploy
    deploy_parser = subparsers.add_parser('deploy', parents=[parent_parser], 
        help='Deploy'
    )
    deploy_parser.set_defaults(func=deploy,action='deploy')

    # Generate 
    generate_parser = subparsers.add_parser('generate', parents=[parent_parser], 
        help='Generate Changelogs'
    )
    generate_parser.set_defaults(func=generate,action='generate')

    # Destroy
    destroy_parser = subparsers.add_parser('destroy', parents=[parent_parser], 
        help='Destroy'
    )
    destroy_parser.set_defaults(func=destroy,action='destroy')    

    if len(sys.argv[1:])==0:
        parser.print_help()
        parser.exit()

    args = parser.parse_args()

    if args.debug:
        log.getLogger().setLevel(logging.DEBUG)
        log.debug("Debugging Enabled")

    log.debug('Arguments: {}'.format(args))

    """ MAIN
    """
    if args.dbPass:
        password = args.dbPass
    else:
        try:
            f = open(".secret", "r")
            password = f.readline().split()[-1]
        except:
            log.fatal('Database password required')
            sys.exit(1)
            
    resolution = 'wallet' # Default
    conn_file  = None
    if args.dbWallet:
        conn_file     = args.dbWallet
    else:
        tns_admin = os.environ['TNS_ADMIN']
        if os.path.exists(f'{tns_admin}/tnsnames.ora'):
            resolution   = 'tnsnames'
            conn_file    = '{tns_admin}/tnsnames.ora'
        elif os.path.exists(f'{tns_admin}/{args.dbName}_wallet.zip'):
            conn_file = f'{tns_admin}/{args.dbName}_wallet.zip'

    args.func(password, resolution, conn_file,  args)
    sys.exit(0)