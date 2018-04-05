#!/usr/bin/env bash

# we get the current script directory
currentScriptDirectory="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# we load the scripting colors
source $(realpath ${currentScriptDirectory}/../../helpers/loadScriptingColors.sh)

# we get the script arguments
arguments=$@

echo -e "${gray}=================================================${reset}\n"

# we execute the script treatments
echo "${purple}▶${reset} Updating project git submodules ..."
echo "${purple}→ git submodule sync --recursive${reset}"
git submodule sync --recursive
echo "${purple}→ git submodule update --init --recursive --remote ${arguments}${reset}"
git submodule update --init --recursive --remote ${arguments}
echo -e "${green}✔${reset} The git submodules have been updated.\n"
