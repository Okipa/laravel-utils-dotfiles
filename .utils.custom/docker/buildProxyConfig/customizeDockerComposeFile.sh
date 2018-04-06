#!/usr/bin/env bash

# example

## nginx server container
#sed -i ':a;N;$!ba;s/ports:\n\        - "${NGINX_HOST_HTTP_PORT}:80"\n\        - "${NGINX_HOST_HTTPS_PORT}:443"\n\      depends_on:\n\        - php-fpm\n\      networks:\n\        - frontend\n\        - backend/ports:\n\        - "${NGINX_HOST_HTTP_PORT}:80"\n\        - "${NGINX_HOST_HTTPS_PORT}:443"\n\      depends_on:\n\        - php-fpm\n\      networks:\n\        - frontend\n\        - backend\n\        - nginx-proxy\n\      environment:\n\        - VIRTUAL_HOST='${NGINX_DOMAIN}'/g' ${LARADOCK_DIRECTORY_PATH}docker-compose.yml
## network setup
#sed -i ':a;N;$!ba;s/networks:\n\  frontend:\n\    driver: "bridge"\n\  backend:\n\    driver: "bridge"/networks:\n\  frontend:\n\    driver: "bridge"\n\  backend:\n\    driver: "bridge"\n\  nginx-proxy:\n\    external:\n\      name: nginx-proxy/g' ${LARADOCK_DIRECTORY_PATH}docker-compose.yml
