#!/bin/bash

if [ -z $ALREADY_LOADED_COLORS ] ; then

    echo -e "\n${gray}=================================================${reset}\n"

    echo "${purple}▶${reset} Loading the scripting colors ..."
    purple=`tput setaf 12`
    gray=`tput setaf 8`
    green=`tput setaf 2`
    red=`tput setaf 1`
    reset=`tput sgr0`
    ALREADY_LOADED_COLORS=true
    echo -e "${green}✔${reset} Scripting colors loaded.\n"
fi
