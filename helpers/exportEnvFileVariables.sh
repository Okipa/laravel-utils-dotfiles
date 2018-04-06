#!/usr/bin/env bash

# we get the current script directory
currentScriptDirectory="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# we load the scripting colors
source ${currentScriptDirectory}/loadScriptingColors.sh

# we set the script variables
if [ -z $1 ]; then
    envFilePath=$(realpath "${currentScriptDirectory}/../../.env")
else
    envFilePath=$1
    ALREADY_EXPORTED_ENV_VARIABLES=false
fi

# we only want to export the env variables once during a multiple scripts sequence
if [ ! $ALREADY_EXPORTED_ENV_VARIABLES ] ; then

    # we check that the env file does exist
    source ${currentScriptDirectory}/checkFileExists.sh ${envFilePath}

    echo -e "${gray}=================================================${reset}\n"

    # we export the .env file variables
    echo "${purple}▶${reset} Exporting project ${purple}${envFilePath}${reset} file variables ..."
    IFS=$'\n'; for line in $(grep -Ev '^$|^#|^//|^\*' ${envFilePath}); do echo ${line}; export $(echo $line |tr -d '"'); done

    # we set the env variables as already exported
    ALREADY_EXPORTED_ENV_VARIABLES=true

    echo -e "${green}✔${reset} The ${purple}${envFilePath}${reset} file variables have been exported.\n"
fi
