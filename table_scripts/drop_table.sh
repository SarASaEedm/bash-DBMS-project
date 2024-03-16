#!/bin/bash

PS3="Choose:"
if [ ! "$(ls -A $1 2>/dev/null)" ]; then
    echo "No Tables to delete"
    exit
else 
    echo "Choose a Table Number To delete"
fi
# array
table_names=($(ls $1))

select drop_tb in "${table_names[@]}"; do
    # Check if the selected table name is in the array of table names
    if [[ " ${table_names[*]} " == *" $drop_tb "* ]]; then
        read -p "Are you sure you want to delete $drop_tb ? (Y/N): "
        case $REPLY in
            [yY]*) 
                rm "$1/$drop_tb" 
                rm "$1/.$drop_tb"
                echo "$drop_tb has been Deleted Successfully"
                exit
                ;;
            [nN]*) 
                echo "Operation Canceled"
                exit
                ;;
            *) 
                echo "Invalid option"
                ;;
        esac
    else
        echo "Invalid option. Please select a valid table number."
    fi
done

