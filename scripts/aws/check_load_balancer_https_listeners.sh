#!/bin/bash

# Filename: check_load_balancer_https_listeners.sh

YEAR=$(date +'%Y')
DATE=$(date +%F)
DIR="lists/$YEAR/load_balancers"

# Ensure the directory exists
mkdir -p $DIR

# Initialize an empty JSON array
output="["

# Check ALBs
echo "Checking Application Load Balancers (ALBs)..."
for lb_arn in $(aws elbv2 describe-load-balancers --query 'LoadBalancers[*].LoadBalancerArn' --output text); do
    echo "Checking ALB: $lb_arn"
    listeners=$(aws elbv2 describe-listeners --load-balancer-arn $lb_arn --query 'Listeners[*].Protocol' --output text)
    echo $listeners | tr '\t' '\n' | grep -vE 'HTTPS|SSL' > /dev/null
    if [ $? -eq 0 ]; then
        https_status="false"
    else
        https_status="true"
    fi
    output+="{\"load_balancer\": \"$lb_arn\", \"type\": \"ALB\", \"https_only\": \"$https_status\"},"
done

echo "-----------------------------------"

# Check CLBs
echo "Checking Classic Load Balancers (CLBs)..."
for lb_name in $(aws elb describe-load-balancers --query 'LoadBalancerDescriptions[*].LoadBalancerName' --output text); do
    echo "Checking CLB: $lb_name"
    listeners=$(aws elb describe-load-balancers --load-balancer-names $lb_name --query 'LoadBalancerDescriptions[*].ListenerDescriptions[*].Listener.Protocol' --output text)
    echo $listeners | tr '\t' '\n' | grep -vE 'HTTPS|SSL' > /dev/null
    if [ $? -eq 0 ]; then
        https_status="false"
    else
        https_status="true"
    fi
    output+="{\"load_balancer\": \"$lb_name\", \"type\": \"CLB\", \"https_only\": \"$https_status\"},"
done

# Remove the trailing comma and close the JSON array
output=${output%,}
output+="]"

# Write the output to a JSON file
echo $output | jq . > $DIR/$DATE.load_balancers_https_listeners.json

echo "Output written to $DIR/$DATE.load_balancers_https_listeners.json"
