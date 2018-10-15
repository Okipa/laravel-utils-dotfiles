#!/bin/bash

# we get the current script directory
supervisorLaravelQueueInstallScriptDirectory=$(dirname "$(readlink -f ${BASH_SOURCE[0]})")

# we load the scripting colors
source $(realpath ${supervisorLaravelQueueInstallScriptDirectory}/../helpers/loadScriptingColors.sh)

# we export the .env file variables
source $(realpath ${supervisorLaravelQueueInstallScriptDirectory}/../helpers/exportEnvFileVariables.sh) --

# we check if the current user has the sudo rights
source $(realpath ${supervisorLaravelQueueInstallScriptDirectory}/../helpers/requiresSudoRights.sh)

# we check that the variables required by the script are defined
source $(realpath ${supervisorLaravelQueueInstallScriptDirectory}/../helpers/checkVariableIsDefined.sh) APP_ENV
source $(realpath ${supervisorLaravelQueueInstallScriptDirectory}/../helpers/checkVariableIsDefined.sh) DB_DATABASE

# we set the script variables
[[ $1 = "--force" ]] && FORCE=true || FORCE=false

# supervisor laravel queues configuration
if [ "$FORCE" == false ]; then
    echo -e "${gray}=================================================${reset}\n"
    read -p "Would you like to configure the project queue supervisor task ? [${green}y${reset}/${red}N${reset}]" -n 1 -r
    echo
fi
if [ "$FORCE" == true ] || [[ "$REPLY" =~ ^[Yy]$ ]]; then
    # we set the artisan project path
    echo "${purple}▶${reset} Setting artisan path ..."
    ARTISAN_PATH=$(realpath ${supervisorLaravelQueueInstallScriptDirectory}/../../../current/artisan)
    echo -e "${green}✔${reset} Artisan path determined : ${purple}${ARTISAN_PATH}${reset}\n"
    # we get the file owner
    echo "${purple}▶${reset} Getting the file owner ..."
    PROJECT_USER=$(stat -c '%U' .)
    echo -e "${green}✔${reset} File owner determined : ${purple}${PROJECT_USER}${reset}\n"
    # we create or override the supervisor config with the dynamic values
    echo "${purple}▶ creating or overriding /etc/supervisor/conf.d/laravel-queue-${APP_ENV}-${DB_DATABASE}-worker.conf${reset}"
    bash -c 'cat << EOF > /etc/supervisor/conf.d/laravel-queue-'"${APP_ENV}"'-'"${DB_DATABASE}"'-worker.conf
[program:laravel-queue-'"${APP_ENV}"'-'"${DB_DATABASE}"'-worker]
process_name=%(program_name)s_%(process_num)02d
command='"$(which php)"' '"${ARTISAN_PATH}"' queue:work database --tries=3 --queue=high,default --env='"${APP_ENV}"'
autostart=true
autorestart=true
user='"${PROJECT_USER}"'
numprocs=2
redirect_stderr=true
stdout_logfile=/var/log/supervisor/laravel-queue-'"${APP_ENV}"'-'"${DB_DATABASE}"'-worker.log
EOF'
    echo -e "${green}✔${reset} Supervisor configured.\n"
    echo "${purple}▶${reset} Updating and restarting supervisor ..."
    # making supervisor taking care of the configured queues
    echo "${purple}→ supervisorctl reread${reset}"
    supervisorctl reread
    echo "${purple}→ supervisorctl update${reset}"
    supervisorctl update
    # starting supervisor queues (add as much lines as you have queues here)
    echo "${purple}→ supervisorctl restart laravel-${APP_ENV}-${DB_DATABASE}-worker${reset}"
    supervisorctl restart laravel-"${APP_ENV}"-"${DB_DATABASE}"-worker:*
    echo -e "${green}✔${reset} Supervisor updated and restarted.\n"
else
    echo "${red}✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗${reset}"
    echo "${purple}▶${reset} Supervisor configuration aborted."
    echo -e "${red}✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗${reset}\n"
fi
