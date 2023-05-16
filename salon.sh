#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\nWelcome to the salon"
echo -e "\nChoose a service:"
MAIN_MENU() {
if [[ $1 ]]
then
echo -e "\n$1"
fi
SERVICES_L=$($PSQL "SELECT * FROM services")
echo "$SERVICES_L" | while read SERVICE_ID BAR NAME
      do
        echo "$SERVICE_ID) $NAME"
      done
  read SERVICE_ID_SELECTED
  IS_CORRECT=$($PSQL "SELECT service_id FROM services WHERE service_id = '$SERVICE_ID_SELECTED'")
  if [[ -z "$IS_CORRECT" ]]
  then
  MAIN_MENU
  else
  PROMPT_FOR_INFORMATION
  fi
}
PROMPT_FOR_INFORMATION() {
  echo -e "\nEnter your phone number:"
  read CUSTOMER_PHONE
  CUSTOMER_NAME_IN_DB=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    if [[ -z "$CUSTOMER_NAME_IN_DB" ]]
    then
    echo -e "\nEnter your name:"
    read CUSTOMER_NAME
    INSERT_CLIENT_INTO_DATABASE=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
    CREATE_APPOINTMENT "$CUSTOMER_NAME"
    else
    CUSTOMER_NAME=$CUSTOMER_NAME_IN_DB
    CREATE_APPOINTMENT "$CUSTOMER_NAME"
    fi
}
  CREATE_APPOINTMENT() {
  CUSTOMER_NAME=$1
  CUSTOMER_NAME=$(echo "$CUSTOMER_NAME" | tr -d '[:space:]')
  echo -e "\nEnter hour of your appointment:"
  read SERVICE_TIME
  GET_CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE name = '$CUSTOMER_NAME'")
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
  CREATING_APPOINTMENT=$($PSQL "INSERT INTO appointments(service_id, customer_id, time) VALUES($SERVICE_ID_SELECTED, $GET_CUSTOMER_ID, '$SERVICE_TIME')")
  SERVICE_TIME=$(echo "$SERVICE_TIME" | tr -d '[:space:]')
  SERVICE_NAME=$(echo "$SERVICE_NAME" | tr -d '[:space:]')
  echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
  echo -e "\nThank you for using our services."
  }
MAIN_MENU
