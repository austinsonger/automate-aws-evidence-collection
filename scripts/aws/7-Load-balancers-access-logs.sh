#!/bin/bash

# Current year and date for organizing output files
YEAR=$(date +'%Y')
DATE=$(date +%F)

$LB_ARN=$<$LB_ARN>

# Create a directory to store the YAML outputs for load balancer attributes
mkdir -p lists/7LoadBalancerAttributes/$YEAR/

# List all Classic Load Balancers and check their access logs configuration
aws elb describe-load-balancers --query 'LoadBalancerDescriptions[*].[LoadBalancerName]' --output text | while read LB_NAME; do
    aws elb describe-load-balancer-attributes --load-balancer-name $LB_NAME --output yaml > "lists/7LoadBalancerAttributes/$YEAR/$DATE-$LB_NAME.yml"
done

# List all Application and Network Load Balancers and check their access logs configuration
aws elbv2 describe-load-balancers --query 'LoadBalancers[*].LoadBalancerArn' --output text | while read LB_ARN; do
    aws elbv2 describe-load-balancer-attributes --load-balancer-arn $LB_ARN --output yaml > "lists/7LoadBalancerAttributes/$YEAR/$DATE-$LB_ARN.yml"
done
