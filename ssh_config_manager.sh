#!/bin/bash

file_name="$HOME/config"

function log_and_exec(){
	printf "\n%s ..\n" "$1"
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

function menu(){
    menu_list=("Show Config" "Add Entry" "Add Property"  "Update Property" "Remove Property" "Remove Entry" 'Quit')
    PS3=$'\n'"Choose action: "
    select action in "${menu_list[@]}"
    do
        case $action in
            'Show Config')
                log_message='Displaying details of config file'
                log_and_exec "${log_message}" "cat $file_name"
                return 1
                ;;
            'Add Entry')
                read -p 'Enter host alias: ' host
                read -p 'Enter hostname: ' hostname
                read -p 'Enter username: ' user
                log_message='Adding an entry in the config file'
                log_and_exec "$log_message" "add_entry ${host} ${hostname} ${user}"
                return 1
                ;;
            'Add Property')
                read -p 'Enter host alias: ' host
                read -p 'Enter property name: ' prop_key
                read -p 'Enter property value: ' prop_val
                log_message="Adding a property to the ${host} host in the config file"
                log_and_exec "$log_message" "add_property ${host} ${prop_key} ${prop_val}"
                return 1
                ;;
            'Update Property')
                read -p 'Enter host alias: ' host
                read -p 'Enter property name: ' prop_key
                read -p 'Enter property value: ' prop_val
                log_message="Updating property ${prop_key} of ${host} host in the config file"
                log_and_exec "$log_message" "update_property ${host} ${prop_key} ${prop_val}"
                return 1
                ;;
            'Remove Property')
                read -p 'Enter host alias: ' host
                read -p 'Enter property name: ' prop_key
                log_message="Removing property ${prop_key} of ${host} host in the config file"
                log_and_exec "$log_message" "remove_property ${host} ${prop_key}"
                return 1
                ;;
            'Remove Entry')
                read -p 'Enter host alias: ' host
                log_message="Removing ${host} host in the config file"
                log_and_exec "$log_message" "remove_entry ${host}"
   echo -e '\nWork In Progress'
                return 1
                ;;
            Quit)
                return 0
                ;;
            *)
                echo -e 'Invalid choice. Please choose again\n'
                ;;
        esac
    done
}

function run(){
    is_complete=1
    while [[ $is_complete -gt 0 ]]
    do
        menu
        is_complete=$?
    done
    echo -e "\nThank you for using the ssh config manager!"
}

run
