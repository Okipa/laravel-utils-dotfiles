#!/bin/bash

# example custom script

echo -e "${gray}=================================================${reset}\n"

echo "${purple}▶${reset} Setting up script variables ..."
serverPreprodUser="[server_preprod_user]"
serverPreprodGroup="[server_preprod_group]"
serverPreprodProjectPath="[/path/to/preprod/project/directory]"
serverProductionProjectPath="[/path/to/production/project/directory]"
serverProductionSqlDumpStoragePath="/tmp/prodToPreprodDump"
echo -e "${green}✔${reset} Script variables defined.\n"
