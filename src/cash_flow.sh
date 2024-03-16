#!/bin/bash

source ./functions/add_account.sh
source ./functions/view_transaction.sh
source ./functions/view_account/view_account.sh

main() {
  main_dialog
}

main_dialog() {
  while true; do
      local choice=$(dialog --clear \
                      --backtitle "Money Tracker Menu" \
                      --title "Main Menu" \
                      --menu "Choose an option:" \
                      15 50 5 \
                      1 "Add Account" \
                      2 "View Account" \
                      3 "View All Transactions" \
                      4 "Exit" \
                      2>&1 >/dev/tty)

      case $choice in
          1)
              add_account_dialog
              ;;
          2)
              view_account
              ;;
          3)
              view_transactions
              ;;
          4)
              break
              ;;
      esac
  done
}

main
