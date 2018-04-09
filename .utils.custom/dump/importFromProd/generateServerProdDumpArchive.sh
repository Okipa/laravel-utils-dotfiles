#!/usr/bin/env bash

# example

# we get the current script directory
dumpImportFromProdGenerateServerProdDumpArchiveScriptDirectory="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo -e "${gray}=================================================${reset}\n"

# we set the required variables
source ${dumpImportFromProdGenerateServerProdDumpArchiveScriptDirectory}/setRequiredVariables.sh
source $(realpath ${dumpImportFromProdGenerateServerProdDumpArchiveScriptDirectory}/../../../.utils/helpers/checkVariableIsDefined.sh) prodUser
source $(realpath ${dumpImportFromProdGenerateServerProdDumpArchiveScriptDirectory}/../../../.utils/helpers/checkVariableIsDefined.sh) serverHost
source $(realpath ${dumpImportFromProdGenerateServerProdDumpArchiveScriptDirectory}/../../../.utils/helpers/checkVariableIsDefined.sh) productionProjectPath
source $(realpath ${dumpImportFromProdGenerateServerProdDumpArchiveScriptDirectory}/../../../.utils/helpers/checkVariableIsDefined.sh) productionDumpStorageDirectory
source $(realpath ${dumpImportFromProdGenerateServerProdDumpArchiveScriptDirectory}/../../../.utils/helpers/checkVariableIsDefined.sh) productionDumpArchivePath

echo -e "${gray}=================================================${reset}\n"

# we create the production dump storage directory
echo "${purple}▶${reset} Creating server ${productionDumpStorageDirectory} directory ..."
echo "${purple}→ mkdir -p ${productionDumpStorageDirectory}${reset}"
mkdir -p ${productionDumpStorageDirectory}
echo -e "${green}✔${reset} Server ${productionDumpStorageDirectory} directory available.\n"

echo -e "${gray}=================================================${reset}\n"

# we export the .env file variables
source $(realpath ${dumpImportFromProdGenerateServerProdDumpArchiveScriptDirectory}/../../../.utils/helpers/exportEnvFileVariables.sh)

# we execute a production pgsql dump
source $(realpath ${dumpImportFromProdGenerateServerProdDumpArchiveScriptDirectory}/../../../.utils/database/generatePgsqlDump.sh) ${productionDumpStorageDirectory}/nsn_dump.sql

echo -e "${gray}=================================================${reset}\n"

# we sync the production public/files directory with the dump files directory
echo "${purple}▶${reset} Syncing the production public/files directory with the dump files directory ..."
echo "${purple}→ rsync ${productionProjectPath}/shared/public/files/ ${productionDumpStorageDirectory}/files${reset}"
rsync ${productionProjectPath}/shared/public/files/ ${productionDumpStorageDirectory}/files
echo -e "${green}✔${reset} Production public/files directory synced with the dump files directory.\n"

# we generate an archive from the production dump folder
echo "${purple}▶${reset} Syncing the production public/files directory with the dump files directory ..."
echo "${purple}→ rsync ${productionProjectPath}/shared/public/files/ ${productionDumpStorageDirectory}/files${reset}"
tar czvf ${productionDumpArchivePath} ${productionDumpStorageDirectory} 
echo -e "${green}✔${reset} Production public/files directory synced with the dump files directory.\n"
