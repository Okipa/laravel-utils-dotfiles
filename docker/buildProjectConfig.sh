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
source ${PROJECT_PATH}.utils/helpers/checkVariableIsDefined.sh NGINX_HTTP_PORT
source ${PROJECT_PATH}.utils/helpers/checkVariableIsDefined.sh NGINX_HTTPS_PORT
source ${PROJECT_PATH}.utils/helpers/checkVariableIsDefined.sh APP_NAME

# we set the script functions
function setEnvVariables () {
    # .env file override from the env-example file
    cp -rf ${LARADOCK_DIRECTORY_PATH}env-example ${LARADOCK_DIRECTORY_PATH}.env
    # custom instructions execution
    setEnvVariablesScript=${currentScriptDirectory}/../../.utils.custom/docker/setEnvVariables.sh
    if [ -f "${setEnvVariablesScript}" ]; then
        echo -e "${green}✔${reset} The .utils.custom/docker/setEnvVariable.sh custom instructions script has been detected.\n"
        source ${setEnvVariablesScript}
    else
        echo -e "${red}✗${reset} No .utils.custom/docker/setEnvVariables.sh script detected;\n"
    fi
}
function customizeContainers () {
    # custom instructions execution
    customizeContainersScript=${currentScriptDirectory}/../../.utils.custom/docker/customizeContainers.sh
    if [ -f "${customizeContainersScript}" ]; then
        echo -e "${green}✔${reset} The .utils.custom/docker/customizeContainers.sh custom instructions script has been detected.\n"
        source ${customizeContainersScript}
    else
        echo -e "${red}✗${reset} No .utils.custom/docker/customizeContainers.sh script detected.\n"
    fi
}
function customizeDockerComposeFile () {
    # original docker-compose file copy
    if [[ ! -f ${LARADOCK_DIRECTORY_PATH}docker-compose-original.yml ]]; then
        cp -rf ${LARADOCK_DIRECTORY_PATH}docker-compose.yml ${LARADOCK_DIRECTORY_PATH}docker-compose-original.yml
    else
        cp -rf ${LARADOCK_DIRECTORY_PATH}docker-compose-original.yml ${LARADOCK_DIRECTORY_PATH}docker-compose.yml
    fi
    # custom instructions execution
    customizeDockerComposeFileScript=${currentScriptDirectory}/../../.utils.custom/docker/customizeDockerComposeFile.sh
    if [ -f "${customizeDockerComposeFileScript}" ]; then
        echo -e "${green}✔${reset} The .utils.custom/docker/customizeDockerComposeFile.sh custom instructions script has been detected.\n"
        source ${customizeDockerComposeFileScript}
    else
        echo -e "${red}✗${reset} No .utils.custom/docker/customizeDockerComposeFile.sh script detected.\n"
    fi
}
function setNginxConfig () {
    setNginxConfigScript=${currentScriptDirectory}/../../.utils.custom/docker/setNginxConfig.sh
    if [ -f "${setNginxConfigScript}" ]; then
        source ${setNginxConfigScript}
    else
        echo -e "${red}✗${reset} No .utils.custom/docker/setNginxConfig.sh script detected.\n"
    fi
}
function buildProjectDockerConfig() {
    echo "${purple}▶${reset} Building ${APP_NAME} docker config ..."
    setEnvVariables
    customizeContainers
    customizeDockerComposeFile
    setNginxConfig
    echo -e "${green}✔${reset} ${envFilePath} ${APP_NAME} docker config done.\n"
}
function stopAndRemoveRunningContainers() {
    echo "${purple}▶${reset} Stopping and removing ${APP_NAME} containers ..."
    cd ${LARADOCK_DIRECTORY_PATH}
    docker-compose stop
    docker-compose rm -f
    cd ${PROJECT_PATH}
    echo -e "${green}✔${reset} ${APP_NAME} containers stopped and removed.\n"
}

# we execute the script treatments
stopAndRemoveRunningContainers
buildProjectDockerConfig
