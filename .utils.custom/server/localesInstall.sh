#!/bin/bash

# example custom script

echo -e "${gray}=================================================${reset}\n"

echo "${purple}▶${reset} Generating locales ..."
echo "${purple}→ locale-gen fr_FR.UTF-8${reset}"
locale-gen fr_FR.UTF-8
echo "${purple}→ locale-gen en_GB.UTF-8${reset}"
locale-gen en_GB.UTF-8
echo -e "${green}✔${reset} Locales generated.\n"
