#!/bin/bash

serverConfigCheckScriptDirectory=$(dirname "$(readlink -f ${BASH_SOURCE[0]})")

source $(realpath ${serverConfigCheckScriptDirectory}/../helpers/loadScriptingColors.sh)

configCheckScriptPath=${serverConfigCheckScriptDirectory}/../../.utils.custom/server/configCheck.sh
source $(realpath ${serverConfigCheckScriptDirectory}/../helpers/checkFileExists.sh) ${configCheckScriptPath}

echo -e "${gray}=================================================${reset}\n"

echo "${purple}▶${reset} Detecting packages installation on server ..."
PackagesToCheck=()
source ${configCheckScriptPath}
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

if [ "$missingPackage" = true ]
then
    echo -e "\n${red}✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗${reset}"
    echo "${purple}▶${reset} Some required packages are missing from your server."
    echo "${purple}▶${reset} Server configuration aborted : please install the missing packages."
    echo -e "${red}✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗${reset}\n"
    exit 1
else
    echo -e "${green}✔${reset} Packages installations successfully detected.\n"
fi
