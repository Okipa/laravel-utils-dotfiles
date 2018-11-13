#!/bin/bash

dockerStopScriptDirectory=$(dirname "$(readlink -f ${BASH_SOURCE[0]})")

source $(realpath ${dockerStopScriptDirectory}/../helpers/loadScriptingColors.sh)

source $(realpath ${dockerStopScriptDirectory}/../helpers/exportEnvFileVariables.sh) --

source $(realpath ${dockerStopScriptDirectory}/../helpers/checkVariableIsDefined.sh) PROJECT_PATH
source $(realpath ${dockerStopScriptDirectory}/../helpers/checkVariableIsDefined.sh) DOCKER_DIRECTORY_PATH
source $(realpath ${dockerStopScriptDirectory}/../helpers/checkVariableIsDefined.sh) APP_NAME

function stopContainers () {
    echo -e "${gray}=================================================${reset}\n"

    echo "${purple}▶${reset} Stopping ${APP_NAME} docker containers ..."
    cd ${DOCKER_DIRECTORY_PATH}
    echo "${purple}→ docker-compose stop${reset}"
    docker-compose stop
    cd ${PROJECT_PATH}
    echo -e "${green}✔${reset} ${APP_NAME} docker containers stopped.\n"
}

stopContainers
