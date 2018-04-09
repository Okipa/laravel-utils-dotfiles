#!/usr/bin/env bash

# example

# we get the current script directory
dumpImportFromProdGenerateServerProdDumpArchiveScriptDirectory="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo -e "${gray}=================================================${reset}\n"

# we set the required variables
source ${dumpImportFromProdGenerateServerProdDumpArchiveScriptDirectory}/setRequiredVariables.sh
source $(realpath ${dumpImportFromProdGenerateServerProdDumpArchiveScriptDirectory}/../../../helpers/checkVariableIsDefined.sh) prodUser
source $(realpath ${dumpImportFromProdGenerateServerProdDumpArchiveScriptDirectory}/../../../helpers/checkVariableIsDefined.sh) serverHost
source $(realpath ${dumpImportFromProdGenerateServerProdDumpArchiveScriptDirectory}/../../../helpers/checkVariableIsDefined.sh) productionProjectPath
source $(realpath ${dumpImportFromProdGenerateServerProdDumpArchiveScriptDirectory}/../../../helpers/checkVariableIsDefined.sh) productionSqlDumpStoragePath

echo -e "${gray}=================================================${reset}\n"

# we export the .env file variables
source $(realpath ${dumpImportFromProdGenerateServerProdDumpArchiveScriptDirectory}/../../../helpers/exportEnvFileVariables.sh)

# we execute a production pgsql dump
source $(realpath ${dumpImportFromProdGenerateServerProdDumpArchiveScriptDirectory}/../../../database/generatePgsqlDump.sh) ${productionSqlDumpStoragePath}

echo -e "${gray}=================================================${reset}\n"

# we copy the project public/file directory to the dump
rsync ${productionProjectPath}/shared/public ${productionSqlDumpStoragePath}

# we generate an archive from the production dump folder


