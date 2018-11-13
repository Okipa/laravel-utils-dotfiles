#!/bin/bash

supervisorLaravelEchoServerRestartScriptDirectory=$(dirname "$(readlink -f ${BASH_SOURCE[0]})")

source $(realpath ${supervisorLaravelEchoServerRestartScriptDirectory}/../helpers/loadScriptingColors.sh)

source $(realpath ${supervisorLaravelEchoServerRestartScriptDirectory}/../helpers/exportEnvFileVariables.sh) --

source $(realpath ${supervisorLaravelEchoServerRestartScriptDirectory}/../helpers/checkVariableIsDefined.sh) APP_ENV
source $(realpath ${supervisorLaravelEchoServerRestartScriptDirectory}/../helpers/checkVariableIsDefined.sh) DB_DATABASE

source $(realpath ${supervisorLaravelEchoServerRestartScriptDirectory}/../helpers/checkFileExists.sh) /etc/supervisor/conf.d/laravel-echo-server-${APP_ENV}-${DB_DATABASE}-worker.conf

echo -e "${gray}=================================================${reset}\n"

echo "${purple}▶${reset} Restarting laravel-echo-server supervisor workers ..."
echo "${purple}→ sudo supervisorctl restart \"laravel-echo-server-${APP_ENV}-${DB_DATABASE}-worker:*\"${reset}"
sudo supervisorctl restart "laravel-echo-server-${APP_ENV}-${DB_DATABASE}-worker:*"
echo -e "${green}✔${reset} Laravel-echo-server supervisor workers restarted.\n"
