#!/usr/bin/env bash

# we get the current script directory
supervisorRestartScriptDirectory="$( cd "$(dirname "$0")" ; pwd -P )"

# we load the scripting colors
source $(realpath ${supervisorRestartScriptDirectory}/../helpers/loadScriptingColors.sh)

# we export the .env file variables
source $(realpath ${supervisorRestartScriptDirectory}/../helpers/exportEnvFileVariables.sh) --

# project supervisor configuration file detection
source $(realpath ${supervisorRestartScriptDirectory}/../helpers/checkFileExists.sh) /etc/supervisor/conf.d/laravel-${APP_ENV}-${DB_DATABASE}-worker.conf

echo -e "${gray}=================================================${reset}\n"

# restarting supervisor queues (add as much lines as you have queues here)
echo "${purple}→ sudo supervisorctl restart \"laravel-${APP_ENV}-${DB_DATABASE}-worker:*\"${reset}"
sudo supervisorctl restart "laravel-${APP_ENV}-${DB_DATABASE}-worker:*"
echo -e "${green}✔${reset} Supervisor configured and started\n"
