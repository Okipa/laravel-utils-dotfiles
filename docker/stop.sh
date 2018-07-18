#!/bin/bash

# we get the current script directory
dockerStopScriptDirectory=$(dirname "$(readlink -f ${BASH_SOURCE[0]})")

# we load the scripting colors
source $(realpath ${dockerStopScriptDirectory}/../helpers/loadScriptingColors.sh)

# we export the .env file variables
source $(realpath ${dockerStopScriptDirectory}/../helpers/exportEnvFileVariables.sh) --

# we check that the variables required by the script are defined
source $(realpath ${dockerStopScriptDirectory}/../helpers/checkVariableIsDefined.sh) PROJECT_PATH
source $(realpath ${dockerStopScriptDirectory}/../helpers/checkVariableIsDefined.sh) DOCKER_DIRECTORY_PATH
source $(realpath ${dockerStopScriptDirectory}/../helpers/checkVariableIsDefined.sh) APP_NAME

# we set the script functions
function stopContainers () {
    echo -e "${gray}=================================================${reset}\n"

    echo "${purple}▶${reset} Stopping ${APP_NAME} docker containers ..."
    cd ${DOCKER_DIRECTORY_PATH}
    echo "${purple}→ docker-compose stop${reset}"
    docker-compose stop
    cd ${PROJECT_PATH}
    echo -e "${green}✔${reset} ${APP_NAME} docker containers stopped.\n"
}

# we execute the script treatments
stopContainers
