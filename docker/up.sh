#!/bin/bash

# we get the current script directory
dockerUpScriptDirectory=$(dirname "$(readlink -f ${BASH_SOURCE[0]})")

# we load the scripting colors
source $(realpath ${dockerUpScriptDirectory}/../helpers/loadScriptingColors.sh)

# we export the .env file variables
source $(realpath ${dockerUpScriptDirectory}/../helpers/exportEnvFileVariables.sh) --

# we check that the variables required by the script are defined
source $(realpath ${dockerUpScriptDirectory}/../helpers/checkVariableIsDefined.sh) PROJECT_PATH
source $(realpath ${dockerUpScriptDirectory}/../helpers/checkVariableIsDefined.sh) DOCKER_DIRECTORY_PATH

# we get the script arguments
arguments=$@

# we set the script functions
function startContainers () {

    if [[ ${arguments} = *'build'* || ${arguments} = *'force-recreate'* ]]; then
        echo -e "${gray}=================================================${reset}\n"
        echo "${purple}▶${reset} Stopping and removing ${APP_NAME} docker containers and volumes ..."
        echo "${purple}→ cd ${DOCKER_DIRECTORY_PATH}${reset}"
        cd ${DOCKER_DIRECTORY_PATH}
        echo "${purple}→ docker-compose down --volumes --remove-orphans${reset}"
        docker-compose down --volumes --remove-orphans
        echo "${purple}→ cd ${PROJECT_PATH}${reset}"
        cd ${PROJECT_PATH}
        echo -e "${green}✔${reset} ${APP_NAME} docker containers and volumes stopped and removed.\n"
    fi

    echo -e "${gray}=================================================${reset}\n"

    echo "${purple}▶${reset} Executing docker-compose command ..."
    echo "${purple}→ cd ${DOCKER_DIRECTORY_PATH}${reset}"
    cd ${DOCKER_DIRECTORY_PATH}
    # custom instructions execution
    dockerUpScript=${dockerUpScriptDirectory}/../../.utils.custom/docker/up.sh
    if [ -f "${dockerUpScript}" ]; then
        echo "${green}✔${reset} ${gray}The .utils.custom/docker/up.sh custom instructions script has been detected and executed.${reset}"
        source ${dockerUpScript}
    else
        echo "${red}✗${reset} No .utils.custom/docker/up.sh script detected."
        echo "${purple}→ docker-compose up -d ${arguments}${reset}"
        docker-compose up -d ${arguments}
    fi
    echo "${purple}→ cd ${PROJECT_PATH}${reset}"
    cd ${PROJECT_PATH}
    echo -e "${green}✔${reset} docker-compose command executed.\n"
}

# we execute the script treatments
startContainers
