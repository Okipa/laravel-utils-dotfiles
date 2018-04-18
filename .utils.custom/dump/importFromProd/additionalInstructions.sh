#!/bin/bash

# example

# we sync the production files directory
echo "${purple}▶${reset} Syncing the production files directory ..."
echo "${purple}→ rsync -Prz --info=progress2 ${serverProdUser}@${serverHost}:${serverProductionProjectPath}/shared/public/files/ ${localProductionDumpStoragePath}/files${reset}"
rsync -Prz --info=progress2 ${serverProdUser}@${serverHost}:${serverProductionProjectPath}/shared/public/files/ ${localProductionDumpStoragePath}/files
echo -e "${green}✔${reset} Production files directory synced.\n"
