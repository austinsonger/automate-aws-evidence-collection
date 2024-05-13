#!/bin/bash

# Filename: check_production_firewall_rules.sh

YEAR=$(date +'%Y')
DATE=$(date +%F)
DIR="lists/$YEAR/firewall_rules"

# Ensure the directory exists
mkdir -p $DIR

# Check Security Groups
echo "Checking Security Groups..."
security_groups=$(aws ec2 describe-security-groups --query 'SecurityGroups[*].GroupId' --output text)

for sg_id in $security_groups; do
    echo "Describing Security Group: $sg_id"
    aws ec2 describe-security-groups --group-ids $sg_id --output json > $DIR/$DATE.security_group_$sg_id.json
done

# Check Network ACLs
echo "Checking Network ACLs..."
network_acls=$(aws ec2 describe-network-acls --query 'NetworkAcls[*].NetworkAclId' --output text)

for nacl_id in $network_acls; do
    echo "Describing Network ACL: $nacl_id"
    aws ec2 describe-network-acls --network-acl-ids $nacl_id --output json > $DIR/$DATE.network_acl_$nacl_id.json
done

# Check AWS WAF Web ACLs
echo "Checking AWS WAF Web ACLs..."
web_acls=$(aws wafv2 list-web-acls --scope REGIONAL --query 'WebACLs[*].Id' --output text)

for web_acl_id in $web_acls; do
    echo "Describing Web ACL: $web_acl_id"
    aws wafv2 get-web-acl --scope REGIONAL --id $web_acl_id --output json > $DIR/$DATE.web_acl_$web_acl_id.json
done

echo "Firewall rules configuration has been written to JSON files in $DIR."
