#!/bin/bash

# Set your Jira domain, email, and API token
JIRA_DOMAIN=""
JIRA_EMAIL=""
API_TOKEN=""

# Create the output directory if it doesn't exist
OUTPUT_DIR="lists/$(date +'%Y')/jira"
mkdir -p "$OUTPUT_DIR"

# Set the output file path
OUTPUT_FILE="$OUTPUT_DIR/$(date +%F).jira-projects.json"

# Fetch the list of projects from Jira
PROJECTS=$(curl -s -u "${JIRA_EMAIL}:${API_TOKEN}" -X GET "https://${JIRA_DOMAIN}/rest/api/2/project" -H "Accept: application/json")

# Check if the API call was successful
if [ $? -ne 0 ]; then
  echo "Failed to fetch Jira projects"
  exit 1
fi

# Check if the response contains an error
ERROR_MSG=$(echo "$PROJECTS" | jq -r '.errorMessages // empty')
if [ -n "$ERROR_MSG" ]; then
  echo "Error fetching Jira projects: $ERROR_MSG"
  exit 1
fi

# Extract relevant fields and save to JSON file
echo "$PROJECTS" | jq '[.[] | {id, key, name, projectTypeKey, lead: .lead.displayName}]' > "$OUTPUT_FILE"

echo "Jira projects have been saved to $OUTPUT_FILE"
