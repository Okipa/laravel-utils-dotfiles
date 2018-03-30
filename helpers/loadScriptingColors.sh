#!/usr/bin/env bash

# we only want to load the scripting colors variables once during a multiple scripts sequence
if [ ! $ALREADY_LOADED_COLORS ] ; then

    # we load the scripting colors variables
    purple=`tput setaf 12`
    gray=`tput setaf 8`
    green=`tput setaf 2`
    red=`tput setaf 1`
    reset=`tput sgr0`

    echo -e "\n${gray}=================================================${reset}\n"

    echo "${purple}▶${reset} Loading the scripting colors ..."

    # we set the scripting colors variables as already loaded
    ALREADY_LOADED_COLORS=true

    echo -e "${green}✔${reset} Scripting colors loaded.\n"
fi
