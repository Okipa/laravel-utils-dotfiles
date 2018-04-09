#!/usr/bin/env bash

# example

echo "${purple}→ docker-compose up -d ${arguments} workspace php-fpm nginx postgres${reset}"
docker-compose up -d ${arguments} workspace php-fpm nginx postgres
