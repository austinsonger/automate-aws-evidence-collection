#!/bin/bash


YEAR=$(date +'%Y')
DATE=$(date +%F)

# Set your Okta domain and API token
OKTA_DOMAIN=${OKTA_DOMAIN}
API_TOKEN=${OKTA_API_TOKEN}

# Create the output directory if it doesn't exist
OUTPUT_DIR="lists/$(date +'%Y')/okta"
mkdir -p "$OUTPUT_DIR"

# Set the output file path
OUTPUT_FILE="$OUTPUT_DIR/$(date +%F).okta-deactivated-users.json"

# Fetch the list of deactivated users
USERS=$(curl -s -X GET "https://${OKTA_DOMAIN}/api/v1/users?filter=status eq \"DEPROVISIONED\"" -H "Authorization: SSWS ${API_TOKEN}" -H "Accept: application/json")

# Save the users to the output file
echo "$USERS" > "$OUTPUT_FILE"

echo "Deactivated users have been saved to $OUTPUT_FILE"
