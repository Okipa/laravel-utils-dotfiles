#!/bin/bash

dockerWorkspaceScriptDirectory=$(dirname "$(readlink -f ${BASH_SOURCE[0]})")

source $(realpath ${dockerWorkspaceScriptDirectory}/../helpers/exportEnvFileVariables.sh) --

source $(realpath ${dockerWorkspaceScriptDirectory}/../helpers/checkVariableIsDefined.sh) PROJECT_PATH
source $(realpath ${dockerWorkspaceScriptDirectory}/../helpers/checkVariableIsDefined.sh) DOCKER_DIRECTORY_PATH

arguments=$@

setRequiredVariablesScriptPath=${dockerWorkspaceScriptDirectory}/../../.utils.custom/docker/workspace/setRequiredVariables.sh
source $(realpath ${dockerWorkspaceScriptDirectory}/../helpers/checkFileExists.sh) ${setRequiredVariablesScriptPath}
source ${setRequiredVariablesScriptPath}
source $(realpath ${dockerWorkspaceScriptDirectory}/../helpers/checkVariableIsDefined.sh) dockerUser

if [[ ${arguments} = *'root'* ]]; then
    dockerUser='root'
fi

function accessToWorkspaceSsh () {
    echo -e "${gray}=================================================${reset}\n"

    echo "${purple}▶${reset} Moving to ${APP_NAME} docker directory ..."
    echo "${purple}→ cd ${DOCKER_DIRECTORY_PATH}${reset}"
    cd ${DOCKER_DIRECTORY_PATH}
    echo -e "${green}✔${reset} Moved to ${APP_NAME} ${DOCKER_DIRECTORY_PATH} directory.\n"
    
    echo -e "${gray}=================================================${reset}\n"
    
    echo "${purple}▶${reset} Accessing to the ${APP_NAME} workspace container with the ${dockerUser} user ..."
    echo "${purple}→ docker-compose exec --user=${dockerUser} workspace bash${reset}"
    docker-compose exec --user=${dockerUser} workspace bash
    echo -e "${green}✔${reset} Accessed to the ${APP_NAME} workspace container.\n"
    
    echo -e "${gray}=================================================${reset}\n"
    
    echo "${purple}▶${reset} Moving back to ${APP_NAME} project directory ..."
    cd ${PROJECT_PATH}
    echo -e "${green}✔${reset} Moved back to ${APP_NAME} project directory.\n"
}

# we execute the script treatments
accessToWorkspaceSsh
