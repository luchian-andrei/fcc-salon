#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ UNDOO SALON ~~~~~\n"

echo Welcome to Undoo\'s Salon, how can i help you ? 


MAIN_MENU(){
AVAILABLE_SERVICES=$($PSQL"SELECT * FROM services")
echo "$AVAILABLE_SERVICES" | while read SERVICE_ID BAR SERVICE_NAME BAR
do
echo "$SERVICE_ID) $SERVICE_NAME"
done


read SERVICE_ID_SELECTED
if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
then
echo -e "\nPlease select a valid number\n"
MAIN_MENU
else
SERVICE_AVAILABILITY=$($PSQL"SELECT service_id FROM services WHERE service_id=$SERVICE_ID_SELECTED")
SERVICE_NAME_SELECTED=$($PSQL"SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
if [[ -z $SERVICE_AVAILABILITY ]]
then
echo -e "\nI could not find that service. What would you like today?\n" 
MAIN_MENU

else 
echo -e "\nWhat's your phone number?"
fi

read CUSTOMER_PHONE
EXISTENT_PHONE_NUMBER=$($PSQL"SELECT phone FROM customers WHERE phone = '$CUSTOMER_PHONE'")
if [[ -z $EXISTENT_PHONE_NUMBER ]]
then
#insert number into db
#ask for name 
echo -e "\nI don't have a record for that phone number, what's your name?"
read CUSTOMER_NAME

INSERT_CUSTOMER=$($PSQL "INSERT INTO customers(phone, name) VALUES ('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")

echo -e "\nWhat time would you like your $SERVICE_NAME_SELECTED, $CUSTOMER_NAME?"

read SERVICE_TIME
echo -e "\nI have put you down for a $SERVICE_NAME_SELECTED at $SERVICE_TIME, $CUSTOMER_NAME."


else
EXISTENT_CLIENT_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
echo -e "\nWhat time would you like your $SERVICE_NAME_SELECTED, $EXISTENT_CLIENT_NAME?"
read SERVICE_TIME
echo -e "\nI have put you down for a $SERVICE_NAME_SELECTED at $SERVICE_TIME, $EXISTENT_CLIENT_NAME."
fi
GET_CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
echo "CUSTOMER: $GET_CUSTOMER_ID,SERVICE: $SERVICE_ID_SELECTED"
INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($GET_CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
fi
}


# SERVICE_ID_SELECTED
# CUSTOMER_PHONE
# CUSTOMER_NAME 
# SERVICE_TIME




MAIN_MENU
