#!/bin/bash

# we get the current script directory
laradockUpScriptDirectory=$(dirname "$(readlink -f ${BASH_SOURCE[0]})")

# we load the scripting colors
source $(realpath ${laradockUpScriptDirectory}/../helpers/loadScriptingColors.sh)

# we export the .env file variables
source $(realpath ${laradockUpScriptDirectory}/../helpers/exportEnvFileVariables.sh) --

# we check that the variables required by the script are defined
source $(realpath ${laradockUpScriptDirectory}/../helpers/checkVariableIsDefined.sh) PROJECT_PATH
source $(realpath ${laradockUpScriptDirectory}/../helpers/checkVariableIsDefined.sh) LARADOCK_DIRECTORY_PATH

# we get the script arguments
arguments=$@

# we set the script functions
function startContainers () {

    if [[ ${arguments} = *'build'* ]]; then
        echo -e "${gray}=================================================${reset}\n"
        echo "${purple}▶${reset} Stopping and removing ${APP_NAME} laradock containers ..."
        echo "${purple}→ cd ${LARADOCK_DIRECTORY_PATH}${reset}"
        cd ${LARADOCK_DIRECTORY_PATH}
        echo "${purple}→ docker-compose down --volumes --remove-orphans${reset}"
        docker-compose down --volumes --remove-orphans
        echo "${purple}→ cd ${PROJECT_PATH}${reset}"
        cd ${PROJECT_PATH}
        echo -e "${green}✔${reset} ${APP_NAME} laradock containers stopped and removed.\n"
    fi

    echo -e "${gray}=================================================${reset}\n"

    echo "${purple}▶${reset} Executing laradock docker-compose command ..."
    echo "${purple}→ cd ${LARADOCK_DIRECTORY_PATH}${reset}"
    cd ${LARADOCK_DIRECTORY_PATH}
    # custom instructions execution
    laradockUpScript=${laradockUpScriptDirectory}/../../.utils.custom/laradock/up.sh
    if [ -f "${laradockUpScript}" ]; then
        echo "${green}✔${reset} ${gray}The .utils.custom/laradock/up.sh custom instructions script has been detected and executed.${reset}"
        source ${laradockUpScript}
    else
        echo "${red}✗${reset} No .utils.custom/laradock/up.sh script detected."
        echo "${purple}→ docker-compose up -d ${arguments}${reset}"
        docker-compose up -d ${arguments}
    fi
    echo "${purple}→ cd ${PROJECT_PATH}${reset}"
    cd ${PROJECT_PATH}
    echo -e "${green}✔${reset} Laradock docker-compose executed.\n"
}

# we execute the script treatments
startContainers
