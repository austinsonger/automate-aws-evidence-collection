#!/bin/bash

YEAR=$(date +'%Y')
DATE=$(date +%F)

mkdir -p lists/EncryptedRDSBackups/$YEAR/

# EVIDENCE ITEM: Encryption configuration for databases used in production environments
aws rds describe-db-snapshots --output json --query 'DBSnapshots[*].[DBSnapshotIdentifier,DBInstanceIdentifier,Encrypted,SnapshotCreateTime,KmsKeyId]' | jq -r '.[] | @csv' > "lists/EncryptedRDSBackups/$YEAR/$DATE-db-snapshots.csv"

# EVIDENCE ITEM: Database backups are encrypted to prevent unauthorized access to information
aws rds describe-db-instances --output json --query 'DBInstances[*].[DBInstanceIdentifier,DBInstanceClass,Engine,StorageEncrypted,KmsKeyId]' | jq -r '.[] | @csv' > "lists/EncryptedRDSBackups/$YEAR/$DATE-db-instances.csv"

