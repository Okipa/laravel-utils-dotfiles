#!/usr/bin/env bash

# colors
purple=`tput setaf 12`
gray=`tput setaf 8`
green=`tput setaf 2`
red=`tput setaf 1`
reset=`tput sgr0`

# we set the script variables
currentScriptPath="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $(realpath ${currentScriptPath}/../helpers/exportEnvFileVariables.sh)
source $(realpath ${currentScriptPath}/../helpers/checkVariableIsDefined.sh) PROJECT_PATH
source ${PROJECT_PATH}.utils/helpers/checkVariableIsDefined.sh NGINX_DOMAIN
source ${PROJECT_PATH}.utils/helpers/checkVariableIsDefined.sh LARADOCK_DIRECTORY_PATH
source ${PROJECT_PATH}.utils/helpers/checkVariableIsDefined.sh NGINX_HTTP_PORT
source ${PROJECT_PATH}.utils/helpers/checkVariableIsDefined.sh NGINX_HTTPS_PORT
source ${PROJECT_PATH}.utils/helpers/checkVariableIsDefined.sh APP_NAME

# we set the script functions
function setEnvVariables () {
    cp -rf ${LARADOCK_DIRECTORY_PATH}env-example ${LARADOCK_DIRECTORY_PATH}.env
    sed -i 's/PHP_VERSION=72/PHP_VERSION=71/g' ${LARADOCK_DIRECTORY_PATH}.env
    sed -i 's/WORKSPACE_INSTALL_XDEBUG=false/WORKSPACE_INSTALL_XDEBUG=true/g' ${LARADOCK_DIRECTORY_PATH}.env
    sed -i 's/WORKSPACE_INSTALL_NODE=false/WORKSPACE_INSTALL_NODE=true/g' ${LARADOCK_DIRECTORY_PATH}.env
    sed -i 's/WORKSPACE_INSTALL_YARN=false/WORKSPACE_INSTALL_YARN=true/g' ${LARADOCK_DIRECTORY_PATH}.env
    sed -i 's/WORKSPACE_INSTALL_PYTHON=false/WORKSPACE_INSTALL_PYTHON=true/g' ${LARADOCK_DIRECTORY_PATH}.env
    sed -i 's/WORKSPACE_INSTALL_IMAGE_OPTIMIZERS=false/WORKSPACE_INSTALL_IMAGE_OPTIMIZERS=true/g' ${LARADOCK_DIRECTORY_PATH}.env
    sed -i 's/PHP_FPM_INSTALL_XDEBUG=false/PHP_FPM_INSTALL_XDEBUG=true/g' ${LARADOCK_DIRECTORY_PATH}.env
    sed -i 's/PHP_FPM_INSTALL_IMAGE_OPTIMIZERS=false/PHP_FPM_INSTALL_IMAGE_OPTIMIZERS=true/g' ${LARADOCK_DIRECTORY_PATH}.env
    sed -i 's/NGINX_HOST_HTTP_PORT=80/NGINX_HOST_HTTP_PORT='${NGINX_HTTP_PORT}'/g' ${LARADOCK_DIRECTORY_PATH}.env
    sed -i 's/NGINX_HOST_HTTPS_PORT=443/NGINX_HOST_HTTPS_PORT='${NGINX_HTTPS_PORT}'/g' ${LARADOCK_DIRECTORY_PATH}.env
    sed -i 's/MYSQL_VERSION=latest/MYSQL_VERSION=5.5/g' ${LARADOCK_DIRECTORY_PATH}.env
    sed -i 's/MYSQL_DATABASE=default/MYSQL_DATABASE=practiceo/g' ${LARADOCK_DIRECTORY_PATH}.env
    sed -i 's/MYSQL_USER=default/MYSQL_USER=practiceo/g' ${LARADOCK_DIRECTORY_PATH}.env
}
function customizeDockerFiles () {
    # original dockerfiles copy
    if [[ ! -f ${LARADOCK_DIRECTORY_PATH}workspace/Dockerfile-71-original ]]; then
        cp -rf ${LARADOCK_DIRECTORY_PATH}workspace/Dockerfile-71 ${LARADOCK_DIRECTORY_PATH}workspace/Dockerfile-71-original
    else
        cp -rf ${LARADOCK_DIRECTORY_PATH}workspace/Dockerfile-71-original ${LARADOCK_DIRECTORY_PATH}workspace/Dockerfile-71
    fi
    if [[ ! -f ${LARADOCK_DIRECTORY_PATH}php-fpm/Dockerfile-71-original ]]; then
        cp -rf ${LARADOCK_DIRECTORY_PATH}php-fpm/Dockerfile-71 ${LARADOCK_DIRECTORY_PATH}php-fpm/Dockerfile-71-original
    else
        cp -rf ${LARADOCK_DIRECTORY_PATH}php-fpm/Dockerfile-71-original ${LARADOCK_DIRECTORY_PATH}php-fpm/Dockerfile-71
    fi
    # add mysql client
    sed -i ':a;N;$!ba;s=    ln -s /etc/php/7.1/mods-available/swoole.ini /etc/php/7.1/cli/conf.d/20-swoole.ini \\\n;fi=    ln -s /etc/php/7.1/mods-available/swoole.ini /etc/php/7.1/cli/conf.d/20-swoole.ini \\\n;fi\n\n\#####################################\n\# MySQL Client\n\#####################################\nUSER root\n\RUN apt-get update -yqq \&\& \\\n\    apt-get -y install mysql-client=' ${LARADOCK_DIRECTORY_PATH}workspace/Dockerfile-71
}
function customizeDockerComposeFile () {
    # original docker-compose file copy
    if [[ ! -f ${LARADOCK_DIRECTORY_PATH}docker-compose-original.yml ]]; then
        cp -rf ${LARADOCK_DIRECTORY_PATH}docker-compose.yml ${LARADOCK_DIRECTORY_PATH}docker-compose-original.yml
    else
        cp -rf ${LARADOCK_DIRECTORY_PATH}docker-compose-original.yml ${LARADOCK_DIRECTORY_PATH}docker-compose.yml
    fi
    # workspace WORKSPACE_SSH_PORT removal
    sed -i ':a;N;$!ba;s/      extra_hosts:\n\        - "dockerhost:${DOCKER_HOST_IP}"\n\      ports:\n\        - "${WORKSPACE_SSH_PORT}:22"/      extra_hosts:\n\        - "dockerhost:${DOCKER_HOST_IP}"/' ${LARADOCK_DIRECTORY_PATH}docker-compose.yml
}
function setNginxConfig () {
    # domain
    sed 's#server_name laravel.test;#server_name '${NGINX_DOMAIN}';#g' ${LARADOCK_DIRECTORY_PATH}nginx/sites/laravel.conf.example > ${LARADOCK_DIRECTORY_PATH}nginx/sites/${NGINX_DOMAIN}.conf
    sed -i 's#root /var/www/laravel/public;#root /var/www/public;#g' ${LARADOCK_DIRECTORY_PATH}nginx/sites/${NGINX_DOMAIN}.conf
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
