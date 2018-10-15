#!/bin/bash

# we get the current script directory
supervisorLaravelQueueRestartScriptDirectory=$(dirname "$(readlink -f ${BASH_SOURCE[0]})")

# we load the scripting colors
source $(realpath ${supervisorLaravelQueueRestartScriptDirectory}/../helpers/loadScriptingColors.sh)

# we export the .env file variables
source $(realpath ${supervisorLaravelQueueRestartScriptDirectory}/../helpers/exportEnvFileVariables.sh) --

# we check that the variables required by the script are defined
source $(realpath ${supervisorLaravelQueueRestartScriptDirectory}/../helpers/checkVariableIsDefined.sh) APP_ENV
source $(realpath ${supervisorLaravelQueueRestartScriptDirectory}/../helpers/checkVariableIsDefined.sh) DB_DATABASE

# project supervisor configuration file detection
source $(realpath ${supervisorLaravelQueueRestartScriptDirectory}/../helpers/checkFileExists.sh) /etc/supervisor/conf.d/laravel-${APP_ENV}-${DB_DATABASE}-worker.conf

echo -e "${gray}=================================================${reset}\n"

# restarting supervisor laravel queue task
echo "${purple}→ sudo supervisorctl restart \"laravel-queue-${APP_ENV}-${DB_DATABASE}-worker:*\"${reset}"
sudo supervisorctl restart "laravel-queue-${APP_ENV}-${DB_DATABASE}-worker:*"
echo -e "${green}✔${reset} Laravel queue supervisor task configured and started\n"
