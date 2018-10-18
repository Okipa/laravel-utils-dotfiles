#!/bin/bash

# we get the current script directory
supervisorLaravelHorizonInstallScriptDirectory=$(dirname "$(readlink -f ${BASH_SOURCE[0]})")

# we load the scripting colors
source $(realpath ${supervisorLaravelHorizonInstallScriptDirectory}/../helpers/loadScriptingColors.sh)

# we export the .env file variables
source $(realpath ${supervisorLaravelHorizonInstallScriptDirectory}/../helpers/exportEnvFileVariables.sh) --

# we check if the current user has the sudo rights
source $(realpath ${supervisorLaravelHorizonInstallScriptDirectory}/../helpers/requiresSudoRights.sh)

# we check that the variables required by the script are defined
source $(realpath ${supervisorLaravelHorizonInstallScriptDirectory}/../helpers/checkVariableIsDefined.sh) APP_ENV
source $(realpath ${supervisorLaravelHorizonInstallScriptDirectory}/../helpers/checkVariableIsDefined.sh) DB_DATABASE

echo -e "${gray}=================================================${reset}\n"

# we set the script required variables
setRequiredVariablesScript=${supervisorLaravelHorizonInstallScriptDirectory}/../../.utils.custom/supervisor/laravelQueueInstall/setRequiredVariables.sh
if [ -f "${setRequiredVariablesScript}" ]; then
    echo -e "${green}✔${reset} ${gray}The .utils.custom/supervisor/laravelQueueInstall/setRequiredVariables.sh custom instructions script has been detected and executed.${reset}\n"
    source ${setRequiredVariablesScript}
else
    echo -e "${red}✗${reset} ${gray}No .utils.custom/supervisor/laravelQueueInstall/setRequiredVariables.sh script detected.${reset}\n"
fi
source $(realpath ${supervisorLaravelHorizonInstallScriptDirectory}/../helpers/checkVariableIsDefined.sh) relativeProjectBasePathFromScript

# we set the script variables
[[ $1 = "--force" ]] && FORCE=true || FORCE=false

# supervisor task installation
if [ "$FORCE" == false ]; then
    echo -e "${gray}=================================================${reset}\n"
    read -p "Would you like to configure the project supervisor laravel-horizon task ? [${green}y${reset}/${red}N${reset}]" -n 1 -r
    echo
fi
if [ "$FORCE" == true ] || [[ "$REPLY" =~ ^[Yy]$ ]]; then
    # we set the absolute project path
    echo "${purple}▶${reset} Setting absolute project path ..."
    projectPath=$(realpath ${supervisorLaravelHorizonInstallScriptDirectory}${relativeProjectBasePathFromScript})/current
    echo -e "${green}✔${reset} Absolute project path determined : ${purple}${projectPath}${reset}\n"
    # we get the file owner
    echo "${purple}▶${reset} Getting the file owner ..."
    projectUser=$(stat -c '%U' .)
    echo -e "${green}✔${reset} File owner determined : ${purple}${projectUser}${reset}\n"
    # we create or override the supervisor config with the dynamic project values
    echo "${purple}▶ creating or overriding /etc/supervisor/conf.d/laravel-horizon-${APP_ENV}-${DB_DATABASE}-worker.conf${reset}"
    bash -c 'cat << EOF > /etc/supervisor/conf.d/laravel-horizon-'"${APP_ENV}"'-'"${DB_DATABASE}"'-worker.conf
[program:laravel-horizon-'"${APP_ENV}"'-'"${DB_DATABASE}"'-worker]
process_name=%(program_name)s_%(process_num)02d
command='"$(which php)"' '"${projectPath}"'/artisan horizon
autostart=true
autorestart=true
user='"${projectUser}"'
numprocs=1
redirect_stderr=true
stdout_logfile=/var/log/supervisor/laravel-horizon-'"${APP_ENV}"'-'"${DB_DATABASE}"'-worker.log
EOF'
    echo -e "${green}✔${reset} Supervisor configured.\n"
    echo "${purple}▶${reset} Updating and restarting supervisor ..."
    # making supervisor taking care about the configured task
    echo "${purple}→ supervisorctl reread${reset}"
    supervisorctl reread
    echo "${purple}→ supervisorctl update${reset}"
    supervisorctl update
    # starting the supervisor task
    echo "${purple}→ supervisorctl restart laravel-horizon-${APP_ENV}-${DB_DATABASE}-worker${reset}"
    supervisorctl restart laravel-horizon-"${APP_ENV}"-"${DB_DATABASE}"-worker:*
    echo -e "${green}✔${reset} Supervisor updated and restarted.\n"
else
    echo "${red}✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗${reset}"
    echo "${purple}▶${reset} Supervisor configuration aborted."
    echo -e "${red}✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗${reset}\n"
fi
