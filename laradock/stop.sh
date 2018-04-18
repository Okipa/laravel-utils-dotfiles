#!/usr/bin/env bash

# we get the current script directory
laradockStopScriptDirectory="$( cd "$(dirname "$0")" ; pwd -P )"

# we load the scripting colors
source $(realpath ${laradockStopScriptDirectory}/../helpers/loadScriptingColors.sh)

# we export the .env file variables
source $(realpath ${laradockStopScriptDirectory}/../helpers/exportEnvFileVariables.sh) --

# we check that the variables required by the script are defined
source $(realpath ${laradockStopScriptDirectory}/../helpers/checkVariableIsDefined.sh) PROJECT_PATH
source $(realpath ${laradockStopScriptDirectory}/../helpers/checkVariableIsDefined.sh) LARADOCK_DIRECTORY_PATH
source $(realpath ${laradockStopScriptDirectory}/../helpers/checkVariableIsDefined.sh) APP_NAME

# we set the script functions
function stopContainers () {
    echo -e "${gray}=================================================${reset}\n"

    echo "${purple}▶${reset} Stopping ${APP_NAME} laradock containers ..."
    cd ${LARADOCK_DIRECTORY_PATH}
    echo "${purple}→ docker-compose stop${reset}"
    docker-compose stop
    cd ${PROJECT_PATH}
    echo -e "${green}✔${reset} ${APP_NAME} laradock containers stopped.\n"
}

# we execute the script treatments
stopContainers
