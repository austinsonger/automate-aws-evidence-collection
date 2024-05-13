#!/bin/bash

# Filename: check_s3_buckets_with_backup_to_json.sh

YEAR=$(date +'%Y')
DATE=$(date +%F)

# List all buckets
buckets=$(aws s3api list-buckets --query 'Buckets[*].Name' --output text)

# Loop through each bucket and get its policy, encryption, versioning, and backup vaults
for bucket in $buckets; do
    echo "Checking bucket: $bucket"
    echo "-----------------------------------"

    # Ensure the directory exists
    mkdir -p lists/$YEAR/S3/$bucket

    # Get bucket policy
    policy=$(aws s3api get-bucket-policy --bucket $bucket --query 'Policy' --output json 2>/dev/null)
    if [ $? -ne 0 ]; then
        policy="null"
    fi
    echo $policy | jq . > lists/$YEAR/S3/$bucket/$DATE.policy.json

    # Get bucket encryption
    encryption=$(aws s3api get-bucket-encryption --bucket $bucket --output json 2>/dev/null)
    if [ $? -ne 0 ]; then
        encryption="null"
    fi
    echo $encryption | jq . > lists/$YEAR/S3/$bucket/$DATE.encryption.json

    # Get bucket versioning
    versioning=$(aws s3api get-bucket-versioning --bucket $bucket --query 'Status' --output text 2>/dev/null)
    if [ $? -ne 0 ]; then
        versioning="null"
    fi
    echo "{\"versioning\": \"$versioning\"}" | jq . > lists/$YEAR/S3/$bucket/$DATE.versioning.json

    # Get backup vaults
    backup_vaults=$(aws backup list-backup-vaults --query 'BackupVaultList[*].BackupVaultName' --output json 2>/dev/null)
    if [ $? -ne 0 ]; then
        backup_vaults="null"
    fi
    echo $backup_vaults | jq . > lists/$YEAR/S3/$bucket/$DATE.backup_vaults.json

    echo "Output written to lists/$YEAR/S3/$bucket/"
    echo "-----------------------------------"
    echo
done

echo "All bucket information has been written to separate JSON files."
