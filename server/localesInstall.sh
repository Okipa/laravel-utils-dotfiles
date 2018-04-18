#!/usr/bin/env bash

# we get the current script directory
serverLocalesInstallScriptDirectory="$( cd "$(dirname "$0")" ; pwd -P )"

# we load the scripting colors
source $(realpath ${serverLocalesInstallScriptDirectory}/../helpers/loadScriptingColors.sh)

# we check if the current user has the sudo rights
source $(realpath ${serverLocalesInstallScriptDirectory}/../helpers/requiresSudoRights.sh)

echo -e "${gray}=================================================${reset}\n"

# we get the script arguments
[[ $1 = "--force" ]] && FORCE=true || FORCE=false

# we execute the script treatments
if [ "$FORCE" == false ]; then
    read -p "Would you like to install the project-related server locales ? [${green}y${reset}/${red}N${reset}]" -n 1 -r
    echo
fi
if [ "$FORCE" == true ] || [[ "$REPLY" =~ ^[Yy]$ ]]; then
    echo "${purple}▶${reset} Installing project locales ..."
    # custom instructions execution
    localesInstallScript=${serverLocalesInstallScriptDirectory}/../../.utils.custom/server/localesInstall.sh
    if [ -f "${localesInstallScript}" ]; then
        echo "${green}✔${reset} The .utils.custom/server/localesInstall.sh custom instructions script has been detected and executed."
        source ${localesInstallScript}
    else
        echo "${red}✗${reset} No .utils.custom/server/localesInstall.sh script detected."
    fi
    # we load the added locales
    echo "${purple}→ update-locale ${reset}"
    update-locale
    echo -e "${green}✔${reset} Project locales installed\n"
else
    echo "${red}✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗${reset}"
    echo "${purple}▶${reset} Locales installation aborted."
    echo -e "${red}✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗${reset}\n"
fi
