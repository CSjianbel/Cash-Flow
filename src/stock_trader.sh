#!/bin/bash

source ./utils/util.sh
source ./utils/constants.sh

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
    echo "2. View transactions"
    echo "3. View portfolio"
    echo "4. Fetch stock prices"
    echo "5. Buy stocks"
    echo "6. Sell stocks"
    echo "7. Exit"

    read -p "Enter your choice: " choice

    case $choice in
      1) display_account_balance ;;
      2) view_transactions ;;
      3) view_portfolio ;;
      4) fetch_stock_data ;;
      5) read -p "Enter stock symbol: " symbol
         read -p "Enter quantity: " quantity
         buy_stock "$symbol" "$quantity" ;;
      6) read -p "Enter stock symbol: " symbol
         read -p "Enter quantity: " quantity
         sell_stock "$symbol" "$quantity" ;;
      7) echo "Exiting program..."
         exit ;;
      *) echo "Invalid option. Please choose again." ;;
    esac

    clear_screen_and_wait 
  done
}

fetch_stock_data() {
  aapl=$(get_random_value)
  googl=$(get_random_value)
  msft=$(get_random_value)

  echo "AAPL: $aapl"
  echo "GOOGL: $googl"
  echo "MSFT: $msft"
}

display_account_balance() {
  echo "Your account balance is: \$$(<"$USER_ACCOUNT_FILE")"
}

view_transactions() {
  echo "Transaction Log:"
  cat "$TRANSACTION_LOG"
}

view_portfolio() {
  echo "Portfolio:"
  cat "$PORTFOLIO_FILE"
}

buy_stock() {
  stock_symbol=$1
  quantity=$2

  # Fetch stock data to get current price
  stock_data=$(fetch_stock_data | grep "$stock_symbol")
  stock_price=$(echo "$stock_data" | awk '{print $2}')

  total_cost=$(echo "$stock_price * $quantity" | bc)
  current_balance=$(<"$USER_ACCOUNT_FILE")

  if [ "$(echo "$total_cost <= $current_balance" | bc)" -eq 1 ]; then
    new_balance=$(echo "$current_balance - $total_cost" | bc)
    echo "$new_balance" > "$USER_ACCOUNT_FILE"
    
    # Update portfolio: if the stock is already in the portfolio, update its quantity
    if grep -q "$stock_symbol" "$PORTFOLIO_FILE"; then
      old_quantity=$(grep "$stock_symbol" "$PORTFOLIO_FILE" | awk '{print $2}')
      new_quantity=$((old_quantity + quantity))
      sed -i "s/$stock_symbol $old_quantity/$stock_symbol $new_quantity/" "$PORTFOLIO_FILE"
    else
      echo "$stock_symbol $quantity" >> "$PORTFOLIO_FILE"
    fi
    
    echo "$(date): Bought $quantity shares of $stock_symbol at $stock_price per share" >> "$TRANSACTION_LOG"
    echo "Bought $quantity shares of $stock_symbol at $stock_price per share. Remaining balance: \$$new_balance"
  else
    echo "Insufficient balance to buy $quantity shares of $stock_symbol"
    echo "Current balance: $current_balance"
    echo "Stock price: $stock_price"
    echo "Total cost: $total_cost"
  fi
}

sell_stock() {
  stock_symbol=$1
  quantity=$2

  # Check if the stock exists in the portfolio
  if grep -q "$stock_symbol" "$PORTFOLIO_FILE"; then
    old_quantity=$(grep "$stock_symbol" "$PORTFOLIO_FILE" | awk '{print $2}')
    if [ "$quantity" -le "$old_quantity" ]; then
      # Fetch stock data to get current price
      stock_data=$(fetch_stock_data | grep "$stock_symbol")
      stock_price=$(echo "$stock_data" | awk '{print $2}')

      current_balance=$(<"$USER_ACCOUNT_FILE")
      total_earning=$(echo "$stock_price * $quantity" | bc)
      new_balance=$(echo "$current_balance + $total_earning" | bc)

      # Update portfolio
      new_quantity=$((old_quantity - quantity))
      if [ "$new_quantity" -eq 0 ]; then
        sed -i "/$stock_symbol/d" "$PORTFOLIO_FILE"
      else
        sed -i "s/$stock_symbol $old_quantity/$stock_symbol $new_quantity/" "$PORTFOLIO_FILE"
      fi

      echo "$new_balance" > "$USER_ACCOUNT_FILE"
      echo "$(date): Sold $quantity shares of $stock_symbol at $stock_price per share" >> "$TRANSACTION_LOG"
      echo "Sold $quantity shares of $stock_symbol at $stock_price per share. Current balance: \$$new_balance"
    else
      echo "You do not have enough shares of $stock_symbol to sell"
      echo "Number of shares of $stock_symbol owned: $old_quantity"
    fi
  else
    echo "You do not own $stock_symbol in your portfolio"
  fi
}

main
