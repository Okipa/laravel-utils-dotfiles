#!/bin/bash

# example

# we get the current script directory
dumpImportFromProdGenerateServerProdSqlDumpScriptDirectory=$(dirname "$(readlink -f ${BASH_SOURCE[0]})")

# we set the required variables
source ${dumpImportFromProdGenerateServerProdSqlDumpScriptDirectory}/setRequiredVariables.sh
source $(realpath ${dumpImportFromProdGenerateServerProdSqlDumpScriptDirectory}/../../../.utils/helpers/checkVariableIsDefined.sh) serverProdUser
source $(realpath ${dumpImportFromProdGenerateServerProdSqlDumpScriptDirectory}/../../../.utils/helpers/checkVariableIsDefined.sh) serverProdGroup
source $(realpath ${dumpImportFromProdGenerateServerProdSqlDumpScriptDirectory}/../../../.utils/helpers/checkVariableIsDefined.sh) serverProductionProjectPath
source $(realpath ${dumpImportFromProdGenerateServerProdSqlDumpScriptDirectory}/../../../.utils/helpers/checkVariableIsDefined.sh) serverProductionSqlDumpStoragePath

echo -e "${gray}=================================================${reset}\n"

# we create the production dump storage directory
echo "${purple}▶${reset} Creating server ${serverProductionSqlDumpStoragePath} directory ..."
echo "${purple}→ su ${serverProdUser} -c \"mkdir -p ${serverProductionSqlDumpStoragePath}\"${reset}"
su ${serverProdUser} -c "mkdir -p ${serverProductionSqlDumpStoragePath}"
echo -e "${green}✔${reset} Server ${purple}${serverProductionSqlDumpStoragePath}${reset} directory available.\n"

# we export the .env file variables
source $(realpath ${dumpImportFromProdGenerateServerProdSqlDumpScriptDirectory}/../../../.utils/helpers/exportEnvFileVariables.sh)

# we execute a production pgsql dump
source $(realpath ${dumpImportFromProdGenerateServerProdSqlDumpScriptDirectory}/../../../.utils/database/generatePgsqlDump.sh) ${serverProductionSqlDumpStoragePath}/dump.sql

echo -e "${gray}=================================================${reset}\n"

# we change the sql dump owner
echo "${purple}▶${reset} Changing the ${serverProductionSqlDumpStoragePath}/nsn_dump.sql owner ..."
echo "${purple}→ chown ${serverProdUser}:${serverProdGroup} ${serverProductionSqlDumpStoragePath}/nsn_dump.sql${reset}"
chown ${serverProdUser}:${serverProdGroup} ${serverProductionSqlDumpStoragePath}/nsn_dump.sql
echo -e "${green}✔${reset} ${serverProductionSqlDumpStoragePath}/nsn_dump.sql owner changed to ${purple}${serverProdUser}:${serverProdGroup}${reset}.\n"
