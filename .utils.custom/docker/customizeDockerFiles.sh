#!/usr/bin/env bash

# example

# original dockerfiles copy
#if [[ ! -f ${LARADOCK_DIRECTORY_PATH}workspace/Dockerfile-71-original ]]; then
#    cp -rf ${LARADOCK_DIRECTORY_PATH}workspace/Dockerfile-71 ${LARADOCK_DIRECTORY_PATH}workspace/Dockerfile-71-original
#else
#    cp -rf ${LARADOCK_DIRECTORY_PATH}workspace/Dockerfile-71-original ${LARADOCK_DIRECTORY_PATH}workspace/Dockerfile-71
#fi
#if [[ ! -f ${LARADOCK_DIRECTORY_PATH}php-fpm/Dockerfile-71-original ]]; then
#    cp -rf ${LARADOCK_DIRECTORY_PATH}php-fpm/Dockerfile-71 ${LARADOCK_DIRECTORY_PATH}php-fpm/Dockerfile-71-original
#else
#    cp -rf ${LARADOCK_DIRECTORY_PATH}php-fpm/Dockerfile-71-original ${LARADOCK_DIRECTORY_PATH}php-fpm/Dockerfile-71
#fi

# add mysql client
#sed -i ':a;N;$!ba;s=    ln -s /etc/php/7.1/mods-available/swoole.ini /etc/php/7.1/cli/conf.d/20-swoole.ini \\\n;fi=    ln -s /etc/php/7.1/mods-available/swoole.ini /etc/php/7.1/cli/conf.d/20-swoole.ini \\\n;fi\n\n\#####################################\n\# MySQL Client\n\#####################################\nUSER root\n\RUN apt-get update -yqq \&\& \\\n\    apt-get -y install mysql-client=' ${LARADOCK_DIRECTORY_PATH}workspace/Dockerfile-71