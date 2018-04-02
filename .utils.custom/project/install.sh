#!/usr/bin/env bash

# example

#echo -e "${gray}=================================================${reset}\n"

## bower install / update
#echo "${purple}▶${reset} Installing / updating bower dependencies ..."
#if [ -d bower_components ]; then
#    echo "${gray}Bower vendor directory detected${reset}"
#    echo "${purple}→ ./node_modules/bower/bin/bower update${reset}"
#    ./node_modules/bower/bin/bower update
#    echo -e "${green}✔${reset} Bower dependencies updated\n"
#else
#    echo "${gray}Bower vendor directory NOT detected${reset}"
#    echo "${purple}→ ./node_modules/bower/bin/bower install${reset}"
#    ./node_modules/bower/bin/bower install
#    echo -e "${green}✔${reset} Bower dependencies installed\n"
#fi

#echo -e "${gray}=================================================${reset}\n"

## we prepare the storage folders
#echo "${purple}▶${reset} Preparing storage folders ..."
#echo "${purple}→ php artisan storage:prepare${reset}"
#php artisan storage:prepare
#echo "${green}✔${reset} Storage folders prepared"

#echo -e "${gray}=================================================${reset}\n"

## we prepare the symbolic links
#echo "${purple}▶${reset} Preparing app symlinks ..."
#echo "${purple}→ php artisan symlinks:prepare${reset}"
#php artisan symlinks:prepare
#echo "${green}✔${reset} App symlinks created"

#echo -e "${gray}=================================================${reset}\n"

## project optimizations
#echo "${purple}▶${reset} Executing project optimizations ..."
#echo "${purple}→ php artisan project:optimize${reset}"
#php artisan project:optimize
#echo -e "${green}✔${reset} Project optimizations done\n"
