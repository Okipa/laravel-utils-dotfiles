#!/bin/bash

sqlGeneratePgsqlDumpScriptDirectory=$(dirname "$(readlink -f ${BASH_SOURCE[0]})")

source $(realpath ${sqlGeneratePgsqlDumpScriptDirectory}/../helpers/loadScriptingColors.sh)

source $(realpath ${sqlGeneratePgsqlDumpScriptDirectory}/../helpers/checkVariableIsDefined.sh) DB_PASSWORD
source $(realpath ${sqlGeneratePgsqlDumpScriptDirectory}/../helpers/checkVariableIsDefined.sh) DB_USERNAME
source $(realpath ${sqlGeneratePgsqlDumpScriptDirectory}/../helpers/checkVariableIsDefined.sh) DB_HOST
source $(realpath ${sqlGeneratePgsqlDumpScriptDirectory}/../helpers/checkVariableIsDefined.sh) DB_DATABASE

echo -e "${gray}=================================================${reset}\n"

if [ -z $1 ];
then
    echo "${red}✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗${reset}"
    echo "${purple}▶${reset} The mandatory ${purple}destinationPath${reset} argument is missing."
    echo "${purple}▶${reset} Usage : ${purple}source generatePgsqlDump.sh [destinationPath]${reset}."
    echo -e "${red}✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗${reset}\n"
    exit 1
fi

destinationPath="$1"

echo "${purple}▶${reset} Generating a pgsql dump for the ${DB_DATABASE} database ..."
echo "${purple}→ PGPASSWORD=${DB_PASSWORD} pg_dump -w -c -O -x -U ${DB_USERNAME} -h ${DB_HOST} ${DB_DATABASE} > ${destinationPath}${reset}"
PGPASSWORD=${DB_PASSWORD} pg_dump -w -c -O -x -U ${DB_USERNAME} -h ${DB_HOST} ${DB_DATABASE} > ${destinationPath}
echo -e "${green}✔${reset} Pgsql dump generated for the ${purple}${DB_DATABASE}${reset} database and stored in the ${purple}${destinationPath}${reset} directory.\n"
