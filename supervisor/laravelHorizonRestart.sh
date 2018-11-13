#!/bin/bash

supervisorLaravelHorizonRestartScriptDirectory=$(dirname "$(readlink -f ${BASH_SOURCE[0]})")

source $(realpath ${supervisorLaravelHorizonRestartScriptDirectory}/../helpers/loadScriptingColors.sh)

source $(realpath ${supervisorLaravelHorizonRestartScriptDirectory}/../helpers/exportEnvFileVariables.sh) --

source $(realpath ${supervisorLaravelHorizonRestartScriptDirectory}/../helpers/checkVariableIsDefined.sh) APP_ENV
source $(realpath ${supervisorLaravelHorizonRestartScriptDirectory}/../helpers/checkVariableIsDefined.sh) DB_DATABASE

source $(realpath ${supervisorLaravelHorizonRestartScriptDirectory}/../helpers/checkFileExists.sh) /etc/supervisor/conf.d/laravel-horizon-${APP_ENV}-${DB_DATABASE}-worker.conf

echo -e "${gray}=================================================${reset}\n"

echo "${purple}▶${reset} Restarting laravel-horizon supervisor workers ..."
echo "${purple}→ sudo supervisorctl restart \"laravel-horizon-${APP_ENV}-${DB_DATABASE}-worker:*\"${reset}"
sudo supervisorctl restart "laravel-horizon-${APP_ENV}-${DB_DATABASE}-worker:*"
echo -e "${green}✔${reset} Laravel-horizon supervisor workers restarted.\n"
