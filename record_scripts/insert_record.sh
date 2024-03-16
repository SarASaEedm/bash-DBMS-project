#!/bin/bash
PS3="Action:"
total_cols="\0"
curr_delim="\0"
DIR="$(pwd)/database"

if [ ! -d $DIR ]
then
    echo "database directory does not exist, please create a DB through 'Create a DB' in the main menu."
    exit
elif [ ! "$(ls -A $1 2>/dev/null)" ] 
then
    echo No $1 database exists, please create a database.
    exit
elif [ ! "$(ls -A $1/$2 2>/dev/null)" ]
then
    echo No $2 table exists, please create a table.
    exit
else
    t_path="$1/$2"
    ht_path="$1/.$2"
    total_cols=$(tail -n1 $ht_path | grep -o ":" | wc -l)
    curr_delim=$(head -n1 $ht_path | cut -d: -f2)
    pk_exists=0;
    if [ $(sed -n 4p $ht_path | cut -d: -f2) == 1 ]
    then
        pk_exists=1
        total_cols=$(($total_cols-1))
    fi
fi

r_enteries=()
for ((i=0; i<=$total_cols; i++))
do
    tmp=$i;
    if [ $pk_exists == 1 ]
    then
        tmp=$((i+2));
        t=$((tmp-1));
        col_name=$(sed -n 3p $ht_path | cut -d: -f$t)
    else
        tmp=$((i+1));
        col_name=$(sed -n 3p $ht_path | cut -d: -f$tmp)
    fi

    if [ $(tail -n1 $ht_path | cut -d: -f$tmp) == 'pk' ];
    then
        o_index=`sed -n 2p $ht_path | cut -d: -f2`
        r_enteries+=("$o_index")

    elif [ $(tail -n1 $ht_path | cut -d: -f$tmp) == 'str' ];
    then
        read -p "Please enter a string for column $col_name: ";
        r_enteries+=( "'$REPLY'" )
    
    elif [ $(tail -n1 $ht_path | cut -d: -f$tmp) == 'int' ]
    then
        read -p "Please enter an integer for column $col_name: ";
        re='^[0-9]+$';
        if ! [[ $REPLY =~ $re ]]
        then
           echo "Input is not an integer" >&2; 
           exit 1
        else
            r_enteries+=( $REPLY )
        fi
    fi
done

if [ $pk_exists == 1 ];
then
    o_index=`sed -n 2p $ht_path | cut -d: -f2`
    n_index=`expr $o_index + 1`
    sed -i "s/index:$o_index/index:$n_index/g" $ht_path
fi

printf -v joined "%s${curr_delim}" "${r_enteries[@]}"
echo "${joined::-${#curr_delim}}" >> $t_path

$(echo )

