#!/bin/bash

YEAR=$(date +'%Y')
DATE=$(date +%F)

# Get all CloudTrails
trails=$(aws cloudtrail describe-trails --query 'trailList[*].{Name:Name,LogFileValidationEnabled:LogFileValidationEnabled, KmsKeyId:KmsKeyId, S3BucketName:S3BucketName}' --output json)

# Initialize an empty JSON array for S3 bucket details
s3_buckets_info="["

# Function to get bucket details
get_bucket_details() {
    local bucket=$1

    # Get bucket policy
    policy=$(aws s3api get-bucket-policy --bucket $bucket --query 'Policy' --output json 2>/dev/null)
    if [ $? -ne 0 ]; then
        policy="null"
    fi

    # Get bucket encryption
    encryption=$(aws s3api get-bucket-encryption --bucket $bucket --output json 2>/dev/null)
    if [ $? -ne 0 ]; then
        encryption="null"
    fi

    # Get bucket versioning
    versioning=$(aws s3api get-bucket-versioning --bucket $bucket --query 'Status' --output text 2>/dev/null)
    if [ $? -ne 0 ]; then
        versioning="null"
    fi

    # Create JSON object for bucket details
    bucket_info="{\"bucket\": \"$bucket\", \"policy\": $policy, \"encryption\": $encryption, \"versioning\": \"$versioning\"}"

    echo $bucket_info
}

# Process each CloudTrail
for row in $(echo "${trails}" | jq -r '.[] | @base64'); do
    _jq() {
        echo ${row} | base64 --decode | jq -r ${1}
    }

    trail_name=$(_jq '.Name')
    log_file_validation=$(_jq '.LogFileValidationEnabled')
    kms_key_id=$(_jq '.KmsKeyId')
    s3_bucket=$(_jq '.S3BucketName')

    # Get S3 bucket details
    bucket_details=$(get_bucket_details $s3_bucket)

    # Append CloudTrail and associated S3 bucket details to the JSON array
    s3_buckets_info+="{\"trail_name\": \"$trail_name\", \"log_file_validation\": \"$log_file_validation\", \"kms_key_id\": \"$kms_key_id\", \"bucket_details\": $bucket_details},"
done

# Remove the trailing comma and close the JSON array
s3_buckets_info=${s3_buckets_info%,}
s3_buckets_info+="]"

# Write the output to a JSON file
echo $s3_buckets_info | jq . > lists/$YEAR/cloudtrail/$DATE.cloudtrail_s3_buckets_info.json

echo "Output written to cloudtrail_s3_buckets_info.json"
