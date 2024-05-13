#!/bin/bash

# Set your Jira domain, email, API token, and the specific label
JIRA_DOMAIN=""
JIRA_EMAIL=""
API_TOKEN=""
LABEL="Database-Change"

# Create the output directory if it doesn't exist
OUTPUT_DIR="lists/$(date +'%Y')/jira"
mkdir -p "$OUTPUT_DIR"

# Set the output file path
OUTPUT_FILE="$OUTPUT_DIR/$(date +%F).jira-issues-with-label-${LABEL}.csv"

# Initialize the CSV file with headers
echo "Issue Key,Summary,Status,Assignee,Reporter,Created,Updated,Labels" > "$OUTPUT_FILE"

# Fetch the list of issues with the specific label from Jira
START_AT=0
MAX_RESULTS=50

while : ; do
  RESPONSE=$(curl -s -u "${JIRA_EMAIL}:${API_TOKEN}" -X GET \
    "https://${JIRA_DOMAIN}/rest/api/2/search?jql=labels=${LABEL}&startAt=${START_AT}&maxResults=${MAX_RESULTS}" \
    -H "Accept: application/json")

  ISSUES=$(echo "$RESPONSE" | jq -c '.issues[]')
  
  # Check if there are no more issues to process
  if [ -z "$ISSUES" ]; then
    break
  fi
  
  # Loop through each issue and extract relevant fields
  echo "$ISSUES" | while read -r issue; do
    ISSUE_KEY=$(echo "$issue" | jq -r '.key')
    SUMMARY=$(echo "$issue" | jq -r '.fields.summary' | sed 's/,/ /g')
    STATUS=$(echo "$issue" | jq -r '.fields.status.name')
    ASSIGNEE=$(echo "$issue" | jq -r '.fields.assignee.displayName // "Unassigned"')
    REPORTER=$(echo "$issue" | jq -r '.fields.reporter.displayName')
    CREATED=$(echo "$issue" | jq -r '.fields.created')
    UPDATED=$(echo "$issue" | jq -r '.fields.updated')
    LABELS=$(echo "$issue" | jq -r '.fields.labels | join(",")')
    
    # Append the issue data to the CSV file
    echo "$ISSUE_KEY,$SUMMARY,$STATUS,$ASSIGNEE,$REPORTER,$CREATED,$UPDATED,$LABELS" >> "$OUTPUT_FILE"
  done
  
  # Move to the next set of results
  START_AT=$((START_AT + MAX_RESULTS))
done

echo "Issues with label ${LABEL} have been saved to $OUTPUT_FILE"
