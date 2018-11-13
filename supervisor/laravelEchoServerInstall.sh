#!/bin/bash

supervisorLaravelEchoServerInstallScriptDirectory=$(dirname "$(readlink -f ${BASH_SOURCE[0]})")

source $(realpath ${supervisorLaravelEchoServerInstallScriptDirectory}/../helpers/loadScriptingColors.sh)

source $(realpath ${supervisorLaravelEchoServerInstallScriptDirectory}/../helpers/exportEnvFileVariables.sh) --

source $(realpath ${supervisorLaravelEchoServerInstallScriptDirectory}/../helpers/requiresSudoRights.sh)

source $(realpath ${supervisorLaravelEchoServerInstallScriptDirectory}/../helpers/checkVariableIsDefined.sh) APP_ENV
source $(realpath ${supervisorLaravelEchoServerInstallScriptDirectory}/../helpers/checkVariableIsDefined.sh) DB_DATABASE

echo -e "${gray}=================================================${reset}\n"

setRequiredVariablesScriptPath=${supervisorLaravelEchoServerInstallScriptDirectory}/../../.utils.custom/supervisor/laravelEchoServerInstall/setRequiredVariables.sh
source $(realpath ${supervisorLaravelEchoServerInstallScriptDirectory}/../helpers/checkFileExists.sh) ${setRequiredVariablesScriptPath}
source ${setRequiredVariablesScriptPath}
source $(realpath ${supervisorLaravelEchoServerInstallScriptDirectory}/../helpers/checkVariableIsDefined.sh) relativeProjectBasePathFromScript
source $(realpath ${supervisorLaravelEchoServerInstallScriptDirectory}/../helpers/checkVariableIsDefined.sh) laravelEchoServerBinaryPath

[[ $1 = "--force" ]] && FORCE=true || FORCE=false

if [ "$FORCE" == false ]; then
    echo -e "${gray}=================================================${reset}\n"
    
    read -p "Would you like to configure the project supervisor laravel-echo-server task ? [${green}y${reset}/${red}N${reset}]" -n 1 -r
    echo
fi
if [ "$FORCE" == true ] || [[ "$REPLY" =~ ^[Yy]$ ]]; then

    echo "${purple}▶${reset} Setting absolute project path ..."
    projectPath=$(realpath ${supervisorLaravelEchoServerInstallScriptDirectory}${relativeProjectBasePathFromScript})/current
    echo -e "${green}✔${reset} Absolute project path determined : ${purple}${projectPath}${reset}\n"
    
    echo -e "${gray}=================================================${reset}\n"
    
    echo "${purple}▶${reset} Getting the file owner ..."
    projectUser=$(stat -c '%U' .)
    echo -e "${green}✔${reset} File owner determined : ${purple}${projectUser}${reset}\n"
    
    echo -e "${gray}=================================================${reset}\n"
    
    echo "${purple}▶ creating or overriding /etc/supervisor/conf.d/laravel-echo-server-${APP_ENV}-${DB_DATABASE}-worker.conf${reset}"
    bash -c 'cat << EOF > /etc/supervisor/conf.d/laravel-echo-server-'"${APP_ENV}"'-'"${DB_DATABASE}"'-worker.conf
[program:laravel-echo-server-'"${APP_ENV}"'-'"${DB_DATABASE}"'-worker]
process_name=%(program_name)s_%(process_num)02d
directory='"${projectPath}"'
command='"$(which node)"' '"${projectPath}${laravelEchoServerBinaryPath}"' start
autostart=true
autorestart=true
user='"${projectUser}"'
numprocs=1
redirect_stderr=true
stdout_logfile=/var/log/supervisor/laravel-echo-server-'"${APP_ENV}"'-'"${DB_DATABASE}"'-worker.log
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
    echo "${purple}→ supervisorctl restart laravel-echo-server-${APP_ENV}-${DB_DATABASE}-worker${reset}"
    supervisorctl restart laravel-echo-server-"${APP_ENV}"-"${DB_DATABASE}"-worker:*
    echo -e "${green}✔${reset} Supervisor runners restarted.\n"
else
    echo "${red}✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗${reset}"
    echo "${purple}▶${reset} Supervisor configuration aborted."
    echo -e "${red}✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗${reset}\n"
fi
