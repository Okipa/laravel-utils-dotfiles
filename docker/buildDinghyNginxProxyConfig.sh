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
source ${PROJECT_PATH}.utils/helpers/checkVariableIsDefined.sh APP_NAME

# we set the script functions
function customizeDockerComposeFile () {
    # original docker-compose file copy
    if [[ ! -f ${LARADOCK_DIRECTORY_PATH}docker-compose-original.yml ]]; then
        cp -rf ${LARADOCK_DIRECTORY_PATH}docker-compose.yml ${LARADOCK_DIRECTORY_PATH}docker-compose-original.yml
    fi
    # nginx server container
    sed -i ':a;N;$!ba;s/ports:\n\        - "${NGINX_HOST_HTTP_PORT}:80"\n\        - "${NGINX_HOST_HTTPS_PORT}:443"\n\      depends_on:\n\        - php-fpm\n\      networks:\n\        - frontend\n\        - backend/ports:\n\        - "${NGINX_HOST_HTTP_PORT}:80"\n\        - "${NGINX_HOST_HTTPS_PORT}:443"\n\      depends_on:\n\        - php-fpm\n\      networks:\n\        - frontend\n\        - backend\n\        - nginx-proxy\n\      environment:\n\        - VIRTUAL_HOST='${NGINX_DOMAIN}'/g' ${LARADOCK_DIRECTORY_PATH}docker-compose.yml
    # network setup
    sed -i ':a;N;$!ba;s/networks:\n\  frontend:\n\    driver: "bridge"\n\  backend:\n\    driver: "bridge"/networks:\n\  frontend:\n\    driver: "bridge"\n\  backend:\n\    driver: "bridge"\n\  nginx-proxy:\n\    external:\n\      name: nginx-proxy/g' ${LARADOCK_DIRECTORY_PATH}docker-compose.yml
}
function startDinghyNginxProxyConfig(){
    echo "${purple}▶${reset} Building ${APP_NAME} dinghy nging-proxy config ..."
    customizeDockerComposeFile
    echo -e "${green}✔${reset} Dinghy ${APP_NAME} nging-proxy config done.\n"
}

# treatment
startDinghyNginxProxyConfig;
