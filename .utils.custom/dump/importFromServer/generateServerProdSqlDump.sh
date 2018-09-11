#!/bin/bash

# example

# we get the current script directory
dumpImportFromServerGenerateServerProdSqlDumpScriptDirectory=$(dirname "$(readlink -f ${BASH_SOURCE[0]})")

# we set the required variables
source ${dumpImportFromServerGenerateServerProdSqlDumpScriptDirectory}/setRequiredVariables.sh
source $(realpath ${dumpImportFromServerGenerateServerProdSqlDumpScriptDirectory}/../../../.utils/helpers/checkVariableIsDefined.sh) serverUser
source $(realpath ${dumpImportFromServerGenerateServerProdSqlDumpScriptDirectory}/../../../.utils/helpers/checkVariableIsDefined.sh) serverUserGroup
source $(realpath ${dumpImportFromServerGenerateServerProdSqlDumpScriptDirectory}/../../../.utils/helpers/checkVariableIsDefined.sh) serverProjectPath
source $(realpath ${dumpImportFromServerGenerateServerProdSqlDumpScriptDirectory}/../../../.utils/helpers/checkVariableIsDefined.sh) serverSqlDumpStoragePath

echo -e "${gray}=================================================${reset}\n"

# we create the production dump storage directory
echo "${purple}▶${reset} Creating server ${serverSqlDumpStoragePath} directory ..."
echo "${purple}→ sudo -u ${serverUser} mkdir -p ${serverSqlDumpStoragePath}${reset}"
sudu -u ${serverUser} mkdir -p ${serverSqlDumpStoragePath}
echo -e "${green}✔${reset} Server ${purple}${serverSqlDumpStoragePath}${reset} directory available.\n"

# we export the .env file variables
source $(realpath ${dumpImportFromServerGenerateServerProdSqlDumpScriptDirectory}/../../../.utils/helpers/exportEnvFileVariables.sh)

# we execute a production pgsql dump
source $(realpath ${dumpImportFromServerGenerateServerProdSqlDumpScriptDirectory}/../../../.utils/database/generateMysqlDump.sh) ${serverSqlDumpStoragePath}/dump.sql

echo -e "${gray}=================================================${reset}\n"

# we change the sql dump owner
echo "${purple}▶${reset} Changing the ${serverSqlDumpStoragePath}/dump.sql owner ..."
echo "${purple}→ sudo chown ${serverUser}:${serverUserGroup} ${serverSqlDumpStoragePath}/dump.sql${reset}"
sudo chown ${serverUser}:${serverUserGroup} ${serverSqlDumpStoragePath}/dump.sql
echo -e "${green}✔${reset} ${serverSqlDumpStoragePath}/dump.sql owner changed to ${purple}${serverUser}:${serverUserGroup}${reset}.\n"
