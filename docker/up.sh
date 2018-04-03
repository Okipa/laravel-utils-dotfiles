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
buildArgument=''

# we get the script arguments
arguments=$@

# we set the script functions
function startContainers () {
    if [[ ${arguments} = *'build'* ]]; then
        source ${PROJECT_PATH}.utils/docker/buildProjectConfig.sh
        buildArgument='--build'
    fi
    if [[ ${arguments} = *'proxy'* ]]; then
        source ${PROJECT_PATH}.utils/docker/buildDinghyNginxProxyConfig.sh
    fi

    echo -e "${gray}=================================================${reset}\n"

    echo "${purple}▶${reset} Executing docker-compose command ..."
    cd ${LARADOCK_DIRECTORY_PATH}
    # custom instructions execution
    dockerUpScript=${currentScriptDirectory}/../../.utils.custom/docker/up.sh
    if [ -f "${dockerUpScript}" ]; then
        echo "${green}✔${reset} ${gray}The .utils.custom/docker/setEnvVariable.sh custom instructions script has been detected.${reset}"
        source ${dockerUpScript}
    else
        echo "${red}✗${reset} No .utils.custom/docker/setEnvVariables.sh script detected."
        echo "${purple}→ docker-compose up -d ${arguments}${reset}"
        docker-compose up -d ${arguments}
    fi
    cd ${PROJECT_PATH}
    echo -e "${green}✔${reset} Docker-compose executed.\n"
}

# we execute the script treatments
startContainers
