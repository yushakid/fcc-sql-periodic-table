#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

MAIN_MENU(){

  if [ $# -gt 0 ];
  then
    ELEMENT_VALUES=$($PSQL "select atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius from elements 
                          inner join properties using (atomic_number)
                          inner join types using (type_id)
                          where CAST(atomic_number AS TEXT) = '$1'
                          or symbol = '$1'
                          or name = '$1'")
    IFS='|' read -r ATOMIC_NUMBER SYMBOL NAME TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT <<< "$ELEMENT_VALUES"
    if [[ -z $ATOMIC_NUMBER ]]
    then
      echo I could not find that element in the database.
    else
      ELEMENT $ATOMIC_NUMBER $SYMBOL $NAME
    fi
  else
    echo Please provide an element as an argument.
  fi

}

ELEMENT(){

  #ELEMENT_PROPERTIES=$($PSQL "select type, atomic_mass, melting_point_celsius, boiling_point_celsius 
                              #from properties where atomic_number = $ATOMIC_NUMBER")
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."

}

MAIN_MENU $1

