#!/usr/bin/env bash

# we get the current script directory
DockerUpScriptDirectory="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# we load the scripting colors
source $(realpath ${DockerUpScriptDirectory}/../helpers/loadScriptingColors.sh)

# we export the .env file variables
source $(realpath ${DockerUpScriptDirectory}/../helpers/exportEnvFileVariables.sh) --

# we check that the variables required by the script are defined
source $(realpath ${DockerUpScriptDirectory}/../helpers/checkVariableIsDefined.sh) PROJECT_PATH
source $(realpath ${DockerUpScriptDirectory}/../helpers/checkVariableIsDefined.sh) NGINX_DOMAIN
source $(realpath ${DockerUpScriptDirectory}/../helpers/checkVariableIsDefined.sh) LARADOCK_DIRECTORY_PATH

# we set the script variables
buildArgument=

# we get the script arguments
arguments=$@

# we set the script functions
function startContainers () {
    if [[ ${arguments} = *'build'* ]]; then
        source ${DockerUpScriptDirectory}/buildProjectConfig.sh
        buildArgument='--build'
    fi
    if [[ ${arguments} = *'proxy'* ]]; then
        source ${DockerUpScriptDirectory}/buildProxyConfig.sh
    fi

    echo -e "${gray}=================================================${reset}\n"

    echo "${purple}▶${reset} Executing docker-compose command ..."
    cd ${LARADOCK_DIRECTORY_PATH}
    # custom instructions execution
    dockerUpScript=${DockerUpScriptDirectory}/../../.utils.custom/docker/up.sh
    if [ -f "${dockerUpScript}" ]; then
        echo "${green}✔${reset} ${gray}The .utils.custom/docker/up.sh custom instructions script has been detected and executed.${reset}"
        source ${dockerUpScript}
    else
        echo "${red}✗${reset} No .utils.custom/docker/up.sh script detected."
        echo "${purple}→ docker-compose up -d ${arguments}${reset}"
        docker-compose up -d ${arguments}
    fi
    cd ${PROJECT_PATH}
    echo -e "${green}✔${reset} Docker-compose executed.\n"
}

# we execute the script treatments
startContainers
