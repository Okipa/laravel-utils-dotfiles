#!/bin/bash

# we get the current script directory
dumpProdToPreprodScriptDirectory=$(dirname "$(readlink -f ${BASH_SOURCE[0]})")

# we load the scripting colors
source $(realpath ${dumpProdToPreprodScriptDirectory}/../helpers/loadScriptingColors.sh)

# we check if the current user has the sudo rights
source $(realpath ${dumpProdToPreprodScriptDirectory}/../helpers/requiresSudoRights.sh)

# we check if the current environment is preprod
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
source $(realpath ${dumpProdToPreprodScriptDirectory}/../helpers/checkVariableIsDefined.sh) serverPreprodUser
source $(realpath ${dumpProdToPreprodScriptDirectory}/../helpers/checkVariableIsDefined.sh) serverProdUser
source $(realpath ${dumpProdToPreprodScriptDirectory}/../helpers/checkVariableIsDefined.sh) serverPreprodProjectPath
source $(realpath ${dumpProdToPreprodScriptDirectory}/../helpers/checkVariableIsDefined.sh) serverProductionProjectPath
source $(realpath ${dumpProdToPreprodScriptDirectory}/../helpers/checkVariableIsDefined.sh) serverProductionSqlDumpStorageDirectory

echo -e "${gray}=================================================${reset}\n"

# we set the maintenance mode
echo "${purple}▶${reset} Enabling maintenance mode ..."
echo "${purple}→ /usr/bin/php ${serverPreprodProjectPath}/current/artisan down${reset}"
/usr/bin/php ${serverPreprodProjectPath}/current/artisan down
echo -e "${green}✔${reset} Maintenance mode enabled.\n"

echo -e "${gray}=================================================${reset}\n"

# we create the production dump storage directory
echo "${purple}▶${reset} Creating the server ${serverProductionSqlDumpStorageDirectory} directory ..."
echo "${purple}→ mkdir -p ${serverProductionSqlDumpStorageDirectory}${reset}"
mkdir -p ${serverProductionSqlDumpStorageDirectory}
echo -e "${green}✔${reset} Server ${purple}${serverProductionSqlDumpStorageDirectory}${reset} directory available.\n"

# we export the preprod .env file variables
source $(realpath ${dumpProdToPreprodScriptDirectory}/../helpers/exportEnvFileVariables.sh) ${serverPreprodProjectPath}/shared/.env

echo -e "${gray}=================================================${reset}\n"

# we drop the preprod database
dropDatabaseScript=${dumpProdToPreprodScriptDirectory}/../../.utils.custom/dump/prodToPreprod/dropDatabase.sh
if [ -f "${dropDatabaseScript}" ]; then
    echo -e "${green}✔${reset} ${gray}The .utils.custom/dump/prodToPreprod/dropDatabase.sh custom instructions script has been detected and executed.${reset}\n"
    source ${dropDatabaseScript}
else
    echo -e "${red}✗${reset} ${gray}No .utils.custom/dump/prodToPreprod/dropDatabase.sh script detected.${reset}\n"
fi

# we export the production .env file variables
source $(realpath ${dumpProdToPreprodScriptDirectory}/../helpers/exportEnvFileVariables.sh) ${serverProductionProjectPath}/shared/.env

echo -e "${gray}=================================================${reset}\n"

# we generate a production sql dump
generateSqlDumpScript=${dumpProdToPreprodScriptDirectory}/../../.utils.custom/dump/prodToPreprod/generateProductionSqlDump.sh
if [ -f "${generateSqlDumpScript}" ]; then
    echo -e "${green}✔${reset} ${gray}The .utils.custom/dump/prodToPreprod/generateProductionSqlDump.sh custom instructions script has been detected and executed.${reset}\n"
    source ${generateSqlDumpScript}
else
    echo -e "${red}✗${reset} ${gray}No .utils.custom/dump/prodToPreprod/generateProductionSqlDump.sh script detected.${reset}\n"
fi

# we export the preprod .env file variables
source $(realpath ${dumpProdToPreprodScriptDirectory}/../helpers/exportEnvFileVariables.sh) ${serverPreprodProjectPath}/shared/.env

echo -e "${gray}=================================================${reset}\n"

# we import the sql production dump into preprod
echo "${purple}▶${reset} Importing the sql production dump into the ${purple}${DB_DATABASE}${reset} database ..."
echo "${purple}→ su ${serverPreprodUser} -c \"psql ${DB_DATABASE} < ${serverProductionSqlDumpStorageDirectory}/nsn_dump.sql\"${reset}"
su ${serverPreprodUser} -c "psql ${DB_DATABASE} < ${serverProductionSqlDumpStorageDirectory}/nsn_dump.sql"
echo -e "${green}✔${reset} Production sql dump successfully imported into the ${purple}${DB_DATABASE}${reset} database.\n"

echo -e "${gray}=================================================${reset}\n"

echo "${purple}▶${reset} Executing Laravel migration to ${purple}${DB_DATABASE}${reset} database ..."
echo "${purple}→ su ${serverPreprodUser} -c \"/usr/bin/php ${serverPreprodProjectPath}/current/artisan migrate${reset}\""
su ${serverPreprodUser} -c "/usr/bin/php ${serverPreprodProjectPath}/current/artisan migrate"
echo -e "${green}✔${reset} Laravel migrations executed on the ${purple}${DB_DATABASE}${reset} database.\n"

echo -e "${gray}=================================================${reset}\n"

# we execute the additional instructions
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
echo "${purple}→ /usr/bin/php ${serverPreprodProjectPath}/current/artisan up${reset}"
/usr/bin/php ${serverPreprodProjectPath}/current/artisan up
echo -e "${green}✔${reset} Maintenance mode disabled.\n"

# script end
echo -e "${green}△ DUMPING PROD ON PREPROD : DONE △${reset}\n"
