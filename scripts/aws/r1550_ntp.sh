#!/bin/bash

# Define YEAR and DATE variables
YEAR=$(date +'%Y')
DATE=$(date +%F)

# Prepare the output file
OUTPUT_FILE="general/r-1550/${YEAR}/${DATE}_current-time.txt"

set -o xtrace # Enable debug tracing for this script

LOGFILE="evidence.log"
ERROR_LOGFILE="errors.log"

function log_message() {
  echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" >> ${LOGFILE}
}

function error_log_message() {
  echo "[$(date +'%Y-%m-%d %H:%M:%S')] Error: $1" >> ${ERROR_LOGFILE}
}

# Log the current system time using AWS CLI
aws ssm send-command \
  --document-name "AWS-RunShellScript" \
  --targets Key=tag:ec-appserver,Values=app06-us.aws.vwsrv.net \
  --parameters commands=["cat /etc/ntp.conf"] \
  --output text > "${OUTPUT_FILE}" 2>&1

if [ $? -ne 0 ]; then
  error_log_message "Failed to log current system time via AWS CLI."
else
  log_message "Current system time logged successfully via AWS CLI."
fi
