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
OUTPUT_FILE="$OUTPUT_DIR/$DATE.okta-users-groups.json"

# Fetch the list of users
USERS=$(curl -s -X GET "https://${OKTA_DOMAIN}/api/v1/users" -H "Authorization: SSWS ${API_TOKEN}" -H "Accept: application/json")

# Initialize the JSON array for output
echo "[" > "$OUTPUT_FILE"

# Loop through each user and fetch their groups
echo "$USERS" | jq -c '.[]' | while read -r user; do
  USER_ID=$(echo "$user" | jq -r '.id')
  USERNAME=$(echo "$user" | jq -r '.profile.login')
  USER_GROUPS=$(curl -s -X GET "https://${OKTA_DOMAIN}/api/v1/users/${USER_ID}/groups" -H "Authorization: SSWS ${API_TOKEN}" -H "Accept: application/json")

  # Create a JSON object for the user with their groups
  USER_WITH_GROUPS=$(jq -n --arg id "$USER_ID" --arg username "$USERNAME" --argjson groups "$USER_GROUPS" '{id: $id, username: $username, groups: $groups}')

  # Append the user with groups to the output file
  echo "$USER_WITH_GROUPS," >> "$OUTPUT_FILE"
done

# Remove the trailing comma and close the JSON array
sed -i '$ s/,$//' "$OUTPUT_FILE"
echo "]" >> "$OUTPUT_FILE"

echo "Users and their groups have been saved to $OUTPUT_FILE"
