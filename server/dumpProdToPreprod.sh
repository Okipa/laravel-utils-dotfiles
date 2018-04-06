#!/usr/bin/env bash

# we get the current script directory
serverDumpProdToPreprodScriptDirectory="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# we load the scripting colors
source $(realpath ${serverDumpProdToPreprodScriptDirectory}/../helpers/loadScriptingColors.sh)

# we check if the current user has the sudo rights
source $(realpath ${serverDumpProdToPreprodScriptDirectory}/../helpers/requiresSudoRights.sh)

# we check if the current user has the sudo rights
source $(realpath ${serverDumpProdToPreprodScriptDirectory}/../helpers/requiresEnvironment.sh) preprod

# script begin
echo -e "${purple}▽ DUMPING PROD ON PREPROD : STARTING ▽${reset}\n"

echo -e "${gray}=================================================${reset}\n"

# custom instructions execution
setVariablesScript=${serverDumpProdToPreprodScriptDirectory}/../../.utils.custom/server/dumpProdToPreprod/setVariables.sh
if [ -f "${setVariablesScript}" ]; then
    echo -e "${green}✔${reset} ${gray}The .utils.custom/server/dumpProdToPreprod/setVariables.sh custom instructions script has been detected and executed.${reset}\n"
    source ${setVariablesScript}
else
    echo -e "${red}✗${reset} ${gray}No .utils.custom/server/dumpProdToPreprod/setVariables.sh script detected.${reset}\n"
fi
source $(realpath ${serverDumpProdToPreprodScriptDirectory}/../helpers/checkVariableIsDefined.sh) preprodUser
source $(realpath ${serverDumpProdToPreprodScriptDirectory}/../helpers/checkVariableIsDefined.sh) prodUser
source $(realpath ${serverDumpProdToPreprodScriptDirectory}/../helpers/checkVariableIsDefined.sh) currentPreprodProjectPath
source $(realpath ${serverDumpProdToPreprodScriptDirectory}/../helpers/checkVariableIsDefined.sh) currentProductionProjectPath

echo -e "${gray}=================================================${reset}\n"

# we set the maintenance mode
echo "${purple}▶${reset} Enabling maintenance mode ..."
echo "${purple}→ /usr/bin/php ${currentPreprodProjectPath}/current/artisan down${reset}"
/usr/bin/php ${currentPreprodProjectPath}/current/artisan down
echo -e "${green}✔${reset} Maintenance mode enabled.\n"

echo -e "${gray}=================================================${reset}\n"

# we reset the preprod database
echo "${purple}▶${reset} Reseting preprod database ..."
echo "${purple}→ /usr/bin/php ${currentPreprodProjectPath}/current/artisan database:drop --force${reset}"
/usr/bin/php ${currentPreprodProjectPath}/current/artisan database:drop --force
echo -e "${green}✔${reset} Preprod database reset OK.\n"

# we export the production .env file variables
source $(realpath ${serverDumpProdToPreprodScriptDirectory}/../helpers/exportEnvFileVariables.sh) ${currentProductionProjectPath}/shared/.env

# we generate a production pgsql dump
source $(realpath ${serverDumpProdToPreprodScriptDirectory}/../database/generatePgsqlDump.sh) ${productionSqlDumpStoragePath}

# we export the production .env file variables
source $(realpath ${serverDumpProdToPreprodScriptDirectory}/../helpers/exportEnvFileVariables.sh) ${currentPreprodProjectPath}/shared/.env

echo -e "${gray}=================================================${reset}\n"

# we apply the production dump to preprod
echo "${purple}▶${reset} Importing the production database dump in the ${purple}${DB_DATABASE}${reset} database ..."
echo "${purple}→ sudo -i -u ${preprodUser} psql "${DB_DATABASE}" < ${productionSqlDumpStoragePath}${reset}"
sudo -i -u ${preprodUser} psql "${DB_DATABASE}" < ${productionSqlDumpStoragePath}
echo -e "${green}✔${reset} Production database dump successfully imported in the ${purple}${DB_DATABASE}${reset} database.\n"

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
additionalInstructionsScript=${serverDumpProdToPreprodScriptDirectory}/../../.utils.custom/server/dumpProdToPreprod/additionalInstructions.sh
if [ -f "${additionalInstructionsScript}" ]; then
    echo -e "${green}✔${reset} ${gray}The .utils.custom/server/dumpProdToPreprod/additionalInstructions.sh custom instructions script has been detected and executed.${reset}\n"
    source ${additionalInstructionsScript}
else
    echo -e "${red}✗${reset} ${gray}No .utils.custom/server/dumpProdToPreprod/additionalInstructions.sh script detected.${reset}\n"
fi

echo -e "${gray}=================================================${reset}\n"

# we remove the maintenance mode
echo "${purple}▶${reset} Disabling maintenance mode ..."
echo "${purple}→ /usr/bin/php ${currentPreprodProjectPath}/current/artisan up${reset}"
/usr/bin/php ${currentPreprodProjectPath}/current/artisan up
echo -e "${green}✔${reset} Maintenance mode disabled.\n"

# script end
echo -e "${green}△ DUMPING PROD ON PREPROD : DONE △${reset}\n"
