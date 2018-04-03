#!/usr/bin/env bash

# we get the current script directory
currentScriptDirectory="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# we load the scripting colors
source $(realpath ${currentScriptDirectory}/../helpers/loadScriptingColors.sh)

echo -e "${gray}=================================================${reset}\n"

# packages installation detection
echo "${purple}▶${reset} Detecting packages installation on server ..."
PackagesToCheck=()
# custom instructions execution
configCheckScript=${currentScriptDirectory}/../../.utils.custom/server/configCheck.sh
if [ -f "${configCheckScript}" ]; then
    source ${configCheckScript}
else
    echo -e "${red}✗${reset} No .utils.custom/server/configCheck.sh script detected\n"
fi

# we execute the script treatments
missingPackage=false
function checkPackageInstallation() {
    if [ $(dpkg-query -W -f='${Status}' $1 2>/dev/null | grep -c "ok installed") -eq 0 ];
    then
        echo "${red}✗ Package installation required :${reset} ${purple}$1${reset}"
        missingPackage=true
    else
        echo "${green}✔ package detected :${reset} ${purple}$1${reset}"
    fi
}
for package in "${PackagesToCheck[@]}"
do
    checkPackageInstallation $package
done

# aborting server configuration if packages are missing
if [ "$missingPackage" = true ]
then
    echo -e "\n${red}✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗${reset}"
    echo "${purple}▶${reset} Some required packages are missing from your server."
    echo "${purple}▶${reset} Server configuration aborted : please install the missing packages."
    echo -e "${red}✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗${reset}\n"
    exit 1
else
    echo -e "${green}✔${reset} Packages installations successfully detected\n"
fi
