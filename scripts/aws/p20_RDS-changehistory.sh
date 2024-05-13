#!/bin/bash

YEAR=$(date +'%Y')
DATE=$(date +%F)

TEMP_OUTPUT="/tmp/rdschangehistory.txt"
FINAL_OUTPUT="general/p-20/$YEAR/$DATE.rdschangehistory.txt"

# Fetch configuration change history of a specific AWS RDS DB Instance
aws configservice get-resource-config-history --resource-type AWS::RDS::DBInstance \
    --resource-id app57-cluster --region us-east-1 --output text > "$TEMP_OUTPUT"

# Check if the final output file already exists
if [ -f "$FINAL_OUTPUT" ]; then
    # If the file exists, check if there are differences between the temporary and the final output
    if ! diff "$TEMP_OUTPUT" "$FINAL_OUTPUT" > /dev/null; then
        # If differences exist, update the final output with the latest changes
        cp "$TEMP_OUTPUT" "$FINAL_OUTPUT"
    fi
else
    # If the final output file does not exist, copy the temporary file to create a new final output
    cp "$TEMP_OUTPUT" "$FINAL_OUTPUT"
fi
