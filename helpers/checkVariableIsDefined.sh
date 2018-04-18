#!/bin/bash

# we get the current script directory
helpersCheckVariableIsDefinedScriptDirectory=$(dirname "$(readlink -f ${BASH_SOURCE[0]})")

# we load thie scripting colors
source ${helpersCheckVariableIsDefinedScriptDirectory}/loadScriptingColors.sh

echo -e "${gray}=================================================${reset}\n"

# we get the script arguments
if [ -z $1 ]; then
    echo "${red}✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗${reset}"
    echo "${purple}▶${reset} The mandatory ${purple}variable${reset} argument is missing."
    echo "${purple}▶${reset} Usage : ${purple}source checkVariableIsDefined.sh [variable]${reset}."
    echo -e "${red}✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗${reset}\n"
    exit 1
fi

# we set the script variables
variable=$1

echo "${purple}▶${reset} Checking if the ${purple}${variable}${reset} variable is defined ..."

# we execute the script treatments
if [ -z ${!variable} ]; then
    echo -e "\n${red}✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗${reset}"
    echo "The ${purple}${variable}${reset} variable is not defined."
    echo -e "${red}✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗${reset}\n"
    exit 1
else
    echo -e "${green}✔${reset} The ${purple}${variable}${reset} variable has been detected and has the following value : ${purple}$(echo ${!variable})${reset}.\n"
fi
