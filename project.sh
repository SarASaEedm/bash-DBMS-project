#!/bin/bash

PS3="Main Action:"
mkdir -p database 
find ~+ -type f | xargs chmod a+x 
find ~+ -type d | xargs chmod a+x
echo "Please choose an action:"
curr_db="\0" 

while true; do
    select db_input in "Create DB" "List DBs" "Connect to DB" "Drop DB" "Rename DB" "Exit DBMS"; do
        case $db_input in
            "Create DB" )
                echo -e "Enter DB name: \c"
                read
                db_scripts/create_db.sh $REPLY
                ;;
            "List DBs" )
                db_scripts/list_db.sh 
                ;;
            "Connect to DB" )
                curr_db=$(db_scripts/select_db.sh $REPLY)
                if [ $? -ne 0 ]; then
                    echo "Please choose an existing database."
                    continue
                fi

                echo "Database selected is: $curr_db"

    while true; do
        select t_choice in "List Existing Tables" "Create New Table" "Drop Table" "Insert Into Table" "Select From Table" "Delete From Table" "Update Table" "Back To Main Menu" "Exit"; do
            PS3="Table Action:" 
            case $t_choice in
                "List Existing Tables" )  
                    bash table_scripts/list_tables.sh $curr_db
                    ;;
                "Create New Table" )  
                    bash table_scripts/create_table.sh $curr_db
                    ;;
                "Drop Table" )  
                    bash table_scripts/drop_table.sh $curr_db
                    ;;
                "Insert Into Table" )
                    select select_table in $(ls $curr_db); do
                        if [ -n "$select_table" ]; then
                         bash   record_scripts/insert_record.sh $curr_db $select_table
                            break
                        else
                            echo "Invalid option. Please choose a valid table."
                        fi
                    done
		    ;;

                "Select From Table" )
                    select select_table in $(ls $curr_db); do
                        if [ -n "$select_table" ]; then
                         bash   record_scripts/select_record.sh $curr_db $select_table
                            break
                        else
                            echo "Invalid option. Please choose a valid table."
                        fi
                    done
                    ;;
                    
                "Delete From Table" )
                    echo "Pick a table: "
                    select select_table in $(ls $curr_db); do
                    if [ -n "$select_table" ]; then
                       bash record_scripts/delete_record.sh $curr_db $select_table
                        break
                        else
                            echo "Invalid option. Please choose a valid table."
                        fi
                    done
                    ;;
                    
                "Update Table" )
                    select select_table in $(ls $curr_db); do
                    if [ -n "$select_table" ]; then
                      bash  record_scripts/update_record.sh $curr_db $select_table
                        break
                        else
                            echo "Invalid option. Please choose a valid table."
                        fi
                    done
                    ;;
                    
                "Back To Main Menu" )
                    break
                    ;;
                "Exit" )  
                    exit 
                    ;;
                * )
                    echo "Invalid Input"
                    ;;
            esac
        done
    done
                ;;
            "Drop DB" )
                db_scripts/drop_db.sh 
                ;;
            "Rename DB" )
                db_scripts/rename_db.sh
                ;;
            "Exit DBMS" )
                exit
                ;;
            * )
                echo "Not valid input, please choose a number from the menu."
                ;;
        esac
    done
done

