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
source $(realpath ${serverDumpProdToPreprodScriptDirectory}/../sql/generatePgsqlDump.sh) /tmp/prod_nsn_dump.sql

echo -e "${gray}=================================================${reset}\n"

# we export preprod .env variables
echo "${purple}→ source $(realpath ${serverDumpProdToPreprodScriptDirectory}/../helpers/exportEnvFileVariables.sh) /var/www/preprod/web/www/nsn/shared/.env${reset}"
source $(realpath ${serverDumpProdToPreprodScriptDirectory}/../helpers/exportEnvFileVariables.sh) /var/www/preprod/web/www/nsn/shared/.env

echo -e "${gray}=================================================${reset}\n"

# we apply the production dump to preprod
echo "${purple}▶${reset} Applying the database dump to preprod ..."
echo "${purple}→ sudo -i -u preprod psql "${DB_DATABASE}" < /tmp/prod_nsn_dump.sql${reset}"
sudo -i -u preprod psql "${DB_DATABASE}" < /tmp/prod_nsn_dump.sql
echo -e "${green}✔${reset} Preprod database dump successfully applied.\n"

echo -e "${gray}=================================================${reset}\n"

echo "${purple}▶${reset} Applying Laravel migration to preprod ..."
echo "${purple}→ sudo -i -u preprod /usr/bin/php /var/www/preprod/web/www/nsn/current/artisan migrate${reset}"
sudo -i -u preprod /usr/bin/php /var/www/preprod/web/www/nsn/current/artisan migrate
echo -e "${green}✔${reset} Laravel migrations applied.\n"

echo -e "${gray}=================================================${reset}\n"

# we remove the prod dump
echo "${purple}▶${reset} Removing the the production dump ..."
echo "${purple}→ rm -f /tmp/prod_nsn_dump.sql${reset}"
rm -f /tmp/prod_nsn_dump.sql
echo -e "${green}✔${reset} Production dump removed.\n"

echo -e "${gray}=================================================${reset}\n"

# we generate a public/files archive and store it the /tmp/prod/delegations_dump directory
echo "${purple}▶${reset} Copying the production public/files directory to the preprod project ..."
echo "${purple}→ rm -rf /var/www/preprod/web/www/nsn/shared/public/files${reset}"
rm -rf /var/www/preprod/web/www/nsn/shared/public/files
echo "${purple}→ cp -R /var/www/prod/web/www/nsn/shared/public/files /var/www/preprod/web/www/nsn/shared/public/files${reset}"
cp -R /var/www/prod/web/www/nsn/shared/public/files /var/www/preprod/web/www/nsn/shared/public/files
echo "${purple}→ chown -R preprod:users /var/www/preprod/web/www/nsn/shared/public/files${reset}"
chown -R preprod:users /var/www/preprod/web/www/nsn/shared/public/files
echo -e "${green}✔${reset} files directory copied with success.\n"

echo -e "${gray}=================================================${reset}\n"

# we set the maintenance mode
echo "${purple}▶${reset} Disabling maintenance mode ..."
echo "${purple}→ /usr/bin/php /var/www/preprod/web/www/nsn/current/artisan up${reset}"
/usr/bin/php /var/www/preprod/web/www/nsn/current/artisan up
echo -e "${green}✔${reset} Maintenance mode disabled.\n"

# script end
echo -e "${green}△ DUMPING PROD ON PREPROD : DONE △${reset}\n"
