#!/usr/bin/env bash

# example

## domain
#sed 's#server_name laravel.test;#server_name '${NGINX_DOMAIN}';#g' ${LARADOCK_DIRECTORY_PATH}nginx/sites/laravel.conf.example > ${LARADOCK_DIRECTORY_PATH}nginx/sites/${NGINX_DOMAIN}.conf
#sed -i 's#root /var/www/laravel/public;#root /var/www/public;#g' ${LARADOCK_DIRECTORY_PATH}nginx/sites/${NGINX_DOMAIN}.conf
