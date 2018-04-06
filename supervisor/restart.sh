#!/usr/bin/env bash

# we get the current script directory
currentScriptDirectory="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# we load the scripting colors
source $(realpath ${currentScriptDirectory}/../helpers/loadScriptingColors.sh)

# we export the .env file variables
source $(realpath ${currentScriptDirectory}/../helpers/exportEnvFileVariables.sh) --

echo -e "${gray}=================================================${reset}\n"

# project supervisor detection
supervisorConfigFile=/etc/supervisor/conf.d/laravel-${APP_ENV}-${DB_DATABASE}-worker.conf
if [ ! -f supervisorConfigFile ]; then
    echo "${red}✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗${reset}"
    echo "${purple}▶${reset} The supervisor project config does not exist : ${purple}${supervisorConfigFile}${reset}."
    echo "${purple}▶${reset} The command has been aborted."
    echo -e "${red}✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗${reset}\n"
    exit 1
else
    echo -e "${green}✔${reset} Supervisor config detected : ${purple}${supervisorConfigFile}${reset}.\n"
fi

echo -e "${gray}=================================================${reset}\n"

# restarting supervisor queues (add as much lines as you have queues here)
echo "${purple}→ sudo supervisorctl restart \"laravel-${APP_ENV}-${DB_DATABASE}-worker:*\"${reset}"
sudo supervisorctl restart "laravel-${APP_ENV}-${DB_DATABASE}-worker:*"
echo -e "${green}✔${reset} Supervisor configured and started\n"
