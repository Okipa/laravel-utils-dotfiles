#!/usr/bin/env bash

# we get the current script directory
currentScriptDirectory="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# we load the scripting colors
source $(realpath ${currentScriptDirectory}/../helpers/loadScriptingColors.sh)

# we export the .env file variables
source $(realpath ${currentScriptDirectory}/../helpers/exportEnvFileVariables.sh) --

# we check that the variables required by the script are defined
source $(realpath ${currentScriptDirectory}/../helpers/checkVariableIsDefined.sh) PROJECT_PATH
source $(realpath ${currentScriptDirectory}/../helpers/checkVariableIsDefined.sh) LARADOCK_DIRECTORY_PATH
source $(realpath ${currentScriptDirectory}/../helpers/checkVariableIsDefined.sh) APP_NAME

# we set the script functions
function stopContainers () {
    echo "${purple}▶${reset} Stopping ${APP_NAME} containers ..."
    cd ${LARADOCK_DIRECTORY_PATH}
    echo "${purple}→ docker-compose stop${reset}"
    docker-compose stop
    cd ${PROJECT_PATH}
    echo -e "${green}✔${reset} ${APP_NAME} stopped.\n"
}

# we execute the script treatments
stopContainers
