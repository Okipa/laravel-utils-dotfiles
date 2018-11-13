#!/bin/bash

serverLocalesInstallScriptDirectory=$(dirname "$(readlink -f ${BASH_SOURCE[0]})")

source $(realpath ${serverLocalesInstallScriptDirectory}/../helpers/loadScriptingColors.sh)

source $(realpath ${serverLocalesInstallScriptDirectory}/../helpers/requiresSudoRights.sh)

echo -e "${gray}=================================================${reset}\n"

[[ $1 = "--force" ]] && FORCE=true || FORCE=false

if [ "$FORCE" == false ]; then
    read -p "Would you like to install the project-related server locales ? [${green}y${reset}/${red}N${reset}]" -n 1 -r
    echo
fi
if [ "$FORCE" == true ] || [[ "$REPLY" =~ ^[Yy]$ ]]; then

    localesInstallScriptPath=${serverLocalesInstallScriptDirectory}/../../.utils.custom/server/localesInstall.sh
    source $(realpath ${serverLocalesInstallScriptDirectory}/../helpers/checkFileExists.sh) ${localesInstallScriptPath}
    source ${localesInstallScriptPath}
    
    echo -e "${gray}=================================================${reset}\n"
    
    echo "${purple}▶${reset} Updating server locales ..."
    echo "${purple}→ update-locale ${reset}"
    update-locale
    echo -e "${green}✔${reset} Server locales updated\n"
else
    echo "${red}✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗${reset}"
    echo "${purple}▶${reset} Locales installation aborted."
    echo -e "${red}✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗${reset}\n"
fi
