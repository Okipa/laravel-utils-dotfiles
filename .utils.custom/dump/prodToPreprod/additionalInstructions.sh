#!/usr/bin/env bash

# example

# we sync the production files directory with the preprod project
echo "${purple}▶${reset} Syncing the production public/files directory with the preprod project ..."
echo "${purple}→ rsync -r --info=progress2 ${productionProjectPath}/shared/public/files/ ${preprodProjectPath}/shared/public/files${reset}"
rsync -r --info=progress2 ${productionProjectPath}/shared/public/files/ ${preprodProjectPath}/shared/public/files
echo "${purple}→ chown -R ${preprodUser}:users ${preprodProjectPath}/shared/public/files${reset}"
chown -R ${preprodUser}:users ${preprodProjectPath}/shared/public/files
echo -e "${green}✔${reset} Files directory sync done.\n"
