#!/bin/bash

dockerUpScriptDirectory=$(dirname "$(readlink -f ${BASH_SOURCE[0]})")

source $(realpath ${dockerUpScriptDirectory}/../helpers/loadScriptingColors.sh)

source $(realpath ${dockerUpScriptDirectory}/../helpers/exportEnvFileVariables.sh) --

source $(realpath ${dockerUpScriptDirectory}/../helpers/checkVariableIsDefined.sh) APP_NAME
source $(realpath ${dockerUpScriptDirectory}/../helpers/checkVariableIsDefined.sh) PROJECT_PATH
source $(realpath ${dockerUpScriptDirectory}/../helpers/checkVariableIsDefined.sh) DOCKER_DIRECTORY_PATH

arguments=$@

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

    echo "${purple}▶${reset} Moving to ${APP_NAME} docker directory ..."
    echo "${purple}→ cd ${DOCKER_DIRECTORY_PATH}${reset}"
    cd ${DOCKER_DIRECTORY_PATH}
    echo -e "${green}✔${reset} Moved to ${APP_NAME} ${DOCKER_DIRECTORY_PATH} directory.\n"
    
    dockerUpScriptPath=${dockerUpScriptDirectory}/../.utils.custom/docker/up.sh
    source $(realpath ${dockerUpScriptPath}/../helpers/checkFileExists.sh) ${dockerUpScriptPath}
    source ${dockerUpScriptPath}
    
    echo -e "${gray}=================================================${reset}\n"
    
    echo "${purple}▶${reset} Moving back to ${APP_NAME} project directory ..."
    cd ${PROJECT_PATH}
    echo -e "${green}✔${reset} Moved back to ${APP_NAME} project directory.\n"
}

# we execute the script treatments
startContainers
