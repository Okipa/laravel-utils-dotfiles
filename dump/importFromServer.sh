#!/bin/bash

dumpImportScriptDirectory=$(dirname "$(readlink -f ${BASH_SOURCE[0]})")

source $(realpath ${dumpImportScriptDirectory}/../helpers/loadScriptingColors.sh)

source $(realpath ${dumpImportScriptDirectory}/../helpers/exportEnvFileVariables.sh) --

source $(realpath ${dumpImportScriptDirectory}/../helpers/requiresEnvironment.sh) local

echo -e "${gray}=================================================${reset}\n"

echo -e "${purple}▽ DUMP IMPORT : STARTING ▽${reset}\n"

setRequiredVariablesScriptPath=${dumpImportScriptDirectory}/../../.utils.custom/dump/importFromServer/setRequiredVariables.sh
source $(realpath ${dumpImportScriptDirectory}/../helpers/checkFileExists.sh) ${setRequiredVariablesScriptPath}
source ${setRequiredVariablesScriptPath}
source $(realpath ${dumpImportScriptDirectory}/../helpers/checkVariableIsDefined.sh) sshConnexionUser
source $(realpath ${dumpImportScriptDirectory}/../helpers/checkVariableIsDefined.sh) serverHost
source $(realpath ${dumpImportScriptDirectory}/../helpers/checkVariableIsDefined.sh) serverProjectPath
source $(realpath ${dumpImportScriptDirectory}/../helpers/checkVariableIsDefined.sh) serverSqlDumpStoragePath
source $(realpath ${dumpImportScriptDirectory}/../helpers/checkVariableIsDefined.sh) localDumpStoragePath

echo -e "${gray}=================================================${reset}\n"

echo "${purple}▶${reset} Creating local ${localDumpStoragePath} directory ..."
echo "${purple}→ mkdir -p ${localDumpStoragePath}${reset}"
mkdir -p ${localDumpStoragePath}
echo -e "${green}✔${reset} Local ${purple}${localDumpStoragePath}${reset} directory available.\n"

echo -e "${gray}=================================================${reset}\n"

echo "${purple}→ ssh ${sshConnexionUser}@${serverHost} ${serverProjectPath}/current/.utils/helpers/checkFileExists.sh ${serverProjectPath}/current/.utils.custom/dump/importFromServer/generateServerSqlDump.sh${reset}"
ssh ${sshConnexionUser}@${serverHost} ${serverProjectPath}/current/.utils/helpers/checkFileExists.sh ${serverProjectPath}/current/.utils.custom/dump/importFromServer/generateServerSqlDump.sh
echo "${purple}→ ssh ${sshConnexionUser}@${serverHost} ${serverProjectPath}/current/.utils.custom/dump/importFromServer/generateServerSqlDump.sh${reset}"
ssh ${sshConnexionUser}@${serverHost} ${serverProjectPath}/current/.utils.custom/dump/importFromServer/generateServerSqlDump.sh

echo -e "${gray}=================================================${reset}\n"

echo "${purple}▶${reset} Importing the production sql dump ..."
echo "${purple}→ rsync -Prz --info=progress2 ${sshConnexionUser}@${serverHost}:${serverSqlDumpStoragePath}/ ${localDumpStoragePath}${reset}"
rsync -Prz --info=progress2 ${sshConnexionUser}@${serverHost}:${serverSqlDumpStoragePath}/ ${localDumpStoragePath}
echo -e "${green}✔${reset} Production sql dump imported.\n"

dumpImportFromServerAdditionalInstructionsScriptPath=${dumpImportScriptDirectory}/../../.utils.custom/dump/importFromServer/additionalInstructions.sh
source $(realpath ${dumpImportScriptDirectory}/../helpers/checkFileExists.sh) ${dumpImportFromServerAdditionalInstructionsScriptPath}
source ${dumpImportFromServerAdditionalInstructionsScriptPath}

echo -e "${gray}=================================================${reset}\n"

echo -e "${green}△ DUMP IMPORT : DONE △${reset}\n"
