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
OUTPUT_FILE="$OUTPUT_DIR/$(date +%F).okta-password-policies.json"

# Fetch the list of policies
POLICIES=$(curl -s -X GET "https://${OKTA_DOMAIN}/api/v1/policies?type=PASSWORD" -H "Authorization: SSWS ${API_TOKEN}" -H "Accept: application/json")

# Initialize the JSON array for output
echo "[" > "$OUTPUT_FILE"

# Loop through each policy and fetch detailed information
echo "$POLICIES" | jq -c '.[]' | while read -r policy; do
  POLICY_ID=$(echo "$policy" | jq -r '.id')
  POLICY_NAME=$(echo "$policy" | jq -r '.name')
  POLICY_TYPE=$(echo "$policy" | jq -r '.type')
  POLICY_DESC=$(echo "$policy" | jq -r '.description')
  
  # Fetch policy rules
  RULES=$(curl -s -X GET "https://${OKTA_DOMAIN}/api/v1/policies/${POLICY_ID}/rules" -H "Authorization: SSWS ${API_TOKEN}" -H "Accept: application/json")
  
  # Create a JSON object for the policy with its rules
  POLICY_WITH_RULES=$(jq -n --arg id "$POLICY_ID" --arg name "$POLICY_NAME" --arg type "$POLICY_TYPE" --arg description "$POLICY_DESC" --argjson rules "$RULES" '{id: $id, name: $name, type: $type, description: $description, rules: $rules}')
  
  # Append the policy with rules to the output file
  echo "$POLICY_WITH_RULES," >> "$OUTPUT_FILE"
done

# Remove the trailing comma and close the JSON array
sed -i '$ s/,$//' "$OUTPUT_FILE"
echo "]" >> "$OUTPUT_FILE"

echo "Password policies have been saved to $OUTPUT_FILE"
