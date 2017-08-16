#!/bin/bash

shopt -s expand_aliases
[[ -f $HOME/.bash_aliases ]] && source $HOME/.bash_aliases

file_name="$HOME/.ssh/config"

function log_and_exec(){
	printf "\n%s ..\n" "$1"
    #echo "${2}"
	eval $2
	printf "Done!\n"
}

function add_entry(){
    ssh_config_entry="Host ${1}\n\tHostname ${2}\n\tUser ${3}\n"
    echo -e "${ssh_config_entry}" >> $file_name
}

function update_property(){
    sed -i "/${1}/,/^\s*$/ s|\(${2} \).*|\1${3}|" $file_name
}

function add_property(){
    sed -i "/${1}/,/^\s*$/ {/^\s*$/ i\
\\\t${2} ${3}
}" $file_name
}

function remove_property(){
    sed -i "/${1}/,/^\s*$/ {/${2}/ d;}" $file_name
}

function remove_entry(){
    sed -i "/${1}/,/^\s*$/d" $file_name
}
