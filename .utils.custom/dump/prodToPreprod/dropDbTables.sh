#!/bin/bash

# example

# we drop the database
echo "${purple}▶${reset} sudo -u ${serverPreprodUser} /usr/bin/php ${serverPreprodProjectPath}/current/artisan migrate:reset"
sudo -u ${serverPreprodUser} /usr/bin/php ${serverPreprodProjectPath}/current/artisan migrate:reset
