#!/bin/bash

helpersExportEnvFileVariablesScriptDirectory=$(dirname "$(readlink -f ${BASH_SOURCE[0]})")

source ${helpersExportEnvFileVariablesScriptDirectory}/loadScriptingColors.sh

if [ -z $1 ]; then
    envFilePath=$(realpath "${helpersExportEnvFileVariablesScriptDirectory}/../../.env")
elif [[ $1 = '--' ]]; then
    envFilePath=$(realpath "${helpersExportEnvFileVariablesScriptDirectory}/../../.env")
else
    envFilePath=$1
    ALREADY_EXPORTED_ENV_VARIABLES=
fi

if [ -z $ALREADY_EXPORTED_ENV_VARIABLES ] ; then

    source ${helpersExportEnvFileVariablesScriptDirectory}/checkFileExists.sh ${envFilePath}

    echo -e "${gray}=================================================${reset}\n"

    echo "${purple}▶${reset} Exporting project ${purple}${envFilePath}${reset} file variables ..."
    IFS=$'\n'; for line in $(grep -Ev '^$|^#|^//|^\*' ${envFilePath}); do echo ${line}; export $(echo $line |tr -d '"'); done
    ALREADY_EXPORTED_ENV_VARIABLES=true
    echo -e "${green}✔${reset} The ${purple}${envFilePath}${reset} file variables have been exported.\n"
fi
