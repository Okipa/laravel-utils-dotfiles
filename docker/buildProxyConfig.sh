#!/usr/bin/env bash

# we get the current script directory
DockerBuildProxyConfigScriptDirectory="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# we load the scripting colors
source $(realpath ${DockerBuildProxyConfigScriptDirectory}/../helpers/loadScriptingColors.sh)

# we export the .env file variables
source $(realpath ${DockerBuildProxyConfigScriptDirectory}/../helpers/exportEnvFileVariables.sh) --

# we check that the variables required by the script are defined
source $(realpath ${DockerBuildProxyConfigScriptDirectory}/../helpers/checkVariableIsDefined.sh) PROJECT_PATH
source $(realpath ${DockerBuildProxyConfigScriptDirectory}/../helpers/checkVariableIsDefined.sh) NGINX_DOMAIN
source $(realpath ${DockerBuildProxyConfigScriptDirectory}/../helpers/checkVariableIsDefined.sh) LARADOCK_DIRECTORY_PATH
source $(realpath ${DockerBuildProxyConfigScriptDirectory}/../helpers/checkVariableIsDefined.sh) APP_NAME

# we set the script functions
function customizeDockerComposeFile () {
    # original docker-compose file copy
    if [[ ! -f ${LARADOCK_DIRECTORY_PATH}docker-compose-original.yml ]]; then
        cp -rf ${LARADOCK_DIRECTORY_PATH}docker-compose.yml ${LARADOCK_DIRECTORY_PATH}docker-compose-original.yml
    fi
    # custom instructions execution
    customizeDockerComposeFileScript=${DockerBuildProxyConfigScriptDirectory}/../../.utils.custom/docker/buildProxyConfig/customizeDockerComposeFile.sh
    if [ -f "${customizeDockerComposeFileScript}" ]; then
        echo "${green}✔${reset} ${gray}The .utils.custom/docker/buildProxyConfig/customizeDockerComposeFile.sh custom instructions script has been detected and executed.${reset}"
        source ${customizeDockerComposeFileScript}
    else
        echo "${red}✗${reset} ${gray}No .utils.custom/docker/buildProxyConfig/customizeDockerComposeFile.sh script detected.${reset}"
    fi
}
function startDinghyNginxProxyConfig(){

    echo -e "${gray}=================================================${reset}\n"

    echo "${purple}▶${reset} Building ${purple}${APP_NAME}${reset} dinghy nging-proxy config ..."
    customizeDockerComposeFile
    echo -e "${green}✔${reset} Dinghy ${purple}${APP_NAME}${reset} nging-proxy config done.\n"
}

# we execute the script treatments
startDinghyNginxProxyConfig;
