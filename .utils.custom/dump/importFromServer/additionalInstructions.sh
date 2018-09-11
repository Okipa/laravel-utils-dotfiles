#!/bin/bash

# example

echo "${purple}▶${reset} Syncing the production storage/app directory ..."
echo "${purple}→ rsync -Prz --info=progress2 ${sshConnexionUser}@${serverHost}:${serverProjectPath}/shared/storage/app/ ${localDumpStoragePath}/app${reset}"
rsync -Prz --info=progress2 ${sshConnexionUser}@${serverHost}:${serverProjectPath}/shared/storage/app/ ${localDumpStoragePath}/app
echo -e "${green}✔${reset} Production public directory synced.\n"
