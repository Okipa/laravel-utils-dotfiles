#!/usr/bin/env bash

# example

# we get the current script directory
dumpProdToPreprodGenerateSqlDumpScriptDirectory="$( cd "$(dirname "$0")" ; pwd -P )"

# we execute a production pgsql dump
source $(realpath ${dumpProdToPreprodGenerateSqlDumpScriptDirectory}/../../../.utils/database/generatePgsqlDump.sh) ${serverProductionSqlDumpStorageDirectory}/nsn_dump.sql
