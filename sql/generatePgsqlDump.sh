#!/usr/bin/env bash

# we get the current script directory
sqlGeneratePgsqlDumpScriptDirectory="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# we load the scripting colors
source $(realpath ${sqlGeneratePgsqlDumpScriptDirectory}/../helpers/loadScriptingColors.sh)

# we check that the variables required by the script are defined
source $(realpath ${sqlGeneratePgsqlDumpScriptDirectory}/../helpers/checkVariableIsDefined.sh) DB_PASSWORD
source $(realpath ${sqlGeneratePgsqlDumpScriptDirectory}/../helpers/checkVariableIsDefined.sh) DB_USERNAME
source $(realpath ${sqlGeneratePgsqlDumpScriptDirectory}/../helpers/checkVariableIsDefined.sh) DB_HOST
source $(realpath ${sqlGeneratePgsqlDumpScriptDirectory}/../helpers/checkVariableIsDefined.sh) DB_DATABASE

echo -e "${gray}=================================================${reset}\n"

# we get the script arguments
if [ -z $1 ];
then
    echo "${red}✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗${reset}"
    echo "${purple}▶${reset} The mandatory ${purple}destinationPath${reset} argument is missing."
    echo "${purple}▶${reset} Usage : ${purple}source generatePgsqlDump.sh [destinationPath]${reset}."
    echo -e "${red}✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗${reset}\n"
    exit 1
fi

# we set the script variables
destinationPath="$1"

# we generate the production database dump
echo "${purple}▶${reset} Generating a pgsql dump for the ${DB_DATABASE} database ..."
echo "${purple}→ PGPASSWORD=${DB_PASSWORD} pg_dump -w -c -U \"${DB_USERNAME}\" -h \"${DB_HOST}\" \"${DB_DATABASE}\" > ${destinationPath}${reset}"
PGPASSWORD=$DB_PASSWORD pg_dump -w -c -U "${DB_USERNAME}" -h "${DB_HOST}" "${DB_DATABASE}" > ${destinationPath}
echo -e "${green}✔${reset} Pgsql dump generated for the ${DB_DATABASE} database and stored in the ${destinationPath} directory.\n"
