#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n\n ~~  Welcome to my salon  ~~\n\n"

MAIN_MENU(){
  if [[ $1 ]]
  then 
    echo -e "\n$1\n"
  else
    echo -e "Welcome to My Salon, how can I help you?"
  fi

  AVAILABLE_SERVICES=$($PSQL "SELECT name FROM services")
  I=1
  echo "$AVAILABLE_SERVICES"|while read NAME
  do
  echo "$((I++))) $NAME"
  done

  read SERVICE_ID_SELECTED   
  if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
  then
    MAIN_MENU "The selected service does not exist, select again:"
  fi

  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")

  if [[ -z $SERVICE_NAME  ]]
  then
    MAIN_MENU "The selected service does not exist, select again:"
  fi

  echo -e "\nOn what phone number should i make the appointment?"
  read CUSTOMER_PHONE
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")

  if [[ -z $CUSTOMER_ID ]]
  then
    echo -e "\nWelcome to our new member! Could you please provide a name?"
    read CUSTOMER_NAME
    ADD_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name,phone) VALUES('$CUSTOMER_NAME','$CUSTOMER_PHONE')")
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  fi

  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE' ")
  echo -e "\nWhat time would you like your cut,$CUSTOMER_NAME?"
  read SERVICE_TIME
  ADD_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")
  echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME,$CUSTOMER_NAME."
  exit
}

MAIN_MENU
