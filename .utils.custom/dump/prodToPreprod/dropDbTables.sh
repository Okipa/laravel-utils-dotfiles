#!/bin/bash

# example custom script

echo -e "${gray}=================================================${reset}\n"

echo "${purple}▶${reset} Dropping the ${DB_DATABASE} database tables ..."
echo "${purple}▶${reset} sudo -u ${serverPreprodUser} /usr/bin/php ${serverPreprodProjectPath}/current/artisan migrate:reset"
sudo -u ${serverPreprodUser} /usr/bin/php ${serverPreprodProjectPath}/current/artisan migrate:reset
echo -e "${green}✔${reset} ${DB_DATABASE} database tables dropped.\n"
