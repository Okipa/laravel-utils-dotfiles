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
source $(realpath ${dumpImportScriptDirectory}/../helpers/checkVariableIsDefined.sh) serverProdUser
source $(realpath ${dumpImportScriptDirectory}/../helpers/checkVariableIsDefined.sh) serverHost
source $(realpath ${dumpImportScriptDirectory}/../helpers/checkVariableIsDefined.sh) serverProductionProjectPath
source $(realpath ${dumpImportScriptDirectory}/../helpers/checkVariableIsDefined.sh) serverProductionSqlDumpStoragePath
source $(realpath ${dumpImportScriptDirectory}/../helpers/checkVariableIsDefined.sh) localProductionDumpStoragePath

echo -e "${gray}=================================================${reset}\n"

# we create the database/seeds/dump directory
echo "${purple}▶${reset} Creating the database/seeds/dump directory locally ..."
echo "${purple}→ mkdir -p ${localProductionDumpStoragePath}${reset}"
mkdir -p database/seeds/dump
echo -e "${green}✔${reset} Local database/seeds/dump directory available.\n"

echo -e "${gray}=================================================${reset}\n"

# we execute the dump archive generation on the production server
echo "${purple}▶${reset} Generating the server production dump ..."
echo "${purple}→ ssh ${serverProdUser}@${serverHost} ${serverProductionProjectPath}/current/.utils.custom/dump/importFromProd/generateServerProdSqlDump.sh${reset}"
ssh ${serverProdUser}@${serverHost} ${serverProductionProjectPath}/current/.utils.custom/dump/importFromProd/generateServerProdSqlDump.sh
echo -e "${green}✔${reset} Server production dump generated.\n"

echo -e "${gray}=================================================${reset}\n"

# we import the production sql dump
echo "${purple}▶${reset} Importing the production sql dump ..."
echo "${purple}→ rsync -Prz --info=progress2 ${serverProdUser}@${serverHost}:${serverProductionSqlDumpStoragePath} ${localProductionDumpStoragePath}${reset}"
rsync -Prz --info=progress2 ${serverProdUser}@${serverHost}:${serverProductionSqlDumpStoragePath} ${localProductionDumpStoragePath}
echo -e "${green}✔${reset} Production sql dump imported.\n"

echo -e "${gray}=================================================${reset}\n"

# we execute the additional instructions
dumpImportFromProdAdditionalInstructionsScript=${dumpProdToPreprodScriptDirectory}/../../.utils.custom/dump/importFromProd/additionalInstructions.sh
if [ -f "${dumpImportFromProdAdditionalInstructionsScript}" ]; then
    echo -e "${green}✔${reset} ${gray}The .utils.custom/dump/importFromProd/additionalInstructions.sh custom instructions script has been detected and executed.${reset}\n"
    source ${dumpImportFromProdAdditionalInstructionsScript}
else
    echo -e "${red}✗${reset} ${gray}No .utils.custom/dump/importFromProd/additionalInstructions.sh script detected.${reset}\n"
fi

echo -e "${gray}=================================================${reset}\n"

# script end
echo -e "${green}△ DUMP IMPORT : DONE △${reset}\n"
