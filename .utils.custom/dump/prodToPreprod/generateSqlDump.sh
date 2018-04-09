#!/usr/bin/env bash

# example

# we get the current script directory
databaseGenerateSqlDumpScriptDirectory="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# we execute a production pgsql dump
source $(realpath ${databaseGenerateSqlDumpScriptDirectory}/../../../.utils/database/generatePgsqlDump.sh) ${productionSqlDumpStoragePath}
