#!/bin/bash

YEAR=$(date +'%Y')
DATE=$(date +%F)

# Create directory for the current year's certificates
mkdir -p "lists/$YEAR/tls-certificates"

# Retrieve certificates and handle possible null cases
certificates=$(aws acm list-certificates --region us-east-1 --output json | jq -r '.CertificateSummary[]?.CertificateArn')
if [ -z "$certificates" ]; then
  echo "No certificates found or failed to retrieve certificates."
  exit 1
fi

# Loop through each certificate ARN and list their tags
for certificate in $certificates; do
  # Call list-tags-for-certificate for each ARN and save output to a file
  aws acm list-tags-for-certificate --certificate-arn "$certificate" --output yaml > "lists/$YEAR/tls-certificates/${certificate}-tags_$DATE.yaml"
done
