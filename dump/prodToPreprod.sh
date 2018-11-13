#!/bin/bash

dumpProdToPreprodScriptDirectory=$(dirname "$(readlink -f ${BASH_SOURCE[0]})")

source $(realpath ${dumpProdToPreprodScriptDirectory}/../helpers/loadScriptingColors.sh)

source $(realpath ${dumpProdToPreprodScriptDirectory}/../helpers/requiresSudoRights.sh)

source $(realpath ${dumpProdToPreprodScriptDirectory}/../helpers/requiresEnvironment.sh) preprod

echo -e "${gray}=================================================${reset}\n"

echo -e "${purple}▽ DUMPING PROD ON PREPROD : STARTING ▽${reset}\n"

setRequiredVariablesScriptPath=${dumpProdToPreprodScriptDirectory}/../../.utils.custom/dump/prodToPreprod/setRequiredVariables.sh
source $(realpath ${dumpProdToPreprodScriptDirectory}/../helpers/checkFileExists.sh) ${setRequiredVariablesScriptPath}
source ${setRequiredVariablesScriptPath}
source $(realpath ${dumpProdToPreprodScriptDirectory}/../helpers/checkVariableIsDefined.sh) serverPreprodUser
source $(realpath ${dumpProdToPreprodScriptDirectory}/../helpers/checkVariableIsDefined.sh) serverPreprodGroup
source $(realpath ${dumpProdToPreprodScriptDirectory}/../helpers/checkVariableIsDefined.sh) serverPreprodProjectPath
source $(realpath ${dumpProdToPreprodScriptDirectory}/../helpers/checkVariableIsDefined.sh) serverProductionProjectPath
source $(realpath ${dumpProdToPreprodScriptDirectory}/../helpers/checkVariableIsDefined.sh) serverProductionSqlDumpStoragePath

echo -e "${gray}=================================================${reset}\n"

echo "${purple}▶${reset} Enabling maintenance mode ..."
echo "${purple}→ sudo -u ${serverPreprodUser} /usr/bin/php ${serverPreprodProjectPath}/current/artisan down${reset}"
sudo -u ${serverPreprodUser} /usr/bin/php ${serverPreprodProjectPath}/current/artisan down
echo -e "${green}✔${reset} Maintenance mode enabled.\n"

echo -e "${gray}=================================================${reset}\n"

echo "${purple}▶${reset} Creating the server ${serverProductionSqlDumpStoragePath} directory ..."
echo "${purple}→ mkdir -p ${serverProductionSqlDumpStoragePath}${reset}"
mkdir -p ${serverProductionSqlDumpStoragePath}
echo -e "${green}✔${reset} Server ${purple}${serverProductionSqlDumpStoragePath}${reset} directory available.\n"

source $(realpath ${dumpProdToPreprodScriptDirectory}/../helpers/exportEnvFileVariables.sh) ${serverPreprodProjectPath}/shared/.env
source $(realpath ${dumpProdToPreprodScriptDirectory}/../helpers/checkVariableIsDefined.sh) DB_CONNECTION
source $(realpath ${dumpProdToPreprodScriptDirectory}/../helpers/checkVariableIsDefined.sh) DB_HOST
source $(realpath ${dumpProdToPreprodScriptDirectory}/../helpers/checkVariableIsDefined.sh) DB_DATABASE
source $(realpath ${dumpProdToPreprodScriptDirectory}/../helpers/checkVariableIsDefined.sh) DB_USERNAME
source $(realpath ${dumpProdToPreprodScriptDirectory}/../helpers/checkVariableIsDefined.sh) DB_PASSWORD

dropDbTablesScriptPath=${dumpProdToPreprodScriptDirectory}/../../.utils.custom/dump/prodToPreprod/dropDbTables.sh
source $(realpath ${dumpProdToPreprodScriptDirectory}/../helpers/checkFileExists.sh) ${dropDbTablesScriptPath}
source ${dropDbTablesScriptPath}

source $(realpath ${dumpProdToPreprodScriptDirectory}/../helpers/exportEnvFileVariables.sh) ${serverProductionProjectPath}/shared/.env

generateSqlDumpScriptPath=${dumpProdToPreprodScriptDirectory}/../../.utils.custom/dump/prodToPreprod/generateProductionSqlDump.sh
source $(realpath ${dumpProdToPreprodScriptDirectory}/../helpers/checkFileExists.sh) ${generateSqlDumpScriptPath}
source ${generateSqlDumpScriptPath}

source $(realpath ${dumpProdToPreprodScriptDirectory}/../helpers/exportEnvFileVariables.sh) ${serverPreprodProjectPath}/shared/.env

importProductionSqlDumpScriptPath=${dumpProdToPreprodScriptDirectory}/../../.utils.custom/dump/prodToPreprod/importProductionSqlDump.sh
source $(realpath ${dumpProdToPreprodScriptDirectory}/../helpers/checkFileExists.sh) ${importProductionSqlDumpScriptPath}
source ${importProductionSqlDumpScriptPath}

echo -e "${gray}=================================================${reset}\n"

echo "${purple}▶${reset} Executing Laravel migration on ${purple}${DB_DATABASE}${reset} database ..."
echo "${purple}→ sudo -u ${serverPreprodUser} /usr/bin/php ${serverPreprodProjectPath}/current/artisan migrate${reset}"
sudo -u ${serverPreprodUser} /usr/bin/php ${serverPreprodProjectPath}/current/artisan migrate
echo -e "${green}✔${reset} Laravel migrations executed on ${purple}${DB_DATABASE}${reset} database.\n"

additionalInstructionsScriptPath=${dumpProdToPreprodScriptDirectory}/../../.utils.custom/dump/prodToPreprod/additionalInstructions.sh
source $(realpath ${dumpProdToPreprodScriptDirectory}/../helpers/checkFileExists.sh) ${additionalInstructionsScriptPath}
source ${additionalInstructionsScriptPath}

echo -e "${gray}=================================================${reset}\n"

echo "${purple}▶${reset} Disabling maintenance mode ..."
echo "${purple}→ sudo -u ${serverPreprodUser} /usr/bin/php ${serverPreprodProjectPath}/current/artisan up${reset}"
sudo -u ${serverPreprodUser} /usr/bin/php ${serverPreprodProjectPath}/current/artisan up
echo -e "${green}✔${reset} Maintenance mode disabled.\n"

echo -e "${gray}=================================================${reset}\n"

echo -e "${green}△ DUMPING PROD ON PREPROD : DONE △${reset}\n"
