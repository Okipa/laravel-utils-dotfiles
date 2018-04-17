#!/usr/bin/env bash

# example

# we get the current script directory
dumpImportFromProdGenerateServerProdSqlDumpScriptDirectory="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

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
sudo -u ${serverProdUser} source $(realpath ${dumpImportFromProdGenerateServerProdSqlDumpScriptDirectory}/../../../.utils/helpers/exportEnvFileVariables.sh)

# we execute a production pgsql dump
sudo -u ${serverProdUser} source $(realpath ${dumpImportFromProdGenerateServerProdSqlDumpScriptDirectory}/../../../.utils/database/generatePgsqlDump.sh) ${serverProductionSqlDumpStoragePath}
