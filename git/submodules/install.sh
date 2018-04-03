#!/usr/bin/env bash

# we get the current script directory
currentScriptDirectory="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# we load the scripting colors
source $(realpath ${currentScriptDirectory}/../../helpers/loadScriptingColors.sh)

# we get the script arguments
arguments=$@

echo -e "${gray}=================================================${reset}\n"

# we execute the script treatments
echo "${purple}▶${reset} Installing project git submodules ..."
git submodule sync --recursive
git submodule update --init --recursive ${arguments}
echo -e "${green}✔${reset} The git submodules have been installed.\n"
