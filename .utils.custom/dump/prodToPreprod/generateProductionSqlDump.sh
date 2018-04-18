#!/bin/bash

# example

# we get the current script directory
absolute_path=$(readlink -e -- "${BASH_SOURCE[0]}" && echo x) && absolute_path=${absolute_path%?x}
dir=$(dirname -- "$absolute_path" && echo x) && dir=${dir%?x}
dumpProdToPreprodGenerateSqlDumpScriptDirectory=${dir}

# we execute a production pgsql dump
source $(realpath ${dumpProdToPreprodGenerateSqlDumpScriptDirectory}/../../../.utils/database/generatePgsqlDump.sh) ${serverProductionSqlDumpStorageDirectory}/nsn_dump.sql
