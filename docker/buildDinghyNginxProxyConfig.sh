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
    # nginx server container
    sed -i ':a;N;$!ba;s/ports:\n\        - "${NGINX_HOST_HTTP_PORT}:80"\n\        - "${NGINX_HOST_HTTPS_PORT}:443"\n\      depends_on:\n\        - php-fpm\n\      networks:\n\        - frontend\n\        - backend/ports:\n\        - "${NGINX_HOST_HTTP_PORT}:80"\n\        - "${NGINX_HOST_HTTPS_PORT}:443"\n\      depends_on:\n\        - php-fpm\n\      networks:\n\        - frontend\n\        - backend\n\        - nginx-proxy\n\      environment:\n\        - VIRTUAL_HOST='${NGINX_DOMAIN}'/g' ${LARADOCK_DIRECTORY_PATH}docker-compose.yml
    # network setup
    sed -i ':a;N;$!ba;s/networks:\n\  frontend:\n\    driver: "bridge"\n\  backend:\n\    driver: "bridge"/networks:\n\  frontend:\n\    driver: "bridge"\n\  backend:\n\    driver: "bridge"\n\  nginx-proxy:\n\    external:\n\      name: nginx-proxy/g' ${LARADOCK_DIRECTORY_PATH}docker-compose.yml
}
function startDinghyNginxProxyConfig(){

    echo -e "${gray}=================================================${reset}\n"

    echo "${purple}▶${reset} Building ${APP_NAME} dinghy nging-proxy config ..."
    customizeDockerComposeFile
    echo -e "${green}✔${reset} Dinghy ${APP_NAME} nging-proxy config done.\n"
}

# we execute the script treatments
startDinghyNginxProxyConfig;
