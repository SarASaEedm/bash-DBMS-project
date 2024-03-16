#!/bin/bash
cd $1
while true
do
  echo -e "Table Name: \c"
  read tableName
  # Check if the table name adheres to the constraints
  if [[ ${#tableName} -gt 30 ]]; then
    echo "Error: Table name exceeds the maximum length of 30 characters."
  elif [[ ! "$tableName" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]; then
    echo "Invalid table name. Table names must start with a letter or underscore, followed by letters, numbers, or underscores."
  elif [[ -f "$tableName".SQL ]]; then
    echo "Table already exists. Choose another name."
  else
    break
  fi
done

  PS3="Table Creation Action:"
  echo -e "Number of Columns: \c" 
  read colsNum 
  if [ -z "${colsNum##*[!0-9]*}" ] 
  then
  echo "Error, Enter a number"; exit;
  else

  counter=1 
  sep=":" 
  m_sep="^_^" #Table separator
  trig="0" #Flag for creating primary key

  echo "Do you want add primary key?" 
  select approve in "yes" "no"
  do 
  case $approve in
    yes ) p_key="1"
          colType="pk";
          type=$type${colType}$sep; 
          trig="1";
          break;;
    no )  p_key="0";break ;;
    * ) 
      echo "Invalid Choice";;
    esac 
  done

  while [ $counter -le $colsNum ]
  do
    echo -e "Name of Column No.$counter: \c"
    read colName
      # Check if the column name adheres to the constraints
    if [[ ! "$colName" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]; then
        echo "Invalid column name. Column names must start with a letter or underscore, followed by letters, numbers, or underscores."
        continue
    fi

    echo -e "Type of Column $colName: \c"

    select var in "int" "str"; do
      case $var in
        int ) colType="int"
              type=$type${colType}$sep
              tab=$tab${colName}$m_sep
              break;;
        str ) colType="str"
              type=$type${colType}$sep
              tab=$tab${colName}$m_sep
              break;;
        * )   echo "Invalid Choice" ;;
      esac
    done

    if [[ $counter == $colsNum ]]; then
      temp=$temp$colName
    else
      temp=$temp$colName$sep
    fi

    ((counter++))
  done

  tab="${tab::-${#m_sep}}" 

  p1="pk$m_sep"
  p2="$tab"
  if [ $trig == "1" ]
  then
  p_ki="$p1$p2" #Metadata if there is a primary key
  fi 
  
  Metadata="m_sep:$m_sep\nindex:1\ncol_names:$temp\np_key:$p_key\ndata_types:${type::-1}" #Assigning the Metadata key, and removing last separator
  
  #Creating table and hidden table
  touch .$tableName.SQL
  echo -e $Metadata  >> ".$tableName.SQL"
  touch $tableName.SQL
  if [ $trig == "1" ]
  then
  echo -e $p_ki >> "$tableName.SQL"
  else
  echo -e $tab >> "$tableName.SQL"
  fi

  if [[ $? == 0 ]] #Validation of creation
  then
    echo "Table Created Successfully"
    exit
  else
    echo "Error Creating Table $tableName"
    exit
  fi
  fi
