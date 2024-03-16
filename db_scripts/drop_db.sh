#!/bin/bash

PS3="Database to Drop:"
database_dir="$(pwd)/database/"

if [ ! "$(ls -A $database_dir 2>/dev/null)" ]; then
    echo "No databases to drop"
    exit
else
    echo "Choose a DB Number To Drop"
fi

select drop_db in $(ls $database_dir); do
    if [ "$drop_db" ]; then
        read -p "Are you sure you want to delete $drop_db ? (Y/N): " reply
        case $reply in
            [yY]*) 
                rm -r "$database_dir/$drop_db"
                echo "$drop_db has been Deleted Successfully"
                exit
            ;;
            [nN]*) 
                echo "Operation Canceled"
                exit
            ;;
            *) 
                echo "Invalid option"
                exit
            ;;
        esac
    else
        echo "Invalid option"
    fi
done

