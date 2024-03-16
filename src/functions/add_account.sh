#!/bin/bash

add_account_dialog() {
    # Prompt the user for the account name using dialog
    local account_name=$(dialog --clear \
                    --backtitle "Add New Account" \
                    --inputbox "Enter the name of the account:" 8 40 \
                    2>&1 >/dev/tty)

    # Check if the user canceled
    if [ $? -ne 0 ]; then
        echo "Operation canceled."
        exit 1
    fi

    # Check if the account already exists
    if grep -q "^$account_name$" database.csv ; then
        dialog --clear \
               --backtitle "Add New Account" \
               --msgbox "account '$account_name' already  exists." 6 40
    else
        # Add the account to the accounts file
        local current_date_time=$(date +"%Y-%m-%d %H:%M:%S")
        echo "$account_name,0,$current_date_time" >> database.csv
        dialog --clear \
               --backtitle "Add New Account" \
               --msgbox "Account '$account_name' added successfully." 6 40
    fi
}


