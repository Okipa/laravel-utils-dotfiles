#!/usr/bin/env bash

# example

# we generate a public/files archive and store it the /tmp/prod/delegations_dump directory
echo "${purple}▶${reset} Copying the production public/files directory to the preprod project ..."
echo "${purple}→ rm -rf ${preprodProjectPath}/shared/public/files${reset}"
rm -rf ${preprodProjectPath}/shared/public/files
echo "${purple}→ rsync ${productionProjectPath}/shared/public/files/ ${preprodProjectPath}/shared/public/files${reset}"
rsync ${productionProjectPath}/shared/public/files/ ${preprodProjectPath}/shared/public/files
echo "${purple}→ chown -R ${preprodUser}:users ${preprodProjectPath}/shared/public/files${reset}"
chown -R ${preprodUser}:users ${preprodProjectPath}/shared/public/files
echo -e "${green}✔${reset} files directory copied with success.\n"
