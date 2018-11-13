#!/bin/bash

sqlGenerateMysqlDumpScriptDirectory=$(dirname "$(readlink -f ${BASH_SOURCE[0]})")

source $(realpath ${sqlGenerateMysqlDumpScriptDirectory}/../helpers/loadScriptingColors.sh)

source $(realpath ${sqlGenerateMysqlDumpScriptDirectory}/../helpers/checkVariableIsDefined.sh) DB_PASSWORD
source $(realpath ${sqlGenerateMysqlDumpScriptDirectory}/../helpers/checkVariableIsDefined.sh) DB_USERNAME
source $(realpath ${sqlGenerateMysqlDumpScriptDirectory}/../helpers/checkVariableIsDefined.sh) DB_HOST
source $(realpath ${sqlGenerateMysqlDumpScriptDirectory}/../helpers/checkVariableIsDefined.sh) DB_DATABASE

echo -e "${gray}=================================================${reset}\n"

if [ -z $1 ];
then
    echo "${red}✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗${reset}"
    echo "${purple}▶${reset} The mandatory ${purple}destinationPath${reset} argument is missing."
    echo "${purple}▶${reset} Usage : ${purple}source generateMysqlDump.sh [destinationPath]${reset}."
    echo -e "${red}✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗${reset}\n"
    exit 1
fi

destinationPath="$1"

echo "${purple}▶${reset} Generating a mysql dump for the ${DB_DATABASE} database ..."
echo "${purple}→ MYSQL_PWD=${DB_PASSWORD} mysqldump -u ${DB_USERNAME} -h ${DB_HOST} ${DB_DATABASE} > ${destinationPath}${reset}"
MYSQL_PWD=${DB_PASSWORD} mysqldump -u ${DB_USERNAME} -h ${DB_HOST} ${DB_DATABASE} > ${destinationPath}
echo -e "${green}✔${reset} Mysql dump generated for the ${purple}${DB_DATABASE}${reset} database and stored in the ${purple}${destinationPath}${reset} directory.\n"
