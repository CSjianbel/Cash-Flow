#!/bin/bash

source ./functions/accounts.sh
source ./functions/stocks.sh
source ./utils/constants.sh
source ./utils/util.sh

main() {
  # Initialize user's account balance, portfolio and transaction logs
  if [ ! -f "$USER_ACCOUNT_FILE" ]; then
    echo "10000" > "$USER_ACCOUNT_FILE"
  fi
  if [ ! -f "$PORTFOLIO_FILE" ]; then
    touch "$PORTFOLIO_FILE"
  fi
  if [ ! -f "$TRANSACTION_LOG" ]; then
    touch "$TRANSACTION_LOG"
  fi

  while true; do
    clear
    echo "Welcome to the stock trading simulator!"
    echo "1. Display account balance"
    echo "2. Add account balance"
    echo "3. View transactions"
    echo "4. View portfolio"
    echo "5. Fetch stock prices"
    echo "6. Buy stocks"
    echo "7. Sell stocks"
    echo "8. Exit"

    read -p "Enter your choice: " choice

    case $choice in
      1) account_balance=$(display_account_balance)
         echo "Your current account balance is \$${account_balance}" ;;
      2) read -p "Enter amount to add: " amount
         add_account_balance "$amount" ;;
      3) view_transactions ;;
      4) view_portfolio ;;
      5) fetch_stock_data ;;
      6) read -p "Enter stock symbol: " symbol
         read -p "Enter quantity: " quantity
         buy_stock "$symbol" "$quantity" ;;
      7) read -p "Enter stock symbol: " symbol
         read -p "Enter quantity: " quantity
         sell_stock "$symbol" "$quantity" ;;
      8) echo "Exiting program..."
         exit ;;
      *) echo "Invalid option. Please choose again." ;;
    esac

    clear_screen_and_wait 
  done
}

main
