#!/bin/bash

clear_screen_and_wait() {
  read -n 1 -s -r -p "Press any key to continue..."
  clear
}

# Function to generate a random floating-point number between 1 and 100
get_random_value() {
  random_int=$((RANDOM % 10000 + 1))
  random_float=$(echo "scale=2; $random_int / 100" | bc)

  echo "$random_float"
}
