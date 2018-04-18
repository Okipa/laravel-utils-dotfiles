#!/bin/bash

# we get the current script directory
absolute_path=$(readlink -e -- "${BASH_SOURCE[0]}" && echo x) && absolute_path=${absolute_path%?x}
dir=$(dirname -- "$absolute_path" && echo x) && dir=${dir%?x}
gitSubmodulesUpdateScriptDirectory=${dir}

# we load the scripting colors
source $(realpath ${gitSubmodulesUpdateScriptDirectory}/../../helpers/loadScriptingColors.sh)

# we get the script arguments
arguments=$@

echo -e "${gray}=================================================${reset}\n"

# we execute the script treatments
echo "${purple}▶${reset} Updating project git submodules ..."
echo "${purple}→ git submodule sync --recursive${reset}"
git submodule sync --recursive
echo "${purple}→ git submodule update --init --recursive --remote --force${arguments}${reset}"
git submodule update --init --recursive --remote --force ${arguments}
echo -e "${green}✔${reset} The git submodules have been updated.\n"
