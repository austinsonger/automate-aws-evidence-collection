#!/bin/bash

# Define YEAR and DATE
YEAR=$(date +'%Y')
DATE=$(date +'%Y-%m-%d')

# Directory for snapshots
mkdir -p lists/snapshots/$YEAR

# List RDS snapshots and write to file
aws rds describe-db-snapshots --output text > "lists/snapshots/$YEAR/$DATE_db_snapshots.txt"

if [ $? -ne 0 ]; then
    echo "Failed to list RDS snapshots." >> lists/snapshots/$YEAR/$DATE_db_snapshots.txt
fi
