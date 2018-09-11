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

# we execute a production pgsql dump
source $(realpath ${dumpImportFromServerGenerateServerSqlDumpScriptDirectory}/../../../.utils/database/generateMysqlDump.sh) ${serverSqlDumpStoragePath}/dump.sql
