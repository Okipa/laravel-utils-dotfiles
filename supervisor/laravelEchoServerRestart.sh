#!/bin/bash

# we get the current script directory
supervisorLaravelEchoServerRestartScriptDirectory=$(dirname "$(readlink -f ${BASH_SOURCE[0]})")

# we load the scripting colors
source $(realpath ${supervisorLaravelEchoServerRestartScriptDirectory}/../helpers/loadScriptingColors.sh)

# we export the .env file variables
source $(realpath ${supervisorLaravelEchoServerRestartScriptDirectory}/../helpers/exportEnvFileVariables.sh) --

# we check that the variables required by the script are defined
source $(realpath ${supervisorLaravelEchoServerRestartScriptDirectory}/../helpers/checkVariableIsDefined.sh) APP_ENV
source $(realpath ${supervisorLaravelEchoServerRestartScriptDirectory}/../helpers/checkVariableIsDefined.sh) DB_DATABASE

# project supervisor configuration file detection
source $(realpath ${supervisorLaravelEchoServerRestartScriptDirectory}/../helpers/checkFileExists.sh) /etc/supervisor/conf.d/laravel-echo-server-${APP_ENV}-${DB_DATABASE}-worker.conf

echo -e "${gray}=================================================${reset}\n"

# restarting supervisor task
echo "${purple}→ sudo supervisorctl restart \"laravel-echo-server-${APP_ENV}-${DB_DATABASE}-worker:*\"${reset}"
sudo supervisorctl restart "laravel-echo-server-${APP_ENV}-${DB_DATABASE}-worker:*"
echo -e "${green}✔${reset} Laravel-echo-server supervisor task restarted\n"
