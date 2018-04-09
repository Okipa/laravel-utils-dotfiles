#!/usr/bin/env bash

# example

# we get the current script directory
dumpImportFromProdGenerateServerProdDumpArchiveScriptDirectory="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo -e "${gray}=================================================${reset}\n"

# we set the required variables
source ${dumpImportFromProdGenerateServerProdDumpArchiveScriptDirectory}/setRequiredVariables.sh
source $(realpath ${dumpImportFromProdGenerateServerProdDumpArchiveScriptDirectory}/../../../helpers/checkVariableIsDefined.sh) prodUser
source $(realpath ${dumpImportFromProdGenerateServerProdDumpArchiveScriptDirectory}/../../../helpers/checkVariableIsDefined.sh) serverHost
source $(realpath ${dumpImportFromProdGenerateServerProdDumpArchiveScriptDirectory}/../../../helpers/checkVariableIsDefined.sh) productionProjectPath
source $(realpath ${dumpImportFromProdGenerateServerProdDumpArchiveScriptDirectory}/../../../helpers/checkVariableIsDefined.sh) productionDumpStoragePath
source $(realpath ${dumpImportFromProdGenerateServerProdDumpArchiveScriptDirectory}/../../../helpers/checkVariableIsDefined.sh) productionDumpArchivePath

echo -e "${gray}=================================================${reset}\n"

# we export the .env file variables
source $(realpath ${dumpImportFromProdGenerateServerProdDumpArchiveScriptDirectory}/../../../helpers/exportEnvFileVariables.sh)

# we execute a production pgsql dump
source $(realpath ${dumpImportFromProdGenerateServerProdDumpArchiveScriptDirectory}/../../../database/generatePgsqlDump.sh) ${productionDumpStoragePath}/nsn_dump.sql

echo -e "${gray}=================================================${reset}\n"

# we sync the production public/files directory with the dump files directory
echo "${purple}▶${reset} Syncing the production public/files directory with the dump files directory ..."
echo "${purple}→ rsync ${productionProjectPath}/shared/public/files/ ${productionDumpStoragePath}/files${reset}"
rsync ${productionProjectPath}/shared/public/files/ ${productionDumpStoragePath}/files
echo -e "${green}✔${reset} Production public/files directory synced with the dump files directory.\n"

# we generate an archive from the production dump folder
echo "${purple}▶${reset} Syncing the production public/files directory with the dump files directory ..."
echo "${purple}→ rsync ${productionProjectPath}/shared/public/files/ ${productionDumpStoragePath}/files${reset}"
tar czvf ${productionDumpArchivePath} ${productionDumpStoragePath} 
echo -e "${green}✔${reset} Production public/files directory synced with the dump files directory.\n"
