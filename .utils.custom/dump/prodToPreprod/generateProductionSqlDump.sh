#!/bin/bash

# example

# we get the current script directory
dumpProdToPreprodGenerateSqlDumpScriptDirectory=$(dirname "$(readlink -f ${BASH_SOURCE[0]})")

# we execute a production pgsql dump
source $(realpath ${dumpProdToPreprodGenerateSqlDumpScriptDirectory}/../../../.utils/database/generatePgsqlDump.sh) ${serverProductionSqlDumpStorageDirectory}/nsn_dump.sql
