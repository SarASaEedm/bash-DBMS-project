#!/bin/bash
PS3="Selection Action:"
total_cols="\0"
curr_delim="\0"
DIR="$(pwd)/database"

# Validation for database folder
if [ ! -d $DIR ]; then
    echo "database directory does not exist, please create a DB through 'Create a DB' in the main menu."
    exit

elif [ ! "$(ls -A $1 2>/dev/null)" ]; then
    echo No $1 database exists, please create a database.
    exit
elif [ ! "$(ls -A $1/$2 2>/dev/null)" ]; then
    echo No $2 table exists, please create a table.
    exit
else
    # Declare constraints from metadata and table
    t_path="$1/$2"
    ht_path="$1/.$2"
    total_cols=$(tail -n1 $ht_path | grep -o ":" | wc -l) #the number of cols from metadata
    curr_delim=$(head -n1 $ht_path | cut -d: -f2) #the current delimiter from metadata
    total_records=$(wc -l $t_path | cut -d' ' -f1) #the current delimiter from metadata
fi

select s_options in "Select ALL" "Select WHERE" "Quit"; do
    case $s_options in
        "Select ALL" )
            # Display headers
            echo
            sed -n 5p "$ht_path" | sed 's/:/ : /g'
            echo
            sed -n 3p "$ht_path" | sed 's/:/  : /g'
            echo -------------------------------------

            # Display content
            while IFS= read -r line; do
                echo "$line" | sed 's/\^\_\^/ : /g'
            done < "$t_path"

            echo -------------------------------------
            ;;

        "Select WHERE" )
            sel_list=$(sed -n 3p $ht_path)
            sel_list=${sel_list:10} # Remove col_name from the hidden file
            valid_options=()

            for col in $(echo $sel_list | sed 's/:/ /g'); do
                valid_options+=("$col")
            done
            valid_options+=("Quit")

            # Get user input for the column selection
            while true; do
                echo "Which column do you wish to search by?"
                for ((i = 1; i <= ${#valid_options[@]}; i++)); do
                    echo "$i) ${valid_options[i - 1]}"
                done
                read -p "Selection Action: " user_input

                if [[ $user_input -ge 1 && $user_input -le ${#valid_options[@]} ]]; then
                    break
                else
                    echo "Invalid option. Please choose a valid column."
                fi
            done

            # Corrected index assignment for the selected column
            picked_field=$((user_input))
            select_col=${valid_options[picked_field - 1]}
            
            if [ "$select_col" == "Quit" ]; then
                exit
            fi

            read -p "What do you want to match in column $select_col? "
            echo
            sed -n 5p $ht_path | sed 's/:/ : /g'
            echo
            sed -n 3p $ht_path | sed 's/:/  : /g'
            echo -------------------------------------
            # to filter and display the matched records
            result=$(grep -w "$REPLY" "$t_path" | sed 's/\^\_\^/ | /g')

            if [ -z "$result" ]; then
                echo "No matching records found."
            else
                echo "$result" | more
            fi

            echo -------------------------------------
            ;;
        "Quit" )
            exit
            ;;

        * )
            echo "Invalid option. Please choose a valid option."
            ;;
    esac
done

