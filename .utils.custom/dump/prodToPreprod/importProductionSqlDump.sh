#!/bin/bash

# example

echo "${purple}▶${reset} Importing the sql production dump into the ${purple}${DB_DATABASE}${reset} database ..."
echo "${purple}→ sudo -u ${serverPreprodUser} MYSQL_PWD=${DB_PASSWORD} mysql -u ${DB_USERNAME} -h ${DB_HOST} ${DB_DATABASE} < ${serverProductionSqlDumpStorageDirectory}/dump.sql${reset}"
sudo -u ${serverPreprodUser} MYSQL_PWD=${DB_PASSWORD} mysql ${DB_USERNAME} -h ${DB_HOST} ${DB_DATABASE} < ${serverProductionSqlDumpStorageDirectory}/dump.sql
echo -e "${green}✔${reset} Production sql dump successfully imported into the ${purple}${DB_DATABASE}${reset} database.\n"
