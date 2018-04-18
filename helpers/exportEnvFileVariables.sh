#!/bin/bash

# we get the current script directory
absolute_path=$(readlink -e -- "${BASH_SOURCE[0]}" && echo x) && absolute_path=${absolute_path%?x}
dir=$(dirname -- "$absolute_path" && echo x) && dir=${dir%?x}
helpersExportEnvFileVariablesScriptDirectory=${dir}

# we load the scripting colors
source ${helpersExportEnvFileVariablesScriptDirectory}/loadScriptingColors.sh

# we set the script variables
if [ -z $1 ]; then
    envFilePath=$(realpath "${helpersExportEnvFileVariablesScriptDirectory}/../../.env")
elif [[ $1 = '--' ]]; then
    envFilePath=$(realpath "${helpersExportEnvFileVariablesScriptDirectory}/../../.env")
else
    envFilePath=$1
    ALREADY_EXPORTED_ENV_VARIABLES=
fi

# we only want to export the env variables once during a multiple scripts sequence
if [ -z $ALREADY_EXPORTED_ENV_VARIABLES ] ; then

    # we check that the env file does exist
    source ${helpersExportEnvFileVariablesScriptDirectory}/checkFileExists.sh ${envFilePath}

    echo -e "${gray}=================================================${reset}\n"

    # we export the .env file variables
    echo "${purple}▶${reset} Exporting project ${purple}${envFilePath}${reset} file variables ..."
    IFS=$'\n'; for line in $(grep -Ev '^$|^#|^//|^\*' ${envFilePath}); do echo ${line}; export $(echo $line |tr -d '"'); done

    # we set the env variables as already exported
    ALREADY_EXPORTED_ENV_VARIABLES=true

    echo -e "${green}✔${reset} The ${purple}${envFilePath}${reset} file variables have been exported.\n"
fi
