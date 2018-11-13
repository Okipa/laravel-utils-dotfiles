#!/bin/bash

# example custom script

echo -e "${gray}=================================================${reset}\n"

echo "${purple}▶${reset} Starting ${APP_NAME} docker containers ..."
echo "${purple}→ docker-compose up -d ${arguments} workspace php-fpm nginx mysql${reset}"
docker-compose up -d ${arguments} workspace php-fpm nginx mysql
echo -e "${green}✔${reset} ${APP_NAME} docker containers started.\n"
