#!/bin/bash

# we get the current script directory
dumpImportScriptDirectory=$(dirname "$(readlink -f ${BASH_SOURCE[0]})")

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
setRequiredVariablesScript=${dumpImportScriptDirectory}/../../.utils.custom/dump/importFromServer/setRequiredVariables.sh
if [ -f "${setRequiredVariablesScript}" ]; then
    echo -e "${green}✔${reset} ${gray}The .utils.custom/dump/importFromServer/setRequiredVariables.sh custom instructions script has been detected and executed.${reset}\n"
    source ${setRequiredVariablesScript}
else
    echo -e "${red}✗${reset} ${gray}No .utils.custom/dump/importFromServer/setRequiredVariables.sh script detected.${reset}\n"
fi
source $(realpath ${dumpImportScriptDirectory}/../helpers/checkVariableIsDefined.sh) sshConnexionUser
source $(realpath ${dumpImportScriptDirectory}/../helpers/checkVariableIsDefined.sh) serverUser
source $(realpath ${dumpImportScriptDirectory}/../helpers/checkVariableIsDefined.sh) serverUserGroup
source $(realpath ${dumpImportScriptDirectory}/../helpers/checkVariableIsDefined.sh) serverHost
source $(realpath ${dumpImportScriptDirectory}/../helpers/checkVariableIsDefined.sh) serverProjectPath
source $(realpath ${dumpImportScriptDirectory}/../helpers/checkVariableIsDefined.sh) serverSqlDumpStoragePath
source $(realpath ${dumpImportScriptDirectory}/../helpers/checkVariableIsDefined.sh) localDumpStoragePath

echo -e "${gray}=================================================${reset}\n"

# we create the production dump storage directory
echo "${purple}▶${reset} Creating the ${localDumpStoragePath} directory locally ..."
echo "${purple}→ mkdir -p ${localDumpStoragePath}${reset}"
mkdir -p ${localDumpStoragePath}
echo -e "${green}✔${reset} Local ${purple}${localDumpStoragePath}${reset} directory available.\n"

echo -e "${gray}=================================================${reset}\n"

# we execute the dump archive generation on the production server
echo "${purple}▶${reset} Generating the server production dump ..."
echo "${purple}→ ssh ${serverUser}@${serverHost} ${serverProjectPath}/current/.utils.custom/dump/importFromServer/generateServerProdSqlDump.sh${reset}"
ssh ${sshConnexionUser}@${serverHost} ${serverProjectPath}/current/.utils.custom/dump/importFromServer/generateServerProdSqlDump.sh
echo -e "${green}✔${reset} Server production dump generated.\n"

echo -e "${gray}=================================================${reset}\n"

# we import the production sql dump
echo "${purple}▶${reset} Importing the production sql dump ..."
echo "${purple}→ rsync -Prz --info=progress2 ${serverUser}@${serverHost}:${serverSqlDumpStoragePath}/ ${localDumpStoragePath}${reset}"
rsync -Prz --info=progress2 ${serverUser}@${serverHost}:${serverSqlDumpStoragePath}/ ${localDumpStoragePath}
echo -e "${green}✔${reset} Production sql dump imported.\n"

echo -e "${gray}=================================================${reset}\n"

# we execute the additional instructions
dumpimportFromServerAdditionalInstructionsScript=${dumpImportScriptDirectory}/../../.utils.custom/dump/importFromServer/additionalInstructions.sh
if [ -f "${dumpimportFromServerAdditionalInstructionsScript}" ]; then
    echo -e "${green}✔${reset} ${gray}The .utils.custom/dump/importFromServer/additionalInstructions.sh custom instructions script has been detected and executed.${reset}\n"
    source ${dumpimportFromServerAdditionalInstructionsScript}
else
    echo -e "${red}✗${reset} ${gray}No .utils.custom/dump/importFromServer/additionalInstructions.sh script detected.${reset}\n"
fi

echo -e "${gray}=================================================${reset}\n"

# script end
echo -e "${green}△ DUMP IMPORT : DONE △${reset}\n"
