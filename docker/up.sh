#!/usr/bin/env bash

# we get the current script directory
currentScriptDirectory="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# we load the scripting colors
source $(realpath ${currentScriptDirectory}/../helpers/loadScriptingColors.sh)

# we set the script variables
source $(realpath ${currentScriptDirectory}/../helpers/exportEnvFileVariables.sh)
source $(realpath ${currentScriptDirectory}/../helpers/checkVariableIsDefined.sh) PROJECT_PATH
source ${PROJECT_PATH}.utils/helpers/checkVariableIsDefined.sh NGINX_DOMAIN
source ${PROJECT_PATH}.utils/helpers/checkVariableIsDefined.sh LARADOCK_DIRECTORY_PATH
arguments=$@
buildArgument=''

# we set the script functions
function startContainers () {
    if [[ ${arguments} = *'build'* ]]; then
        source ${PROJECT_PATH}.utils/docker/build-project-config.sh
       buildArgument='--build'
    fi
    if [[ ${arguments} = *'proxy'* ]]; then
        source ${PROJECT_PATH}.utils/docker/build-dinghy-nginx-proxy-config.sh
    fi
    echo "${purple}▶${reset} Executing docker-compose command ..."
    cd ${LARADOCK_DIRECTORY_PATH}
    docker-compose up -d ${buildArgument} workspace php-fpm nginx mysql
    cd ${PROJECT_PATH}
    echo -e "${green}✔${reset} Docker-compose executed.\n"
}

# we execute the script treatments
startContainers
