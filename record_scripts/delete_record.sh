#!/bin/bash
PS3="Action: "
t_path="$1/$2"
ht_path="$1/.$2"

curr_delim=$(head -n1 $ht_path | cut -d: -f2) # provides current delimeter from metadata
escaped_delim=$(echo $curr_delim | sed 's/[^^\\]/[&]/g; s/\^/\\^/g; s/\\/\\\\/g') # delimiter sanitized from regex chars
 

if [[ -f $t_path ]]; 
    then
	awk -F"$escaped_delim" -v OFS="$escaped_delim" '{if(NR==1){print $0}}' $t_path;
	# Extract valid column names
    valid_cols=$(head -n1 "$t_path" | sed "s/$escaped_delim/\n/g")
	
    while true; do
        read -p "Enter column to delete record from ($valid_cols): " colName
        if echo "$valid_cols" | grep -qw "$colName"; then
            break
        else
            echo "Invalid column name. Please choose a valid column name."
        fi
    done
	read -p "Enter value : " Value; 
	str=\'$Value\' # Regex for string values
	awk -F"$escaped_delim" -v OFS="$escaped_delim" '
	{
		if(NR==1){
			for(i=1;i<=NF;i++){
				if($i=="'$colName'"){here=i;}
			}
		}
		else{
			if($here=='$Value' || $here=="'$str'"){
				target=NR
			}
		}
		{
		if(NR!=target)print 
		}
	}' $t_path > tmp && mv tmp $t_path; 
else
	echo "Worng Pick"
	exit
fi
