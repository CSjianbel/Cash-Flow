#!/bin/bash

display_account_balance() {
  echo "$(<"$USER_ACCOUNT_FILE")"
}

add_account_balance() {
  amount=$1
  current_balance=$(display_account_balance)

  new_balance=$(echo "$amount" + "$current_balance" | bc)

  echo "$new_balance" > "$USER_ACCOUNT_FILE"
}

view_transactions() {
  echo "Transaction Log:"
  cat "$TRANSACTION_LOG"
}

view_portfolio() {
  echo "Portfolio:"
  cat "$PORTFOLIO_FILE"
}
