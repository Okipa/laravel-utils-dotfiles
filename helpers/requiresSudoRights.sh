#!/usr/bin/env bash

# we only want to check the sudo user rights verification once during a multiple scripts sequence
if [ -z $ALREADY_CHECKED_SUDO_USER ] ; then

    # we get the current script directory
    helpersRequiresSudoRightsScriptDirectory="$( cd "$(dirname "$0")" ; pwd -P )"

    # we load the scripting colors
    source ${helpersRequiresSudoRightsScriptDirectory}/loadScriptingColors.sh

    echo -e "${gray}=================================================${reset}\n"

    echo "${purple}▶${reset} Detecting if the current user has the sudo rights ..."

    # we execute the script treatments
    if [ "$(id -u)" != "0" ]; then
        echo -e "\n${red}✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗${reset}"
        echo "${purple}▶${reset} This command must be executed with a sudo-rights-user."
        echo "${purple}▶${reset} The command have been aborted."
        echo -e "${red}✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗${reset}\n"
        exit 1
    else
        # we set the sudo user check as already done
        ALREADY_CHECKED_SUDO_USER=true

        echo -e "${green}✔${reset} The current command is executed with a sudo user.\n"
    fi
fi
