#!/bin/bash

if [ -z $ALREADY_CHECKED_SUDO_USER ] ; then

    absolutePath=$(readlink -e -- "${BASH_SOURCE[0]}" && echo x) && absolutePath=${absolutePath%?x}
    dir=$(dirname -- "$absolutePath" && echo x) && dir=${dir%?x}
    helpersRequiresSudoRightsScriptDirectory=$(dirname "$(readlink -f ${BASH_SOURCE[0]})")

    source ${helpersRequiresSudoRightsScriptDirectory}/loadScriptingColors.sh

    echo -e "${gray}=================================================${reset}\n"

    echo "${purple}▶${reset} Detecting if the current user has the sudo rights ..."
    if [ "$(id -u)" != "0" ]; then
        echo -e "\n${red}✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗${reset}"
        echo "${purple}▶${reset} This command must be executed with a sudo-rights-user."
        echo "${purple}▶${reset} The command have been aborted."
        echo -e "${red}✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗${reset}\n"
        exit 1
    else
        ALREADY_CHECKED_SUDO_USER=true
        echo -e "${green}✔${reset} The current command is executed with a sudo user.\n"
    fi
fi
