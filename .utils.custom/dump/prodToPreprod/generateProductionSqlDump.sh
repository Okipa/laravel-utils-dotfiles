#!/bin/bash

# example custom script

dumpProdToPreprodGenerateSqlDumpScriptDirectory=$(dirname "$(readlink -f ${BASH_SOURCE[0]})")

source $(realpath ${dumpProdToPreprodGenerateSqlDumpScriptDirectory}/../../../.utils/database/generateMysqlDump.sh) ${serverProductionSqlDumpStoragePath}/dump.sql
