## ENVIRONMENT ##

#!/bin/bash

# Error tracking and logging function
log_error() {
    echo "Error: $1" >&2
}

# INSTALL JQ
mkdir -p $HOME/bin
curl -L https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 -o $HOME/bin/jq
if [ $? -ne 0 ]; then
    log_error "Failed to install jq"
    exit 1
fi
chmod +x $HOME/bin/jq
if [ $? -ne 0 ]; then
    log_error "Failed to set executable permission for jq"
    exit 1
fi

# SETUP DIRECTORIES
YEAR=$(date +'%Y')
echo "YEAR=$YEAR" >> $GITHUB_ENV
EVIDENCE_DATE=$(date -d "last sunday +1 day" +'%d %B')
echo "EVIDENCE_DATE=$EVIDENCE_DATE" >> $GITHUB_ENV
mkdir -p lists/$YEAR/
if [ $? -ne 0 ]; then
    log_error "Failed to create directory: lists/$YEAR/"
    exit 1
fi
mkdir -p general/r-1550/$YEAR/
if [ $? -ne 0 ]; then
    log_error "Failed to create directory: general/r-1550/$YEAR/"
    exit 1
fi
mkdir -p general/p-20/$YEAR/
if [ $? -ne 0 ]; then
    log_error "Failed to create directory: general/p-20/$YEAR/"
    exit 1
fi
