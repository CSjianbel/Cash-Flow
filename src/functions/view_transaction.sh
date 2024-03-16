#!/bin/bash

# TODO: Fix formatting
view_transactions() {
    local transactions=$(awk -F ',' 'BEGIN {printf "%-20s   |   %-10s   |   %s\n", "Account", "Amount", "Date & Time"; printf "%s\n", "-------------------------------------------------------------"} {printf "%-20s   |   %-10s   |   %s\n", $1, $2, $3}' database.csv)
    
    dialog --clear \
           --backtitle "View Transactions" \
           --title "Transactions" \
           --msgbox "$transactions" 20 80
}

