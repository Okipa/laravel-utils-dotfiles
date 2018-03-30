#!/bin/bash

# we get the current script directory
currentScriptDirectory="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# we load the scripting colors
source $(realpath ${currentScriptDirectory}/../helpers/loadScriptingColors.sh)

# we check if the current user has the sudo rights
source $(realpath ${currentScriptDirectory}/../helpers/requiresSudoRights.sh)

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
    # set as much locales as you need here
    echo "${purple}→ locale-gen fr_FR.UTF-8${reset}"
    locale-gen fr_FR.UTF-8
    echo "${purple}→ locale-gen en_GB.UTF-8${reset}"
    locale-gen en_GB.UTF-8
    echo "${purple}→ update-locale ${reset}"
    # we load the added locales
    update-locale
    echo -e "${green}✔${reset} Project locales installed\n"
else
    echo "${red}✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗${reset}"
    echo "${purple}▶${reset} Locales installation aborted."
    echo -e "${red}✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗${reset}\n"
fi
