#!/usr/bin/env bash

# colors
purple=`tput setaf 12`
gray=`tput setaf 8`
green=`tput setaf 2`
red=`tput setaf 1`
reset=`tput sgr0`

# we set the script variables
currentScriptPath="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $(realpath ${currentScriptPath}/../helpers/exportEnvFileVariables.sh)
source $(realpath ${currentScriptPath}/../helpers/checkVariableIsDefined.sh) PROJECT_PATH
source ${PROJECT_PATH}.utils/helpers/checkVariableIsDefined.sh LARADOCK_DIRECTORY_PATH
source ${PROJECT_PATH}.utils/helpers/checkVariableIsDefined.sh APP_NAME

# we set the script functions
function stopContainers () {
    echo "${purple}▶${reset} Stopping ${APP_NAME} containers ..."
    cd ${LARADOCK_DIRECTORY_PATH}
    docker-compose stop
    cd ${PROJECT_PATH}
    echo -e "${green}✔${reset} ${APP_NAME} stopped.\n"
}

# treatment
stopContainers
