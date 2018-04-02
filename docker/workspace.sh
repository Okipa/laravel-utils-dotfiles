#!/usr/bin/env bash

# we get the current script directory
currentScriptDirectory="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# we set the script variables
source $(realpath ${currentScriptDirectory}/../helpers/exportEnvFileVariables.sh)
source $(realpath ${currentScriptDirectory}/../helpers/checkVariableIsDefined.sh) PROJECT_PATH
source ${PROJECT_PATH}.utils/helpers/checkVariableIsDefined.sh LARADOCK_DIRECTORY_PATH
arguments=$@
user='laradock'

# arguments
if [[ ${arguments} = *'root'* ]]; then
    user='root'
fi

# we set the script functions
function accessToWorkspaceSsh () {
    cd ${LARADOCK_DIRECTORY_PATH}
    docker-compose exec --user=${user} workspace bash
    cd ${PROJECT_PATH}
}

# treatment
accessToWorkspaceSsh
