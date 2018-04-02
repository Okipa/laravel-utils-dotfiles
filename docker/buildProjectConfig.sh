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
    cp -rf ${LARADOCK_DIRECTORY_PATH}env-example ${LARADOCK_DIRECTORY_PATH}.env
    setEnvVariableScript=${currentScriptDirectory}/../../.utils.custom/docker/setEnvVariable.sh
    if [ -f "${setEnvVariableScript}" ]; then
        source ${setEnvVariableScript}
    else
        echo -e "${red}✗${reset} No .utils.custom/docker/setEnvVariable.sh script detected\n"
    fi
}
function customizeDockerFiles () {
    if [ -f "${customizeDockerFilesScript}" ]; then
        source ${customizeDockerFilesScript}
    else
        echo -e "${red}✗${reset} No .utils.custom/docker/customizeDockerFiles.sh script detected\n"
    fi
}
function customizeDockerComposeFile () {
    # original docker-compose file copy
    if [[ ! -f ${LARADOCK_DIRECTORY_PATH}docker-compose-original.yml ]]; then
        cp -rf ${LARADOCK_DIRECTORY_PATH}docker-compose.yml ${LARADOCK_DIRECTORY_PATH}docker-compose-original.yml
    else
        cp -rf ${LARADOCK_DIRECTORY_PATH}docker-compose-original.yml ${LARADOCK_DIRECTORY_PATH}docker-compose.yml
    fi
    if [ -f "${customizeDockerComposeFileScript}" ]; then
        source ${customizeDockerComposeFileScript}
    else
        echo -e "${red}✗${reset} No .utils.custom/docker/customizeDockerComposeFileScript.sh script detected\n"
    fi
}
function setNginxConfig () {
    if [ -f "${setNginxConfigScript}" ]; then
        source ${setNginxConfigScript}
    else
        echo -e "${red}✗${reset} No .utils.custom/docker/setNginxConfigScript.sh script detected\n"
    fi
}
function buildProjectDockerConfig() {
    echo "${purple}▶${reset} Building ${APP_NAME} docker config ..."
    setEnvVariables
    customizeDockerFiles
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

# treatment
stopAndRemoveRunningContainers
buildProjectDockerConfig
