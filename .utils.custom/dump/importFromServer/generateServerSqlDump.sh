#!/bin/bash

# example custom script

dumpImportFromServerGenerateServerSqlDumpScriptDirectory=$(dirname "$(readlink -f ${BASH_SOURCE[0]})")

source ${dumpImportFromServerGenerateServerSqlDumpScriptDirectory}/setRequiredVariables.sh
source $(realpath ${dumpImportFromServerGenerateServerSqlDumpScriptDirectory}/../../../.utils/helpers/checkVariableIsDefined.sh) serverProjectPath
source $(realpath ${dumpImportFromServerGenerateServerSqlDumpScriptDirectory}/../../../.utils/helpers/checkVariableIsDefined.sh) serverSqlDumpStoragePath

echo -e "${gray}=================================================${reset}\n"

echo "${purple}▶${reset} Creating server ${serverSqlDumpStoragePath} directory ..."
echo "${purple}→ mkdir -p ${serverSqlDumpStoragePath}${reset}"
mkdir -p ${serverSqlDumpStoragePath}
echo -e "${green}✔${reset} Server ${purple}${serverSqlDumpStoragePath}${reset} directory available.\n"

source $(realpath ${dumpImportFromServerGenerateServerSqlDumpScriptDirectory}/../../../.utils/helpers/exportEnvFileVariables.sh)

echo -e "${gray}=================================================${reset}\n"

echo "${purple}▶${reset} Removing previous ${serverSqlDumpStoragePath}/dump.sql file ..."
echo "${purple}→ rm -f ${serverSqlDumpStoragePath}/dump.sql${reset}"
rm -f ${serverSqlDumpStoragePath}/dump.sql
echo -e "${green}✔${reset} Previous ${serverSqlDumpStoragePath}/dump.sql file removed.\n"

source $(realpath ${dumpImportFromServerGenerateServerSqlDumpScriptDirectory}/../../../.utils/database/generateMysqlDump.sh) ${serverSqlDumpStoragePath}/dump.sql
#source $(realpath ${dumpImportFromServerGenerateServerSqlDumpScriptDirectory}/../../../.utils/database/generatePgsqlDump.sh) ${serverSqlDumpStoragePath}/dump.sql
