!/bin/bash

YEAR=$(date +'%Y')
DATE=$(date +%F)

mkdir -p lists/EncryptedEBSVolumes/$YEAR/

# EVIDENCE ITEM: Encryption configuration for server disks used in production environments
aws ec2 describe-volumes \
--query "Volumes[?Encrypted==`true`]" \
--output json | jq -r '.[] | [ .VolumeId, .Encrypted, .KmsKeyId, (.Tags | map(.Key + "=" + .Value) | join(";")) ] | @csv' > "lists/EncryptedEBSVolumes/$YEAR/$DATE-encrypted_volumes.csv"

