#!/bin/bash

# example custom script

echo -e "${gray}=================================================${reset}\n"

echo "${purple}▶${reset} Setting up script variables ..."
sshConnexionUser="[ssh_connexion_user]"
serverHost="[server_host_or_ip]"
serverProjectPath="[/path/to/project/directory/on/server]"
serverSqlDumpStoragePath="/tmp/dumpImportFromServer"
localDumpStoragePath="database/seeds/dump"
echo -e "${green}✔${reset} Script variables defined.\n"
