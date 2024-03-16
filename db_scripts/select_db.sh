#!/bin/bash

PS3="Choose:"
DIR="$(pwd)/database"

# Check if there are databases to select
if [ ! -d "$DIR" ] || [ -z "$(ls -A "$DIR" 2>/dev/null)" ]; then
    echo 'No databases to select' >&2  
    exit 1  
fi


while true; do
    select select_db in $(ls "$DIR"); do
        if [ -n "$select_db" ] && [ -d "$DIR/$select_db" ]; then
            cd "$DIR/$select_db" || exit 1  
            echo "$(pwd)"  
            exit 0  # Exit the script with a success status
        else
            echo 'Invalid selection' >&2  
            exit 1  # Exit with non-zero status to indicate error
        fi
    done
done

