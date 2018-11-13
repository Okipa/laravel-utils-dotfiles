#!/bin/bash

# example custom script

echo "${purple}▶${reset} Syncing the production storage/app directory with the preprod ..."
echo "${purple}→ sudo rsync -Prz --info=progress2 ${serverProductionProjectPath}/shared/storage/app/ ${serverPreprodProjectPath}/shared/storage/app${reset}"
sudo rsync -Prz --info=progress2 ${serverProductionProjectPath}/shared/storage/app/ ${serverPreprodProjectPath}/shared/storage/app
echo -e "${green}✔${reset} Production storage/app directory sync done with the preprod.\n"

echo -e "${gray}=================================================${reset}\n"

echo "${purple}▶${reset} Updating the preprod storage/app owner ..."
echo "${purple}→ sudo chown -R ${serverPreprodUser}:${serverPreprodGroup} ${serverPreprodProjectPath}/shared/storage/app${reset}"
sudo chown -R ${serverPreprodUser}:${serverPreprodGroup} ${serverPreprodProjectPath}/shared/storage/app
echo -e "${green}✔${reset} Preprod storage/app owner updated.\n"
