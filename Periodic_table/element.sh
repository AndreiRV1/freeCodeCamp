#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"



find_element () {
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ELEMENT_SEARCH=$($PSQL "SELECT symbol,name,type,atomic_mass,melting_point_celsius,boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number = $1")
    if [[ -z $ELEMENT_SEARCH ]]
    then
      echo I could not find that element in the database.
      exit
    fi
    IFS="|" read SYMBOL NAME TYPE MASS MP BP<<< $ELEMENT_SEARCH
    echo "The element with atomic number $1 is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MP celsius and a boiling point of $BP celsius."
  fi
}



if [[ -z $1 ]]
then
  echo Please provide an element as an argument.
  exit
fi

if [[ $1 =~ ^[0-9]+$ ]]
then
  find_element $1
  exit
else
  ATOMIC_NUMBER_SEARCH_BY_SYMBOL=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1'")
  ATOMIC_NUMBER_SEARCH_BY_NAME=$($PSQL "SELECT atomic_number FROM elements WHERE name='$1'")
  if [[ -z $ATOMIC_NUMBER_SEARCH_BY_SYMBOL && -z $ATOMIC_NUMBER_SEARCH_BY_NAME ]] 
  then
    echo I could not find that element in the database.
  fi
  find_element $ATOMIC_NUMBER_SEARCH_BY_SYMBOL
  find_element $ATOMIC_NUMBER_SEARCH_BY_NAME
fi


