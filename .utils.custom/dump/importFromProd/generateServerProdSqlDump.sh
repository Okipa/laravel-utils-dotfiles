#!/bin/bash

# example

# we get the current script directory
dumpImportFromProdGenerateServerProdSqlDumpScriptDirectory=$(dirname "$(readlink -f ${BASH_SOURCE[0]})")

echo -e "${gray}=================================================${reset}\n"

# we set the required variables
source ${dumpImportFromProdGenerateServerProdSqlDumpScriptDirectory}/setRequiredVariables.sh
source $(realpath ${dumpImportFromProdGenerateServerProdSqlDumpScriptDirectory}/../../../.utils/helpers/checkVariableIsDefined.sh) serverProdUser
source $(realpath ${dumpImportFromProdGenerateServerProdSqlDumpScriptDirectory}/../../../.utils/helpers/checkVariableIsDefined.sh) serverProductionProjectPath
source $(realpath ${dumpImportFromProdGenerateServerProdSqlDumpScriptDirectory}/../../../.utils/helpers/checkVariableIsDefined.sh) serverProductionSqlDumpStoragePath

echo -e "${gray}=================================================${reset}\n"

# we create the production dump storage directory
echo "${purple}▶${reset} Creating server ${serverProductionSqlDumpStoragePath} directory ..."
echo "${purple}→ sudo -u ${serverProdUser} mkdir -p ${serverProductionSqlDumpStoragePath}${reset}"
sudo -u ${serverProdUser} mkdir -p ${serverProductionSqlDumpStoragePath}
echo -e "${green}✔${reset} Server ${serverProductionSqlDumpStoragePath} directory available.\n"

echo -e "${gray}=================================================${reset}\n"

# we export the .env file variables
source $(realpath ${dumpImportFromProdGenerateServerProdSqlDumpScriptDirectory}/../../../.utils/helpers/exportEnvFileVariables.sh)

# we execute a production pgsql dump
source $(realpath ${dumpImportFromProdGenerateServerProdSqlDumpScriptDirectory}/../../../.utils/database/generatePgsqlDump.sh) ${serverProductionSqlDumpStoragePath}/nsn_dump.sql

# we export the production server .env file variables and execute a production pgsql dump with the server production user
su ${serverProdUser} -c "source $(realpath ${dumpImportFromProdGenerateServerProdSqlDumpScriptDirectory}/../../../.utils/helpers/exportEnvFileVariables.sh) --; source $(realpath ${dumpImportFromProdGenerateServerProdSqlDumpScriptDirectory}/../../../.utils/database/generatePgsqlDump.sh) ${serverProductionSqlDumpStoragePath}/nsn_dump.sql"
