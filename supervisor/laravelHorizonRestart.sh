#!/bin/bash

# we get the current script directory
supervisorLaravelHorizonRestartScriptDirectory=$(dirname "$(readlink -f ${BASH_SOURCE[0]})")

# we load the scripting colors
source $(realpath ${supervisorLaravelHorizonRestartScriptDirectory}/../helpers/loadScriptingColors.sh)

# we export the .env file variables
source $(realpath ${supervisorLaravelHorizonRestartScriptDirectory}/../helpers/exportEnvFileVariables.sh) --

# we check that the variables required by the script are defined
source $(realpath ${supervisorLaravelHorizonRestartScriptDirectory}/../helpers/checkVariableIsDefined.sh) APP_ENV
source $(realpath ${supervisorLaravelHorizonRestartScriptDirectory}/../helpers/checkVariableIsDefined.sh) DB_DATABASE

# project supervisor configuration file detection
source $(realpath ${supervisorLaravelHorizonRestartScriptDirectory}/../helpers/checkFileExists.sh) /etc/supervisor/conf.d/laravel-horizon-${APP_ENV}-${DB_DATABASE}-worker.conf

echo -e "${gray}=================================================${reset}\n"

# restarting supervisor task
echo "${purple}→ sudo supervisorctl restart \"laravel-horizon-${APP_ENV}-${DB_DATABASE}-worker:*\"${reset}"
sudo supervisorctl restart "laravel-horizon-${APP_ENV}-${DB_DATABASE}-worker:*"
echo -e "${green}✔${reset} Laravel-horizon supervisor task configured and started\n"
