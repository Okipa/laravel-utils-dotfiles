#!/usr/bin/env bash

# we get the current script directory
dumpProdToPreprodScriptDirectory="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# we load the scripting colors
source $(realpath ${dumpProdToPreprodScriptDirectory}/../helpers/loadScriptingColors.sh)

# we check if the current user has the sudo rights
source $(realpath ${dumpProdToPreprodScriptDirectory}/../helpers/requiresSudoRights.sh)

# we check if the current user has the sudo rights
source $(realpath ${dumpProdToPreprodScriptDirectory}/../helpers/requiresEnvironment.sh) preprod

# script begin
echo -e "${purple}▽ DUMPING PROD ON PREPROD : STARTING ▽${reset}\n"

echo -e "${gray}=================================================${reset}\n"

# we set the script required variables
setRequiredVariablesScript=${dumpProdToPreprodScriptDirectory}/../../.utils.custom/dump/prodToPreprod/setRequiredVariables.sh
if [ -f "${setRequiredVariablesScript}" ]; then
    echo -e "${green}✔${reset} ${gray}The .utils.custom/dump/prodToPreprod/setRequiredVariables.sh custom instructions script has been detected and executed.${reset}\n"
    source ${setRequiredVariablesScript}
else
    echo -e "${red}✗${reset} ${gray}No .utils.custom/dump/prodToPreprod/setRequiredVariables.sh script detected.${reset}\n"
fi
source $(realpath ${dumpProdToPreprodScriptDirectory}/../helpers/checkVariableIsDefined.sh) preprodUser
source $(realpath ${dumpProdToPreprodScriptDirectory}/../helpers/checkVariableIsDefined.sh) prodUser
source $(realpath ${dumpProdToPreprodScriptDirectory}/../helpers/checkVariableIsDefined.sh) currentPreprodProjectPath
source $(realpath ${dumpProdToPreprodScriptDirectory}/../helpers/checkVariableIsDefined.sh) currentProductionProjectPath

echo -e "${gray}=================================================${reset}\n"

# we set the maintenance mode
echo "${purple}▶${reset} Enabling maintenance mode ..."
echo "${purple}→ /usr/bin/php ${currentPreprodProjectPath}/current/artisan down${reset}"
/usr/bin/php ${currentPreprodProjectPath}/current/artisan down
echo -e "${green}✔${reset} Maintenance mode enabled.\n"

# we export the preprod .env file variables
source $(realpath ${dumpProdToPreprodScriptDirectory}/../helpers/exportEnvFileVariables.sh) ${currentPreprodProjectPath}/shared/.env

# we drop the preprod database
source $(realpath ${dumpProdToPreprodScriptDirectory}/../helpers/exportEnvFileVariables.sh)

# we export the production .env file variables
source $(realpath ${dumpProdToPreprodScriptDirectory}/../helpers/exportEnvFileVariables.sh) ${currentProductionProjectPath}/shared/.env

# we generate a production sql dump
generateSqlDumpScript=${dumpProdToPreprodScriptDirectory}/../../.utils.custom/dump/prodToPreprod/generateSqlDump.sh
if [ -f "${generateSqlDumpScript}" ]; then
    echo -e "${green}✔${reset} ${gray}The .utils.custom/dump/prodToPreprod/generateSqlDump.sh custom instructions script has been detected and executed.${reset}\n"
    source ${generateSqlDumpScript}
else
    echo -e "${red}✗${reset} ${gray}No .utils.custom/dump/prodToPreprod/generateSqlDump.sh script detected.${reset}\n"
fi

# we export the preprod .env file variables
source $(realpath ${dumpProdToPreprodScriptDirectory}/../helpers/exportEnvFileVariables.sh) ${currentPreprodProjectPath}/shared/.env

echo -e "${gray}=================================================${reset}\n"

# we import the sql production dump into preprod
echo "${purple}▶${reset} Importing the sql production dump into the ${purple}${DB_DATABASE}${reset} database ..."
echo "${purple}→ sudo -i -u ${preprodUser} psql "${DB_DATABASE}" < ${productionSqlDumpStoragePath}${reset}"
sudo -i -u ${preprodUser} psql "${DB_DATABASE}" < ${productionSqlDumpStoragePath}
echo -e "${green}✔${reset} Production sql dump successfully imported into the ${purple}${DB_DATABASE}${reset} database.\n"

echo -e "${gray}=================================================${reset}\n"

echo "${purple}▶${reset} Applying Laravel migration to preprod database ..."
echo "${purple}→ sudo -i -u ${preprodUser} /usr/bin/php ${currentPreprodProjectPath}/current/artisan migrate${reset}"
sudo -i -u ${preprodUser} /usr/bin/php ${currentPreprodProjectPath}/current/artisan migrate
echo -e "${green}✔${reset} Laravel migrations applied on the preprod database.\n"

echo -e "${gray}=================================================${reset}\n"

# we remove the prod dump
echo "${purple}▶${reset} Removing the the production dump ..."
echo "${purple}→ rm -f ${productionSqlDumpStoragePath}${reset}"
rm -f ${productionSqlDumpStoragePath}
echo -e "${green}✔${reset} Production dump removed.\n"

echo -e "${gray}=================================================${reset}\n"

# custom instructions execution
additionalInstructionsScript=${dumpProdToPreprodScriptDirectory}/../../.utils.custom/dump/prodToPreprod/additionalInstructions.sh
if [ -f "${additionalInstructionsScript}" ]; then
    echo -e "${green}✔${reset} ${gray}The .utils.custom/dump/prodToPreprod/additionalInstructions.sh custom instructions script has been detected and executed.${reset}\n"
    source ${additionalInstructionsScript}
else
    echo -e "${red}✗${reset} ${gray}No .utils.custom/dump/prodToPreprod/additionalInstructions.sh script detected.${reset}\n"
fi

echo -e "${gray}=================================================${reset}\n"

# we remove the maintenance mode
echo "${purple}▶${reset} Disabling maintenance mode ..."
echo "${purple}→ /usr/bin/php ${currentPreprodProjectPath}/current/artisan up${reset}"
/usr/bin/php ${currentPreprodProjectPath}/current/artisan up
echo -e "${green}✔${reset} Maintenance mode disabled.\n"

# script end
echo -e "${green}△ DUMPING PROD ON PREPROD : DONE △${reset}\n"
