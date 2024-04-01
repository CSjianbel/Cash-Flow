#!/bin/bash

# Delete .txt files if they exist
if [ -e .*.txt ]; then
    rm .*.txt
fi

# Delete .csv files if they exist
if [ -e .*.csv ]; then
    rm .*.csv
fi

echo "Cleaned file databases!"
