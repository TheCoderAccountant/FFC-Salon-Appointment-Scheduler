#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"

echo -e "\nWelcome to My Salon, how can I help you?\n"

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
# List all services
  SERVICE_LIST=$($PSQL "SELECT service_id, name FROM services")
    echo "$SERVICE_LIST" | while read SERVICE_ID BAR NAME
  do
    echo  "$SERVICE_ID) $NAME"
  done 
# Get customer selection
  read SERVICE_ID_SELECTED 
  SERV_OPT=$($PSQL "SELECT service_id, name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
# If customer choose option out of list
  if [[ -z $SERV_OPT ]]
# send back to main menu
     then 
     MAIN_MENU "I could not find that service. What would you like today?"
  else 
# get phone number of customer for reservation
      echo -e "\nWhat's your phone number?" 
      read CUSTOMER_PHONE
# check customer for registration 
      CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

# if not registered before
              if [[ -z $CUSTOMER_ID ]]
              then 
# get customer name for registration        
              echo -e "\nI don't have a record for that phone number, what's your name?"
              read CUSTOMER_NAME
# Insert new customer in database              
              INSERT_CUSTOMER=$($PSQL "INSERT INTO customers(phone,name) VALUES('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
              else
                CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE customer_id='$CUSTOMER_ID'")
              fi
# get service name
                SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
# get appointment time                
                echo -e "\nWhat time would you like your$SERVICE_NAME,$CUSTOMER_NAME??"
                read SERVICE_TIME


                CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
                INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")   
                echo  "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
                                  
              
  fi
}


MAIN_MENU
