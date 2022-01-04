#!/bin/env python3
import argparse, logging, subprocess, os, sys, glob

# Logging Default
logging.basicConfig(format='[%(asctime)s] %(levelname)8s: %(message)s', 
                    datefmt='%Y-%b-%d %H:%M:%S', level=logging.INFO)
log = logging.getLogger(__name__)

""" GLOBALS
"""

""" Functions
"""
def run_sqlcl(schema, password, service, cmd):
    log.debug(f'Running: {cmd}')

    conn = ['sql', '-cloudconfig', f'wallet/{service}_wallet.zip', f'{schema}/{password}@{service}_high']
    result = subprocess.run(conn, universal_newlines=True, input=f'{cmd}',
                            stdout=subprocess.PIPE, stderr=subprocess.PIPE)

    result_list = result.stdout.splitlines();
    for line in filter(None, result_list):
        log.info(line)
    if result.returncode:
        sys.exit(log.fatal('Exiting...'))

    log.info('SQLcl command successful')


def lb_update(password, dbName):
    log.info('Running controller.admin.xml')
    cmd = f'lb update -emit_schema -changelog controller.admin.xml;'
    run_sqlcl('ADMIN', password, dbName, cmd)

    log.info('Running controller.demo.xml')
    cmd = f'lb update -emit_schema -changelog controller.demo.xml;'
    run_sqlcl('DEMO', password, dbName, cmd)


def lb_rollback_destroy(password, dbName):
    cmd = f'lb rollback -changelog controller.admin.xml -count 3;'
    run_sqlcl('ADMIN', password, dbName, cmd)


def lb_genobject_apex(password, dbName, appID):
    opt = '-expPubReports -expSavedReports -expIRNotif -expTranslations -expACLAssignments'
    cmd = f'lb genobject -type apex -applicationid {appID} {opt} -expOriginalIds -skipExportDate -dir apex/apps;'	
    run_sqlcl('DEMO', password, dbName, cmd)

# CI/CD Actions
def deploy(password, args):
    lb_update(password, args.dbName)

def export(password, args):
    lb_genobject_apex(password, args.dbName, args.appID)

def destroy(password, args):
    lb_rollback_destroy(password, args.dbName)

""" INIT
"""
if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='APEX CI/CD Utility')
    parent_parser = argparse.ArgumentParser(add_help=False)
    parent_parser.add_argument('--dbName', '-a', required=True, action='store', help='Database Name')
    parent_parser.add_argument('--debug',  '-d', required=False, action='store_true', help='Enable Debug')

    subparsers = parser.add_subparsers(help='Actions')
    # Deploy the Application
    deploy_parser = subparsers.add_parser('deploy', parents=[parent_parser], 
        help='Deploy the APEX Application'
    )
    deploy_parser.set_defaults(func=deploy,action='deploy')

    # Export the Application
    export_parser = subparsers.add_parser('export', parents=[parent_parser], 
        help='Export the APEX Application'
    )
    export_parser.add_argument('--appID', '-b', required=True, action='store', type = int,
        help='APEX Application ID', default='103')
    export_parser.set_defaults(func=export,action='export')

    # Destory the Application
    destroy_parser = subparsers.add_parser('destroy', parents=[parent_parser], 
        help='Destory the APEX Application '
    )
    destroy_parser.set_defaults(func=destroy,action='destroy')    

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
    f = open(".secret", "r")
    atp_password = f.readline().split()[-1]

    args.func(atp_password, args)
