#!/bin/bash

# example custom script

echo -e "${gray}=================================================${reset}\n"

echo "${purple}▶${reset} Importing the sql production dump into the ${purple}${DB_DATABASE}${reset} database ..."
echo "${purple}→ sudo -u ${serverPreprodUser} MYSQL_PWD=${DB_PASSWORD} mysql -u ${DB_USERNAME} -h ${DB_HOST} ${DB_DATABASE} < ${serverProductionSqlDumpStoragePath}/dump.sql${reset}"
sudo -u ${serverPreprodUser} MYSQL_PWD=${DB_PASSWORD} mysql -u ${DB_USERNAME} -h ${DB_HOST} ${DB_DATABASE} < ${serverProductionSqlDumpStoragePath}/dump.sql
echo -e "${green}✔${reset} Production sql dump imported into the ${purple}${DB_DATABASE}${reset} database.\n"
