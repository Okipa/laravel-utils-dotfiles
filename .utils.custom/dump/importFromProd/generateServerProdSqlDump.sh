#!/bin/bash

# example

# we get the current script directory
dumpImportFromProdGenerateServerProdSqlDumpScriptDirectory=$(dirname "$(readlink -f ${BASH_SOURCE[0]})")

# we set the required variables
source ${dumpImportFromProdGenerateServerProdSqlDumpScriptDirectory}/setRequiredVariables.sh
source $(realpath ${dumpImportFromProdGenerateServerProdSqlDumpScriptDirectory}/../../../.utils/helpers/checkVariableIsDefined.sh) serverProductionUser
source $(realpath ${dumpImportFromProdGenerateServerProdSqlDumpScriptDirectory}/../../../.utils/helpers/checkVariableIsDefined.sh) serverProductionGroup
source $(realpath ${dumpImportFromProdGenerateServerProdSqlDumpScriptDirectory}/../../../.utils/helpers/checkVariableIsDefined.sh) serverProductionProjectPath
source $(realpath ${dumpImportFromProdGenerateServerProdSqlDumpScriptDirectory}/../../../.utils/helpers/checkVariableIsDefined.sh) serverProductionSqlDumpStoragePath

echo -e "${gray}=================================================${reset}\n"

# we create the production dump storage directory
echo "${purple}▶${reset} Creating server ${serverProductionSqlDumpStoragePath} directory ..."
echo "${purple}→ sudo -u ${serverProductionUser} mkdir -p ${serverProductionSqlDumpStoragePath}${reset}"
sudu -u ${serverProductionUser} mkdir -p ${serverProductionSqlDumpStoragePath}
echo -e "${green}✔${reset} Server ${purple}${serverProductionSqlDumpStoragePath}${reset} directory available.\n"

# we export the .env file variables
source $(realpath ${dumpImportFromProdGenerateServerProdSqlDumpScriptDirectory}/../../../.utils/helpers/exportEnvFileVariables.sh)

# we execute a production pgsql dump
source $(realpath ${dumpImportFromProdGenerateServerProdSqlDumpScriptDirectory}/../../../.utils/database/generateMysqlDump.sh) ${serverProductionSqlDumpStoragePath}/dump.sql

echo -e "${gray}=================================================${reset}\n"

# we change the sql dump owner
echo "${purple}▶${reset} Changing the ${serverProductionSqlDumpStoragePath}/dump.sql owner ..."
echo "${purple}→ sudo chown ${serverProductionUser}:${serverProductionGroup} ${serverProductionSqlDumpStoragePath}/dump.sql${reset}"
sudo chown ${serverProductionUser}:${serverProductionGroup} ${serverProductionSqlDumpStoragePath}/dump.sql
echo -e "${green}✔${reset} ${serverProductionSqlDumpStoragePath}/dump.sql owner changed to ${purple}${serverProductionUser}:${serverProductionGroup}${reset}.\n"
