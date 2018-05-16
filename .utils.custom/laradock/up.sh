#!/bin/bash

# example

echo "${purple}→ docker-compose up -d ${arguments} workspace php-fpm nginx mysql${reset}"
docker-compose up -d ${arguments} workspace php-fpm nginx mysql
