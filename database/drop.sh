#!/usr/bin/env bash

# we get the current script directory
databaseResetScriptDirectory="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# we load the scripting colors
source ${databaseResetScriptDirectory}/loadScriptingColors.sh

# we check that the variables required by the script are defined
source $(realpath ${databaseResetScriptDirectory}/../helpers/checkVariableIsDefined.sh) DB_PASSWORD
source $(realpath ${databaseResetScriptDirectory}/../helpers/checkVariableIsDefined.sh) DB_HOST
source $(realpath ${databaseResetScriptDirectory}/../helpers/checkVariableIsDefined.sh) DB_USERNAME
source $(realpath ${databaseResetScriptDirectory}/../helpers/checkVariableIsDefined.sh) DB_DATABASE

echo -e "${gray}=================================================${reset}\n"

echo "${purple}▶${reset} Dropping ${DB_DATABASE} database ..."

PGPASSWORD=${DB_PASSWORD} psql -h "${DB_HOST}" -U "${DB_USERNAME}" -c "DROP DATABASE IF EXISTS ${DB_DATABASE}"

echo -e "${green}✔${reset} ${DB_DATABASE} database dropped.\n"
