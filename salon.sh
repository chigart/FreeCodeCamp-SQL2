#! /bin/bash
PSQL="psql --username=postgres --dbname=salon -t --no-align -c"
SERVICES=$($PSQL "SELECT * FROM services")

function main_menu() {
  echo $1
  echo -e "\nWelcome to My Salon, how can I help you?"
  echo "$SERVICES" | sed 's/|/) /'

  read SERVICE_ID_SELECTED
  SERVICE_ID=$($PSQL "SELECT service_id FROM services WHERE service_id=$SERVICE_ID_SELECTED")

  if [[ -z $SERVICE_ID ]]
  then
    main_menu "Incorrect service id: $SELECTED_SERVICE"
  else
    SELECTED_SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID")

    echo -e "\nWhat's your phone number?"
    read CUSTOMER_PHONE
    CURRENT_CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

    if [[ -z $CURRENT_CUSTOMER_ID ]]
    then
      echo "I don't have a record for that phone number, what's your name?"
      read CUSTOMER_NAME

      $PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')"
      CURRENT_CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

      echo "What time would you like your $SELECTED_SERVICE_NAME, Fabio?"
      read SERVICE_TIME

      $PSQL "INSERT INTO appointments(service_id, customer_id, time) VALUES($SERVICE_ID, $CURRENT_CUSTOMER_ID, '$SERVICE_TIME')"

      echo "I have put you down for a cut at $SERVICE_TIME, $CUSTOMER_NAME."
    else 
      echo "What time would you like your $SELECTED_SERVICE_NAME, Fabio?"
      read SERVICE_TIME

      $PSQL "INSERT INTO appointments(service_id, customer_id, time) VALUES($SERVICE_ID, $CURRENT_CUSTOMER_ID, '$SERVICE_TIME')"

      echo "I have put you down for a cut at $SERVICE_TIME, $CUSTOMER_NAME."
    fi
  fi
}

main_menu "~~~~~ ANTOSHKA SALON ~~~~~"