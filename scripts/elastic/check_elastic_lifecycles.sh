#!/bin/bash

# Filename: check_elasticsearch_lifecycles.sh

# Elasticsearch host and API key
ELASTICSEARCH_HOST="https://fa-siem.es.us-east-1.aws.found.io"
ELASTICSEARCH_API_KEY=${ELASTICSEARCH_API_KEY}

# Output directory
YEAR=$(date +'%Y')
DATE=$(date +%F)
DIR="lists/$YEAR/elastic"
ILM_DIR="$DIR/ilm"
SLM_DIR="$DIR/slm"

# Ensure the directories exist
mkdir -p $ILM_DIR
mkdir -p $SLM_DIR

# Function to pull ILM policies
get_ilm_policies() {
    echo "Fetching ILM policies..."
    response=$(curl -s -H "Authorization: ApiKey $ELASTICSEARCH_API_KEY" -X GET "$ELASTICSEARCH_HOST/_ilm/policy" -H 'Content-Type: application/json')
    echo $response | jq . > $ILM_DIR/$DATE.ilm_policies.json
    echo "ILM policies written to $ILM_DIR/$DATE.ilm_policies.json"
}

# Function to pull SLM policies
get_slm_policies() {
    echo "Fetching SLM policies..."
    response=$(curl -s -H "Authorization: ApiKey $ELASTICSEARCH_API_KEY" -X GET "$ELASTICSEARCH_HOST/_slm/policy" -H 'Content-Type: application/json')
    echo $response | jq . > $SLM_DIR/$DATE.slm_policies.json
    echo "SLM policies written to $SLM_DIR/$DATE.slm_policies.json"
}

# Pull ILM and SLM policies
get_ilm_policies
get_slm_policies

echo "Elasticsearch lifecycle policies have been written to JSON files in $DIR."
