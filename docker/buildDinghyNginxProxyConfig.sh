#!/usr/bin/env bash

# we get the current script directory
currentScriptDirectory="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# we load the scripting colors
source $(realpath ${currentScriptDirectory}/../helpers/loadScriptingColors.sh)

# we set the script variables
source $(realpath ${currentScriptDirectory}/../helpers/exportEnvFileVariables.sh)
source $(realpath ${currentScriptDirectory}/../helpers/checkVariableIsDefined.sh) PROJECT_PATH
source ${PROJECT_PATH}.utils/helpers/checkVariableIsDefined.sh NGINX_DOMAIN
source ${PROJECT_PATH}.utils/helpers/checkVariableIsDefined.sh LARADOCK_DIRECTORY_PATH
source ${PROJECT_PATH}.utils/helpers/checkVariableIsDefined.sh APP_NAME

# we set the script functions
function customizeDockerComposeFile () {
    # original docker-compose file copy
    if [[ ! -f ${LARADOCK_DIRECTORY_PATH}docker-compose-original.yml ]]; then
        cp -rf ${LARADOCK_DIRECTORY_PATH}docker-compose.yml ${LARADOCK_DIRECTORY_PATH}docker-compose-original.yml
    fi
    # custom instructions execution
    customizeDockerComposeFileScript=${currentScriptDirectory}/../../.utils.custom/docker/buildDinghyNginxProxyConfig/customizeDockerComposeFile.sh
    if [ -f "${customizeDockerComposeFileScript}" ]; then
        echo "${green}✔${reset} ${gray}The .utils.custom/docker/buildDinghyNginxProxyConfig/customizeDockerComposeFile.sh custom instructions script has been detected and executed.${reset}"
        source ${customizeDockerComposeFileScript}
    else
        echo "${red}✗${reset} ${gray}No .utils.custom/docker/buildDinghyNginxProxyConfig/customizeDockerComposeFile.sh script detected.${reset}"
    fi
}
function startDinghyNginxProxyConfig(){

    echo -e "${gray}=================================================${reset}\n"

    echo "${purple}▶${reset} Building ${APP_NAME} dinghy nging-proxy config ..."
    customizeDockerComposeFile
    echo -e "${green}✔${reset} Dinghy ${APP_NAME} nging-proxy config done.\n"
}

# we execute the script treatments
startDinghyNginxProxyConfig;
