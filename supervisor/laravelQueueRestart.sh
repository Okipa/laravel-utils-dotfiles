#!/bin/bash

supervisorLaravelQueueRestartScriptDirectory=$(dirname "$(readlink -f ${BASH_SOURCE[0]})")

source $(realpath ${supervisorLaravelQueueRestartScriptDirectory}/../helpers/loadScriptingColors.sh)

source $(realpath ${supervisorLaravelQueueRestartScriptDirectory}/../helpers/exportEnvFileVariables.sh) --

source $(realpath ${supervisorLaravelQueueRestartScriptDirectory}/../helpers/checkVariableIsDefined.sh) APP_ENV
source $(realpath ${supervisorLaravelQueueRestartScriptDirectory}/../helpers/checkVariableIsDefined.sh) DB_DATABASE

source $(realpath ${supervisorLaravelQueueRestartScriptDirectory}/../helpers/checkFileExists.sh) /etc/supervisor/conf.d/laravel-queue-${APP_ENV}-${DB_DATABASE}-worker.conf

echo -e "${gray}=================================================${reset}\n"

echo "${purple}▶${reset} Restarting laravel-queue supervisor workers ..."
echo "${purple}→ sudo supervisorctl restart \"laravel-queue-${APP_ENV}-${DB_DATABASE}-worker:*\"${reset}"
sudo supervisorctl restart "laravel-queue-${APP_ENV}-${DB_DATABASE}-worker:*"
echo -e "${green}✔${reset} Laravel-queue workers restarted.\n"
