#!/bin/bash

# example

# we sync the production files directory with the preprod project
echo "${purple}▶${reset} Syncing the production public/files directory with the preprod project ..."
echo "${purple}→ rsync -Prz --info=progress2 ${serverProductionProjectPath}/shared/public/files/ ${serverPreprodProjectPath}/shared/public/files${reset}"
rsync -Prz --info=progress2 ${serverProductionProjectPath}/shared/public/files/ ${serverPreprodProjectPath}/shared/public/files
echo -e "${green}✔${reset} Files directory sync done.\n"

echo -e "${gray}=================================================${reset}\n"

# we update the owner of the preprod public/files
echo "${purple}▶${reset} Updating the preprod public/files owner ..."
echo "${purple}→ chown -R ${serverPreprodUser}:users ${serverPreprodProjectPath}/shared/public/files${reset}"
chown -R ${serverPreprodUser}:users ${serverPreprodProjectPath}/shared/public/files
echo -e "${green}✔${reset} Preprod public/Files owner updated.\n"
