#!/bin/bash

# example

# we get the current script directory
dumpImportFromServerGenerateServerSqlDumpScriptDirectory=$(dirname "$(readlink -f ${BASH_SOURCE[0]})")

# we set the required variables
source ${dumpImportFromServerGenerateServerSqlDumpScriptDirectory}/setRequiredVariables.sh
source $(realpath ${dumpImportFromServerGenerateServerSqlDumpScriptDirectory}/../../../.utils/helpers/checkVariableIsDefined.sh) serverProjectPath
source $(realpath ${dumpImportFromServerGenerateServerSqlDumpScriptDirectory}/../../../.utils/helpers/checkVariableIsDefined.sh) serverSqlDumpStoragePath

echo -e "${gray}=================================================${reset}\n"

# we create the production dump storage directory
echo "${purple}▶${reset} Creating server ${serverSqlDumpStoragePath} directory ..."
echo "${purple}→ mkdir -p ${serverSqlDumpStoragePath}${reset}"
mkdir -p ${serverSqlDumpStoragePath}
echo -e "${green}✔${reset} Server ${purple}${serverSqlDumpStoragePath}${reset} directory available.\n"

# we export the .env file variables
source $(realpath ${dumpImportFromServerGenerateServerSqlDumpScriptDirectory}/../../../.utils/helpers/exportEnvFileVariables.sh)

# we remove the previous dump file to avoid errors
echo "${purple}▶${reset} Removing previous ${serverSqlDumpStoragePath}/dump.sql file ..."
echo "${purple}→ rm -f ${serverSqlDumpStoragePath}/dump.sql${reset}"
rm -f ${serverSqlDumpStoragePath}/dump.sql
echo -e "${green}✔${reset} Previous ${serverSqlDumpStoragePath}/dump.sql file removed.\n"

# we execute a production pgsql dump
source $(realpath ${dumpImportFromServerGenerateServerSqlDumpScriptDirectory}/../../../.utils/database/generateMysqlDump.sh) ${serverSqlDumpStoragePath}/dump.sql
