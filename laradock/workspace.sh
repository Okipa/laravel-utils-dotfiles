#!/usr/bin/env bash

# we get the current script directory
laradockWorkspaceScriptDirectory="$( cd "$(dirname "$0")" ; pwd -P )"

# we export the .env file variables
source $(realpath ${laradockWorkspaceScriptDirectory}/../helpers/exportEnvFileVariables.sh) --

# we check that the variables required by the script are defined
source $(realpath ${laradockWorkspaceScriptDirectory}/../helpers/checkVariableIsDefined.sh) PROJECT_PATH
source $(realpath ${laradockWorkspaceScriptDirectory}/../helpers/checkVariableIsDefined.sh) LARADOCK_DIRECTORY_PATH

# we set the script variables
arguments=$@
user='laradock'

# arguments
if [[ ${arguments} = *'root'* ]]; then
    user='root'
fi

# we set the script functions
function accessToWorkspaceSsh () {
    echo -e "${gray}=================================================${reset}\n"

    echo "${purple}▶${reset} Accessing to laradock workspace container ..."
    echo "${purple}→ cd ${LARADOCK_DIRECTORY_PATH}${reset}"
    cd ${LARADOCK_DIRECTORY_PATH}
    echo "${purple}→ docker-compose exec --user=${user} workspace bash${reset}"
    docker-compose exec --user=${user} workspace bash
    echo "${purple}→ cd ${PROJECT_PATH}${reset}"
    cd ${PROJECT_PATH}
}

# we execute the script treatments
accessToWorkspaceSsh
