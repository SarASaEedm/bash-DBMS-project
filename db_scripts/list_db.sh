#!/bin/bash
if [ ! -d "$(pwd)/database" ] 
then
    echo "database directory does not exist, please create a DB through 'Create a DB' in the main menu."
elif [ ! "$(ls -A $(pwd)/database/ 2>/dev/null)" ] 
then
    echo No databases exist, please create a database.
else
    ls database 2>/dev/null  
fi
