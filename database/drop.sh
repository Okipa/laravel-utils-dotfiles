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
echo "${purple}→ PGPASSWORD=${DB_PASSWORD} psql -h \"${DB_HOST}\" -U \"${DB_USERNAME}\" -c \"DROP SCHEMA IF EXISTS public CASCADE; CREATE SCHEMA IF NOT EXISTS public AUTHORIZATION ${DB_USERNAME}; GRANT ALL ON SCHEMA public TO ${DB_USERNAME}; GRANT ALL ON SCHEMA public TO public;\"${reset}"
PGPASSWORD=${DB_PASSWORD} psql -h "${DB_HOST}" -U "${DB_USERNAME}" -c "DROP SCHEMA IF EXISTS public CASCADE; CREATE SCHEMA IF NOT EXISTS public AUTHORIZATION ${DB_USERNAME}; GRANT ALL ON SCHEMA public TO ${DB_USERNAME}; GRANT ALL ON SCHEMA public TO public;"
echo -e "${green}✔${reset} ${DB_DATABASE} database dropped.\n"
