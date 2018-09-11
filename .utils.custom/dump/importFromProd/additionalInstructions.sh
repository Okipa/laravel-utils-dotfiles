#!/bin/bash

# example

echo "${purple}▶${reset} Syncing the production storage/app directory ..."
echo "${purple}→ rsync -Prz --info=progress2 ${serverProdUser}@${serverHost}:${serverProductionProjectPath}/shared/storage/app/ ${localProductionDumpStoragePath}/app${reset}"
rsync -Prz --info=progress2 ${serverProdUser}@${serverHost}:${serverProductionProjectPath}/shared/storage/app/ ${localProductionDumpStoragePath}/app
echo -e "${green}✔${reset} Production public directory synced.\n"
