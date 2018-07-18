#!/bin/bash

# we get the current script directory
dockerWorkspaceScriptDirectory=$(dirname "$(readlink -f ${BASH_SOURCE[0]})")

# we export the .env file variables
source $(realpath ${dockerWorkspaceScriptDirectory}/../helpers/exportEnvFileVariables.sh) --

# we check that the variables required by the script are defined
source $(realpath ${dockerWorkspaceScriptDirectory}/../helpers/checkVariableIsDefined.sh) PROJECT_PATH
source $(realpath ${dockerWorkspaceScriptDirectory}/../helpers/checkVariableIsDefined.sh) DOCKER_DIRECTORY_PATH

# we set the script variables
arguments=$@

# we set the script required variables
setRequiredVariablesScript=${dockerWorkspaceScriptDirectory}/../../../.utils.custom/docker/workspace/setRequiredVariables.sh
if [ -f "${setRequiredVariablesScript}" ]; then
    echo -e "${green}✔${reset} ${gray}The .utils.custom/docker/workspace/setRequiredVariables.sh custom instructions script has been detected and executed.${reset}\n"
    source ${setRequiredVariablesScript}
else
    echo -e "${red}✗${reset} ${gray}No .utils.custom/docker/workspace/setRequiredVariables.sh script detected.${reset}\n"
fi
source $(realpath ${dockerWorkspaceScriptDirectory}/../../helpers/checkVariableIsDefined.sh) dockerUser

# arguments
if [[ ${arguments} = *'root'* ]]; then
    dockerUser='root'
fi

# we set the script functions
function accessToWorkspaceSsh () {
    echo -e "${gray}=================================================${reset}\n"

    echo "${purple}▶${reset} Accessing to docker workspace container ..."
    echo "${purple}→ cd ${DOCKER_DIRECTORY_PATH}${reset}"
    cd ${DOCKER_DIRECTORY_PATH}
    echo "${purple}→ docker-compose exec --user=${dockerUser} workspace bash${reset}"
    docker-compose exec --user=${dockerUser} workspace bash
    echo "${purple}→ cd ${PROJECT_PATH}${reset}"
    cd ${PROJECT_PATH}
}

# we execute the script treatments
accessToWorkspaceSsh
