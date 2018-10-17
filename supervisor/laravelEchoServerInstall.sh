#!/bin/bash

# we get the current script directory
supervisorLaravelEchoServerInstallScriptDirectory=$(dirname "$(readlink -f ${BASH_SOURCE[0]})")

# we load the scripting colors
source $(realpath ${supervisorLaravelEchoServerInstallScriptDirectory}/../helpers/loadScriptingColors.sh)

# we export the .env file variables
source $(realpath ${supervisorLaravelEchoServerInstallScriptDirectory}/../helpers/exportEnvFileVariables.sh) --

# we check if the current user has the sudo rights
source $(realpath ${supervisorLaravelEchoServerInstallScriptDirectory}/../helpers/requiresSudoRights.sh)

# we check that the variables required by the script are defined
source $(realpath ${supervisorLaravelEchoServerInstallScriptDirectory}/../helpers/checkVariableIsDefined.sh) APP_ENV
source $(realpath ${supervisorLaravelEchoServerInstallScriptDirectory}/../helpers/checkVariableIsDefined.sh) DB_DATABASE

echo -e "${gray}=================================================${reset}\n"

# we set the script required variables
setRequiredVariablesScript=${supervisorLaravelEchoServerInstallScriptDirectory}/../../.utils.custom/supervisor/setRequiredVariables.sh
if [ -f "${setRequiredVariablesScript}" ]; then
    echo -e "${green}✔${reset} ${gray}The .utils.custom/supervisor/laravelQueueInstall/setRequiredVariables.sh custom instructions script has been detected and executed.${reset}\n"
    source ${setRequiredVariablesScript}
else
    echo -e "${red}✗${reset} ${gray}No .utils.custom/supervisor/laravelQueueInstall/setRequiredVariables.sh script detected.${reset}\n"
fi
source $(realpath ${supervisorLaravelEchoServerInstallScriptDirectory}/../helpers/checkVariableIsDefined.sh) artisanRelativePathFromScript

# we set the script variables
[[ $1 = "--force" ]] && FORCE=true || FORCE=false

# supervisor laravel queues configuration
if [ "$FORCE" == false ]; then
    echo -e "${gray}=================================================${reset}\n"
    read -p "Would you like to configure the project laravel echo server task ? [${green}y${reset}/${red}N${reset}]" -n 1 -r
    echo
fi
if [ "$FORCE" == true ] || [[ "$REPLY" =~ ^[Yy]$ ]]; then
    # we set the project path
    echo "${purple}▶${reset} Setting project path ..."
    PROJECT_PATH=$(realpath ${supervisorLaravelEchoServerInstallScriptDirectory}${artisanRelativePathFromScript})
    echo -e "${green}✔${reset} Project path determined : ${purple}${PROJECT_PATH}${reset}\n"
    # we get the file owner
    echo "${purple}▶${reset} Getting the file owner ..."
    PROJECT_USER=$(stat -c '%U' .)
    echo -e "${green}✔${reset} File owner determined : ${purple}${PROJECT_USER}${reset}\n"
    # we create or override the supervisor config with the dynamic values
    echo "${purple}▶ creating or overriding /etc/supervisor/conf.d/laravel-echo-server-${APP_ENV}-${DB_DATABASE}-worker.conf${reset}"
    bash -c 'cat << EOF > /etc/supervisor/conf.d/laravel-echo-server-'"${APP_ENV}"'-'"${DB_DATABASE}"'-worker.conf
[program:laravel-echo-server-'"${APP_ENV}"'-'"${DB_DATABASE}"'-worker]
process_name=%(program_name)s_%(process_num)02d
command='"${PROJECT_PATH}"'/vendor/bin/laravel-echo-server start
autostart=true
autorestart=true
user='"${PROJECT_USER}"'
numprocs=1
redirect_stderr=true
stdout_logfile=/var/log/supervisor/laravel-echo-server-'"${APP_ENV}"'-'"${DB_DATABASE}"'-worker.log
EOF'
    echo -e "${green}✔${reset} Supervisor configured.\n"
    echo "${purple}▶${reset} Updating and restarting supervisor ..."
    # making supervisor taking care of the configured queues
    echo "${purple}→ supervisorctl reread${reset}"
    supervisorctl reread
    echo "${purple}→ supervisorctl update${reset}"
    supervisorctl update
    # starting supervisor queues (add as much lines as you have queues here)
    echo "${purple}→ supervisorctl restart laravel-echo-server-${APP_ENV}-${DB_DATABASE}-worker${reset}"
    supervisorctl restart laravel-"${APP_ENV}"-"${DB_DATABASE}"-worker:*
    echo -e "${green}✔${reset} Supervisor updated and restarted.\n"
else
    echo "${red}✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗${reset}"
    echo "${purple}▶${reset} Supervisor configuration aborted."
    echo -e "${red}✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗${reset}\n"
fi
