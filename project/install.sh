#!/bin/bash

# we get the current script directory
projectInstallScriptDirectory=$(dirname "$(readlink -f ${BASH_SOURCE[0]})")

# we load the scripting colors
source $(realpath ${projectInstallScriptDirectory}/../helpers/loadScriptingColors.sh)

# we check if the current user has the sudo rights
source $(realpath ${projectInstallScriptDirectory}/../helpers/requiresSudoRights.sh)

# .env file detection
source $(realpath ${projectInstallScriptDirectory}/../helpers/checkFileExists.sh) $(realpath "${projectInstallScriptDirectory}/../../.env")

echo -e "${gray}=================================================${reset}\n"

echo -e "${purple}▽ LOCAL PROJET INSTALL : STARTING ▽${reset}\n"

echo -e "${gray}=================================================${reset}\n"

echo "${purple}▶${reset} Updating composer ...${reset}"
echo "${purple}→ composer self-update${reset}"
composer self-update
echo -e "${green}✔${reset} Composer updated${reset}\n"

echo -e "${gray}=================================================${reset}\n"

# composer install / update
echo "${purple}▶${reset} Installing / updating composer dependencies ...${reset}"

if [ -d vendor ]; then
    echo "${gray}→ vendor directory detected${reset}"
    echo "${purple}→ composer update --verbose --prefer-dist --optimize-autoloader --no-progress --no-interaction${reset}"
    composer update --verbose --prefer-dist --optimize-autoloader --no-progress --no-interaction
    echo -e "${green}✔${reset} Composer dependencies updated${reset}\n"
else
    echo "${gray}→ vendor directory not detected${reset}"
    echo "${purple}→ composer install --verbose --prefer-dist --optimize-autoloader --no-progress --no-interaction${reset}"
    composer install --verbose --prefer-dist --optimize-autoloader --no-progress --no-interaction
    echo -e "${green}✔${reset} Composer dependencies installed${reset}\n"
fi

echo -e "${gray}=================================================${reset}\n"

# generating app key
echo "${purple}▶${reset} Generating app key ...${reset}"
echo "${purple}→ php artisan key:generate${reset}"
php artisan key:generate
echo -e "${green}✔${reset} App key generated\n"

echo -e "${gray}=================================================${reset}\n"

# we execute the migrations
echo "${purple}▶${reset} Executing migrations ..."
echo "${purple}→ php artisan migrate${reset}"
php artisan migrate
echo "${green}✔${reset} Migrations executed"

echo -e "\n${gray}=================================================${reset}\n"

installScript=${projectInstallScriptDirectory}/../../.utils.custom/project/install.sh
if [ -f "${installScript}" ]; then
    echo "${green}✔${reset} ${gray}The .utils.custom/project/install.sh custom instructions script has been detected and executed.${reset}"
    source ${installScript}
else
    echo "${red}✗${reset} ${gray}No .utils.custom/project/install.sh script detected.${reset}"
fi

echo -e "${gray}=================================================${reset}\n"

# script end
echo -e "${green}△ LOCAL PROJET INSTALL : DONE △${reset}\n"
