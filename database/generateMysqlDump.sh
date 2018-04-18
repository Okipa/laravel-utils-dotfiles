#!/usr/bin/env bash

# we get the current script directory
sqlGenerateMysqlDumpScriptDirectory="$( cd "$(dirname "$0")" ; pwd -P )"

# we load the scripting colors
source $(realpath ${sqlGenerateMysqlDumpScriptDirectory}/../helpers/loadScriptingColors.sh)

# we check that the variables required by the script are defined
source $(realpath ${sqlGenerateMysqlDumpScriptDirectory}/../helpers/checkVariableIsDefined.sh) DB_PASSWORD
source $(realpath ${sqlGenerateMysqlDumpScriptDirectory}/../helpers/checkVariableIsDefined.sh) DB_USERNAME
source $(realpath ${sqlGenerateMysqlDumpScriptDirectory}/../helpers/checkVariableIsDefined.sh) DB_HOST
source $(realpath ${sqlGenerateMysqlDumpScriptDirectory}/../helpers/checkVariableIsDefined.sh) DB_DATABASE

echo -e "${gray}=================================================${reset}\n"

# we get the script arguments
if [ -z $1 ];
then
    echo "${red}✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗${reset}"
    echo "${purple}▶${reset} The mandatory ${purple}destinationPath${reset} argument is missing."
    echo "${purple}▶${reset} Usage : ${purple}source generateMysqlDump.sh [destinationPath]${reset}."
    echo -e "${red}✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗${reset}\n"
    exit 1
fi

# we set the script variables
destinationPath="$1"

# we generate the production database dump
echo "${purple}▶${reset} Generating a mysql dump for the ${DB_DATABASE} database ..."
echo "${purple}→ MYSQL_PWD=${DB_PASSWORD} mysqldump -u ${DB_USERNAME} -h ${DB_HOST} ${DB_DATABASE} > ${destinationPath}${reset}"
MYSQL_PWD=${DB_PASSWORD} mysqldump -u ${DB_USERNAME} -h ${DB_HOST} ${DB_DATABASE} > ${destinationPath}
echo -e "${green}✔${reset} Mysql dump generated for the ${DB_DATABASE} database and stored in the ${destinationPath} directory.\n"
