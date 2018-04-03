#!/usr/bin/env bash

# we get the current script directory
currentScriptDirectory="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# we load the scripting colors
source $(realpath ${currentScriptDirectory}/../helpers/loadScriptingColors.sh)

# we check if the current user has the sudo rights
source $(realpath ${currentScriptDirectory}/../helpers/requiresSudoRights.sh)
buildProjectConfig
# .env file detection
source $(realpath ${currentScriptDirectory}/../helpers/checkFileExists.sh) $(realpath "${currentScriptDirectory}/../../.env")

echo -e "${gray}=================================================${reset}\n"

echo -e "${purple}▽ LOCAL PROJET INSTALL : STARTING ▽${reset}\n"

# server locales installation
source $(realpath ${currentScriptDirectory}/../server/localesInstall.sh) --force

# server supervisor configuration
source $(realpath ${currentScriptDirectory}/../supervisor/install.sh) --force

echo -e "${gray}=================================================${reset}\n"

echo "${purple}▶${reset} Updating composer ...${reset}"
echo "${purple}→ composer self-update${reset}"
composer self-update
echo -e "${green}✔${reset} Composer updated${reset}\n"

echo -e "${gray}=================================================${reset}\n"

# composer install / update
echo "${purple}▶${reset} Installing / updating composer dependencies ...${reset}"

if [ -d vendor ]; then
    echo "${gray}vendor directory detected${reset}"
    echo "${purple}→ composer update --verbose --prefer-dist --optimize-autoloader --no-progress --no-interaction${reset}"
    composer update --verbose --prefer-dist --optimize-autoloader --no-progress --no-interaction
    echo -e "${green}✔${reset} Composer dependencies updated${reset}\n"
else
    echo "${gray}vendor directory not detected${reset}"
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

installScript=${currentScriptDirectory}/../../.utils.custom/project/install.sh
if [ -f "${installScript}" ]; then
    echo -e "${green}✔${reset} The .utils.custom/project/install.sh custom instructions script has been detected.\n"
    source ${installScript}
else
    echo -e "${green}✔${reset} No .utils.custom/project/install.sh script detected.\n"
fi

echo -e "${gray}=================================================${reset}\n"

# script end
echo -e "${green}△ LOCAL PROJET INSTALL : DONE △${reset}\n"
