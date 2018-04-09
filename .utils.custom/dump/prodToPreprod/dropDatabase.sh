#!/usr/bin/env bash

# example

# we get the current script directory
databaseDropPgsqlScriptDirectory="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# we execute a production pgsql dump
source $(realpath ${databaseDropPgsqlScriptDirectory}/../../database/dropPgsql.sh) ${databaseDropPgsqlScriptDirectory}
