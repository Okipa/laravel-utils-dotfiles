#!/usr/bin/env bash

# example

# we drop the database
echo "${purple}▶${reset} sudo -u ${serverPreprodUser} /usr/bin/php ${serverPreprodProjectPath}/current/artisan database:drop --force ..."
sudo -u ${serverPreprodUser} /usr/bin/php ${serverPreprodProjectPath}/current/artisan database:drop --force
