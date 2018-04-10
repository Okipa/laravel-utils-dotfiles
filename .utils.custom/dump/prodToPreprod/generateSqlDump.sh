#!/usr/bin/env bash

# example

# we get the current script directory
dumpProdToPreprodGenerateSqlDumpScriptDirectory="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# we execute a production pgsql dump
source $(realpath ${dumpProdToPreprodGenerateSqlDumpScriptDirectory}/../../../.utils/database/generatePgsqlDump.sh) ${serverProductionSqlDumpStoragePath}
