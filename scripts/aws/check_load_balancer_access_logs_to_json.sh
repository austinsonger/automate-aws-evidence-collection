#!/bin/bash

# Filename: check_load_balancer_access_logs_to_json.sh

YEAR=$(date +'%Y')
DATE=$(date +%F)

# Initialize an empty JSON array
output="["

# Check ALBs
echo "Checking Application Load Balancers (ALBs)..."
for lb_arn in $(aws elbv2 describe-load-balancers --query 'LoadBalancers[*].LoadBalancerArn' --output text); do
    echo "Checking ALB: $lb_arn"
    access_logs_enabled=$(aws elbv2 describe-load-balancer-attributes --load-balancer-arn $lb_arn --query 'Attributes[?Key==`access_logs.s3.enabled`].Value' --output text)
    if [ "$access_logs_enabled" == "true" ]; then
        access_logs_status="enabled"
    else
        access_logs_status="not enabled"
    fi
    output+="{\"load_balancer\": \"$lb_arn\", \"type\": \"ALB\", \"access_logs\": \"$access_logs_status\"},"
done

echo "-----------------------------------"

# Check CLBs
echo "Checking Classic Load Balancers (CLBs)..."
for lb_name in $(aws elb describe-load-balancers --query 'LoadBalancerDescriptions[*].LoadBalancerName' --output text); do
    echo "Checking CLB: $lb_name"
    access_logs_enabled=$(aws elb describe-load-balancer-attributes --load-balancer-name $lb_name --query 'LoadBalancerAttributes.AccessLog.Enabled' --output text)
    if [ "$access_logs_enabled" == "true" ]; then
        access_logs_status="enabled"
    else
        access_logs_status="not enabled"
    fi
    output+="{\"load_balancer\": \"$lb_name\", \"type\": \"CLB\", \"access_logs\": \"$access_logs_status\"},"
done

# Remove the trailing comma and close the JSON array
output=${output%,}
output+="]"

# Ensure the directory exists
mkdir -p lists/$YEAR/load_balancers

# Write the output to a JSON file
echo $output | jq . > lists/$YEAR/load_balancers/$DATE.load_balancers_access_logs.json

echo "Output written to lists/$YEAR/load_balancers/$DATE.load_balancers_access_logs.json"
