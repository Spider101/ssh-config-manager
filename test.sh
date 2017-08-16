#!/bin/bash

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

source ./ssh_config_manager.sh
run
