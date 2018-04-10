#!/usr/bin/env bash

# example

# we drop the database
echo "${purple}▶${reset} /usr/bin/php ${serverPreprodProjectPath}/current/artisan database:drop --force ..."
/usr/bin/php ${serverPreprodProjectPath}/current/artisan database:drop --force
