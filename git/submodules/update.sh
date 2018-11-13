#!/bin/bash

gitSubmodulesUpdateScriptDirectory=$(dirname "$(readlink -f ${BASH_SOURCE[0]})")

source $(realpath ${gitSubmodulesUpdateScriptDirectory}/../../helpers/loadScriptingColors.sh)

arguments=$@

echo -e "${gray}=================================================${reset}\n"

echo "${purple}▶${reset} Updating project git submodules ..."
echo "${purple}→ git submodule sync --recursive${reset}"
git submodule sync --recursive
echo "${purple}→ git submodule update --init --recursive --remote --force${arguments}${reset}"
git submodule update --init --recursive --remote --force ${arguments}
echo -e "${green}✔${reset} The git submodules have been updated.\n"
