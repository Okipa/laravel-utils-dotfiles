#!/usr/bin/env bash

# we get the current script directory
DockerBuildProjectConfigScriptDirectory="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# we load the scripting colors
source $(realpath ${DockerBuildProjectConfigScriptDirectory}/../helpers/loadScriptingColors.sh)

# we export the .env file variables
source $(realpath ${DockerBuildProjectConfigScriptDirectory}/../helpers/exportEnvFileVariables.sh) --

# we check that the variables required by the script are defined
source $(realpath ${DockerBuildProjectConfigScriptDirectory}/../helpers/checkVariableIsDefined.sh) PROJECT_PATH
source $(realpath ${DockerBuildProjectConfigScriptDirectory}/../helpers/checkVariableIsDefined.sh) NGINX_DOMAIN
source $(realpath ${DockerBuildProjectConfigScriptDirectory}/../helpers/checkVariableIsDefined.sh) LARADOCK_DIRECTORY_PATH
source $(realpath ${DockerBuildProjectConfigScriptDirectory}/../helpers/checkVariableIsDefined.sh) NGINX_HTTP_PORT
source $(realpath ${DockerBuildProjectConfigScriptDirectory}/../helpers/checkVariableIsDefined.sh) NGINX_HTTPS_PORT
source $(realpath ${DockerBuildProjectConfigScriptDirectory}/../helpers/checkVariableIsDefined.sh) APP_NAME

# we set the script functions
function setEnvVariables () {
    # .env file override from the env-example file
    cp -rf ${LARADOCK_DIRECTORY_PATH}env-example ${LARADOCK_DIRECTORY_PATH}.env
    # custom instructions execution
    setEnvVariablesScript=${DockerBuildProjectConfigScriptDirectory}/../../.utils.custom/docker/buildProjectConfig/setEnvVariables.sh
    if [ -f "${setEnvVariablesScript}" ]; then
        echo "${green}✔${reset} ${gray}The .utils.custom/docker/buildProjectConfig/setEnvVariable.sh custom instructions script has been detected and executed.${reset}"
        source ${setEnvVariablesScript}
    else
        echo "${red}✗${reset} No .utils.custom/docker/buildProjectConfig/setEnvVariables.sh script detected."
    fi
}
function customizeContainers () {
    # custom instructions execution
    customizeContainersScript=${DockerBuildProjectConfigScriptDirectory}/../../.utils.custom/docker/buildProjectConfig/customizeContainers.sh
    if [ -f "${customizeContainersScript}" ]; then
        echo "${green}✔${reset} ${gray}The .utils.custom/docker/buildProjectConfig/customizeContainers.sh custom instructions script has been detected and executed.${reset}"
        source ${customizeContainersScript}
    else
        echo "${red}✗${reset} ${gray}No .utils.custom/docker/buildProjectConfig/customizeContainers.sh script detected.${reset}"
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
    customizeDockerComposeFileScript=${DockerBuildProjectConfigScriptDirectory}/../../.utils.custom/docker/buildProjectConfig/customizeDockerComposeFile.sh
    if [ -f "${customizeDockerComposeFileScript}" ]; then
        echo "${gray}✔${reset} ${gray}The .utils.custom/docker/buildProjectConfig/customizeDockerComposeFile.sh custom instructions script has been detected and executed.${reset}"
        source ${customizeDockerComposeFileScript}
    else
        echo "${red}✗${reset} ${gray}No .utils.custom/docker/buildProjectConfig/customizeDockerComposeFile.sh script detected.${reset}"
    fi
}
function setNginxConfig () {
    setNginxConfigScript=${DockerBuildProjectConfigScriptDirectory}/../../.utils.custom/docker/buildProjectConfig/setNginxConfig.sh
    if [ -f "${setNginxConfigScript}" ]; then
        echo "${green}✔${reset} ${gray}The .utils.custom/docker/buildProjectConfig/setNginxConfig.sh custom instructions script has been detected and executed.${reset}"
        source ${setNginxConfigScript}
    else
        echo "${red}✗${reset} ${gray}No .utils.custom/docker/buildProjectConfig/setNginxConfig.sh script detected.${reset}"
    fi
}
function buildProjectDockerConfig() {
    echo -e "${gray}=================================================${reset}\n"

    echo "${purple}▶${reset} Building ${APP_NAME} docker config ..."
    setEnvVariables
    customizeContainers
    customizeDockerComposeFile
    setNginxConfig
    echo -e "${green}✔${reset} ${envFilePath} ${APP_NAME} docker config done.\n"
}
function stopAndRemoveRunningContainers() {
    echo -e "${gray}=================================================${reset}\n"

    echo "${purple}▶${reset} Stopping and removing ${APP_NAME} containers ..."
    cd ${LARADOCK_DIRECTORY_PATH}
    echo "${purple}→ docker-compose stop${reset}"
    docker-compose stop
    echo "${purple}→ docker-compose rm -f${reset}"
    docker-compose rm -f
    cd ${PROJECT_PATH}
    echo -e "${green}✔${reset} ${APP_NAME} containers stopped and removed.\n"
}

# we execute the script treatments
stopAndRemoveRunningContainers
buildProjectDockerConfig
