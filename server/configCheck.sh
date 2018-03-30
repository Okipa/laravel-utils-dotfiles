#!/bin/bash

# we get the current script directory
currentScriptDirectory="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# we load the scripting colors
source $(realpath ${currentScriptDirectory}/../helpers/loadScriptingColors.sh)

echo -e "${gray}=================================================${reset}\n"

# packages installation detection
echo "${purple}▶${reset} Detecting packages installation on server ..."
# set as much package to check as you need here
PackagesToCheck=()
PackagesToCheck+=('php7.1-common')
PackagesToCheck+=('php7.1-fpm')
PackagesToCheck+=('php7.1-cli')
PackagesToCheck+=('php7.1-mysql')
PackagesToCheck+=('php7.1-mbstring')
PackagesToCheck+=('php7.1-xml')
PackagesToCheck+=('php7.1-gd')
PackagesToCheck+=('php7.1-curl')
PackagesToCheck+=('php7.1-intl')
PackagesToCheck+=('php7.1-zip')
PackagesToCheck+=('mysql-server')
PackagesToCheck+=('nginx')
PackagesToCheck+=('git')
PackagesToCheck+=('supervisor')
PackagesToCheck+=('jpegoptim')
PackagesToCheck+=('optipng')
PackagesToCheck+=('gifsicle')

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
