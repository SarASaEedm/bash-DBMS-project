#!/bin/bash

# Function to check if the input follows the naming constraints
function check_input {
    local input=$1
    if [[ "$input" == *" "* ]]; then
        echo "Error: Database name cannot contain spaces."
        return 1
    fi
    if [[ "$input" =~ ^[0-9] ]]; then
        echo "Error: Database name cannot start with a number."
        return 1
    fi
    if [[ ! "$input" =~ ^[a-zA-Z0-9_]+$ ]]; then
        echo "Error: Database name cannot contain special characters."
        return 1
    fi
    return 0
}

PS3="Choose:"

if [ ! "$(ls -A $(pwd)/database/ 2>/dev/null)" ]; then
    echo "No databases to rename"
    exit
else 
    echo -e "Enter Current Database Name: \c" 
    read db_name

    # Check if the name exists
    if [ ! -d "database/$db_name" ]; then
        echo "Error: Database named $db_name does not exist."
        exit
    fi
    
    echo -e "Enter New Database Name: \c"
    
    # Loop until a valid new database name is entered
    while true; do
        read db_new_name 

        if check_input "$db_new_name"; then
            break  
        else
            echo -e "Enter New Database Name (Valid name required): \c"
        fi
    done

    DIR="database/$db_new_name"
    if [ -d "$DIR" ]; then
        echo "Error: The new name already exists. Please choose another one."
    else
        mv "database/$db_name" "$DIR" 2>/dev/null
        if [[ $? == 0 ]]; then
            echo "Database Renamed Successfully to $db_new_name"
        else
            echo "Error Renaming Database: Something went wrong."
        fi
    fi
fi
