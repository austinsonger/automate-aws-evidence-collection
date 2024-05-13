#!/bin/bash

YEAR=$(date +'%Y')
DATE=$(date +%F)
TAG_KEY="Name"
TAG_VALUE="172.20.20.27_ec_haproxy"

# Get the list of instance IDs based on the tag
INSTANCE_IDS=$(aws ec2 describe-instances --filters "Name=tag:${TAG_KEY},Values=${TAG_VALUE}" --query "Reservations[*].Instances[*].InstanceId" --output text)

# Check if any instances were found
if [ -z "$INSTANCE_IDS" ]; then
  echo "No instances found with the tag ${TAG_KEY}:${TAG_VALUE}"
  exit 1
fi

# Initialize a JSON array
echo "[" > lists/$YEAR/patching/$DATE.patches.json

# Loop through each instance ID and describe instance patches
for INSTANCE_ID in $INSTANCE_IDS; do
  echo "Describing patches for instance: $INSTANCE_ID"
  PATCH_INFO=$(aws ssm describe-instance-patches --instance-id $INSTANCE_ID)
  
  # Append the patch info to the JSON file
  echo "$PATCH_INFO," >> lists/$YEAR/patching/$DATE.patches.json
done

# Remove the trailing comma and close the JSON array
sed -i '$ s/,$//' lists/$YEAR/patching/$DATE.patches.json
echo "]" >> lists/$YEAR/patching/$DATE.patches.json

echo "Patch information has been saved to lists/$YEAR/patching/$DATE.patches.json"
