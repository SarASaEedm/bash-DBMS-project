#!/bin/bash

# Function to check if the input follows the naming constraints
function check_input {
    local input=$1
    if [[ "$input" == *" "* ]]; then
        echo "Error: Database name cannot contain spaces."
        exit 1
    fi
    if [[ "$input" =~ ^[0-9] ]]; then
        echo "Error: Database name cannot start with a number."
        exit 1
    fi
    if [[ ! "$input" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]; then
        echo "Error: Database name cannot contain special characters except underscore and cannot start with an underscore."
        exit 1
    fi
}

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <database_name>"
    exit 1
fi

check_input "$1"

DIR="database/$1"

if [ ! -d "$DIR" ]; then
    mkdir -p "$DIR"
    chmod a+x "$DIR"
    if [[ $? == 0 ]]; then
        echo "$1 Database created successfully"
    else
        echo "Error creating database $1"
    fi
else
    echo "$1 Database already exists or input is incorrect"
    exit 1
fi

