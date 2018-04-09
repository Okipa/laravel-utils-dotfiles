#!/usr/bin/env bash

# we get the current script directory
databasedropMysqlScriptDirectory="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# we load the scripting colors
source ${databasedropMysqlScriptDirectory}/loadScriptingColors.sh

# we check that the variables required by the script are defined
source $(realpath ${databasedropMysqlScriptDirectory}/../helpers/checkVariableIsDefined.sh) DB_PASSWORD
source $(realpath ${databasedropMysqlScriptDirectory}/../helpers/checkVariableIsDefined.sh) DB_HOST
source $(realpath ${databasedropMysqlScriptDirectory}/../helpers/checkVariableIsDefined.sh) DB_USERNAME
source $(realpath ${databasedropMysqlScriptDirectory}/../helpers/checkVariableIsDefined.sh) DB_DATABASE

echo -e "${gray}=================================================${reset}\n"

// todo : mysql drop
