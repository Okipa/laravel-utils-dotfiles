#!/usr/bin/env bash

# example

## php container laravel.ini
#if [[ ! -f ${LARADOCK_DIRECTORY_PATH}php-fpm/laravel-original.ini ]]; then
#    cp -f ${LARADOCK_DIRECTORY_PATH}php-fpm/laravel.ini ${LARADOCK_DIRECTORY_PATH}php-fpm/laravel-original.ini
#else
#    cp -f ${LARADOCK_DIRECTORY_PATH}php-fpm/laravel-original.ini ${LARADOCK_DIRECTORY_PATH}php-fpm/laravel.ini
#fi
#sed -i "s#memory_limit = 128M#memory_limit = 512M#g" ${LARADOCK_DIRECTORY_PATH}php-fpm/laravel.ini
#sed -i -e "\$a; Maximum execution time of each script, in seconds\n\; http://php.net/max-execution-time\n\; Note: This directive is hardcoded to 0 for the CLI SAPI\n\max_execution_time = 300" ${LARADOCK_DIRECTORY_PATH}php-fpm/laravel.ini
## php container dockerfile
#if [[ ! -f ${LARADOCK_DIRECTORY_PATH}php-fpm/Dockerfile-71-original ]]; then
#    cp -f ${LARADOCK_DIRECTORY_PATH}php-fpm/Dockerfile-71 ${LARADOCK_DIRECTORY_PATH}php-fpm/Dockerfile-71-original
#else
#    cp -f ${LARADOCK_DIRECTORY_PATH}php-fpm/Dockerfile-71-original ${LARADOCK_DIRECTORY_PATH}php-fpm/Dockerfile-71
#fi
#sed -i 's#apt-get install -y --force-yes jpegoptim optipng pngquant gifsicle#apt-get install -y --force-yes jpegoptim optipng pngquant gifsicle libjpeg-turbo-progs#g' ${LARADOCK_DIRECTORY_PATH}php-fpm/Dockerfile-71
#sed -i '/# ImageMagick:/ i # Pdf generation:\n#####################################\nRUN apt-get update -y \&\& \\\napt-get -y install libfontconfig\n\n#####################################' ${LARADOCK_DIRECTORY_PATH}php-fpm/Dockerfile-71
## workspace container dockerfile
#if [[ ! -f ${LARADOCK_DIRECTORY_PATH}workspace/Dockerfile-71-original ]]; then
#    cp -f ${LARADOCK_DIRECTORY_PATH}workspace/Dockerfile-71 ${LARADOCK_DIRECTORY_PATH}workspace/Dockerfile-71-original
#else
#    cp -f ${LARADOCK_DIRECTORY_PATH}workspace/Dockerfile-71-original ${LARADOCK_DIRECTORY_PATH}workspace/Dockerfile-71
#fi
#sed -i 's#apt-get install -y --force-yes jpegoptim optipng pngquant gifsicle#apt-get install -y --force-yes jpegoptim optipng pngquant gifsicle libjpeg-turbo-progs#g' ${LARADOCK_DIRECTORY_PATH}workspace/Dockerfile-71
#sed -i '/\&\& rm chromedriver_linux64.zip \\/ a \&\& apt-get -y install lsof \\' ${LARADOCK_DIRECTORY_PATH}workspace/Dockerfile-71
