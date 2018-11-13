#!/bin/bash

supervisorLaravelQueueInstallScriptDirectory=$(dirname "$(readlink -f ${BASH_SOURCE[0]})")

source $(realpath ${supervisorLaravelQueueInstallScriptDirectory}/../helpers/loadScriptingColors.sh)

source $(realpath ${supervisorLaravelQueueInstallScriptDirectory}/../helpers/exportEnvFileVariables.sh) --

source $(realpath ${supervisorLaravelQueueInstallScriptDirectory}/../helpers/requiresSudoRights.sh)

source $(realpath ${supervisorLaravelQueueInstallScriptDirectory}/../helpers/checkVariableIsDefined.sh) APP_ENV
source $(realpath ${supervisorLaravelQueueInstallScriptDirectory}/../helpers/checkVariableIsDefined.sh) DB_DATABASE

echo -e "${gray}=================================================${reset}\n"

setRequiredVariablesScriptPath=${supervisorLaravelQueueInstallScriptDirectory}/../../.utils.custom/supervisor/laravelQueueInstall/setRequiredVariables.sh
source $(realpath ${supervisorLaravelQueueInstallScriptDirectory}/../helpers/checkFileExists.sh) ${setRequiredVariablesScriptPath}
source ${setRequiredVariablesScriptPath}
source $(realpath ${supervisorLaravelQueueInstallScriptDirectory}/../helpers/checkVariableIsDefined.sh) relativeProjectBasePathFromScript

[[ $1 = "--force" ]] && FORCE=true || FORCE=false

if [ "$FORCE" == false ]; then
    echo -e "${gray}=================================================${reset}\n"
    
    read -p "Would you like to configure the project supervisor laravel-queue task ? [${green}y${reset}/${red}N${reset}]" -n 1 -r
    echo
fi
if [ "$FORCE" == true ] || [[ "$REPLY" =~ ^[Yy]$ ]]; then

    echo "${purple}▶${reset} Setting absolute project path ..."
    projectPath=$(realpath ${supervisorLaravelQueueInstallScriptDirectory}${relativeProjectBasePathFromScript})/current
    echo -e "${green}✔${reset} Absolute project path determined : ${purple}${projectPath}${reset}\n"
    
    echo -e "${gray}=================================================${reset}\n"
    
    echo "${purple}▶${reset} Getting the file owner ..."
    projectUser=$(stat -c '%U' .)
    echo -e "${green}✔${reset} File owner determined : ${purple}${projectUser}${reset}\n"
    
    echo -e "${gray}=================================================${reset}\n"
    
    echo "${purple}▶ creating or overriding /etc/supervisor/conf.d/laravel-queue-${APP_ENV}-${DB_DATABASE}-worker.conf${reset}"
    bash -c 'cat << EOF > /etc/supervisor/conf.d/laravel-queue-'"${APP_ENV}"'-'"${DB_DATABASE}"'-worker.conf
[program:laravel-queue-'"${APP_ENV}"'-'"${DB_DATABASE}"'-worker]
process_name=%(program_name)s_%(process_num)02d
command='"$(which php)"' '"${projectPath}"'/artisan queue:work --sleep=3 --tries=3 --queue=high,default --env='"${APP_ENV}"'
autostart=true
autorestart=true
user='"${projectUser}"'
numprocs=4
redirect_stderr=true
stdout_logfile=/var/log/supervisor/laravel-queue-'"${APP_ENV}"'-'"${DB_DATABASE}"'-worker.log
EOF'
    echo -e "${green}✔${reset} Supervisor configured.\n"
    
    echo -e "${gray}=================================================${reset}\n"
    
    echo "${purple}▶${reset} Rereading supervisor runners ..."
    echo "${purple}→ supervisorctl reread${reset}"
    supervisorctl reread
    echo -e "${green}✔${reset} Supervisor runners reread.\n"
    
    echo -e "${gray}=================================================${reset}\n"
    
    echo "${purple}▶${reset} Updating supervisor runners ..."
    echo "${purple}→ supervisorctl update${reset}"
    supervisorctl update
    echo -e "${green}✔${reset} Supervisor runners updated.\n"
    
    echo -e "${gray}=================================================${reset}\n"
    
    echo "${purple}▶${reset} Restarting supervisor runners ..."
    echo "${purple}→ supervisorctl restart laravel-queue-${APP_ENV}-${DB_DATABASE}-worker${reset}"
    supervisorctl restart laravel-queue-"${APP_ENV}"-"${DB_DATABASE}"-worker:*
    echo -e "${green}✔${reset} Supervisor runners restarted.\n"
else
    echo "${red}✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗${reset}"
    echo "${purple}▶${reset} Supervisor configuration aborted."
    echo -e "${red}✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗${reset}\n"
fi
