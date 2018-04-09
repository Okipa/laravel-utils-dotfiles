#!/usr/bin/env bash

# we get the current script directory
dumpImportScriptDirectory="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# we load the scripting colors
source $(realpath ${dumpImportScriptDirectory}/../helpers/loadScriptingColors.sh)

# we export the .env file variables
source $(realpath ${dumpImportScriptDirectory}/../helpers/exportEnvFileVariables.sh) --

# we check if the current environment is local
source $(realpath ${dumpImportScriptDirectory}/../helpers/requiresEnvironment.sh) local

# script begin
echo -e "${purple}▽ DUMP IMPORT : STARTING ▽${reset}\n"

echo -e "${gray}=================================================${reset}\n"

# we set the script required variables
setRequiredVariablesScript=${dumpImportScriptDirectory}/../../.utils.custom/dump/importFromProd/setRequiredVariables.sh
if [ -f "${setRequiredVariablesScript}" ]; then
    echo -e "${green}✔${reset} ${gray}The .utils.custom/dump/importFromProd/setRequiredVariables.sh custom instructions script has been detected and executed.${reset}\n"
    source ${setRequiredVariablesScript}
else
    echo -e "${red}✗${reset} ${gray}No .utils.custom/dump/importFromProd/setRequiredVariables.sh script detected.${reset}\n"
fi
source $(realpath ${dumpImportScriptDirectory}/../helpers/checkVariableIsDefined.sh) prodUser
source $(realpath ${dumpImportScriptDirectory}/../helpers/checkVariableIsDefined.sh) serverHost
source $(realpath ${dumpImportScriptDirectory}/../helpers/checkVariableIsDefined.sh) productionProjectPath

echo -e "${gray}=================================================${reset}\n"

# we create the database/seeds/dump directory
echo "${purple}▶${reset} Creating the database/seeds/dump directory locally ..."
echo "${purple}→ mkdir -p database/seeds/dump${reset}"
mkdir -p database/seeds/dump
echo -e "${green}✔${reset} Local database/seeds/dump directory available.\n"

# we execute the dump archive generation on the production server
echo "${purple}→ ${reset}"
ssh ${prodUser}@${serverHost} ${productionProjectPath}/current/.utils.custom/dump/importFromProd/generateServerProdDumpArchive.sh

# we execute a production dump on the server
DumpImportFromProdgenerateServerProdDumpArchiveScript=${dumpImportScriptDirectory}/../../.utils.custom/dump/importFromProd/generateServerProdDumpArchive.sh
if [ -f "${DumpImportFromProdgenerateServerProdDumpArchiveScript}" ]; then
    echo -e "${green}✔${reset} ${gray}The .utils.custom/dump/importFromProd/generateServerProdDumpArchive.sh custom instructions script has been detected and executed.${reset}\n"
    source ${DumpImportFromProdgenerateServerProdDumpArchiveScript}
else
    echo -e "${red}✗${reset} ${gray}No .utils.custom/dump/importFromProd/generateServerProdDumpArchive.sh script detected.${reset}\n"
fi

# script end
echo -e "${green}△ DUMP IMPORT : DONE △${reset}\n"
