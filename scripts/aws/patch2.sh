#!/bin/bash

aws ssm describe-available-patches \
--filters "Key=PRODUCT,Values=AmazonLinux2.0"  > lists/$(date +'%Y')/patching/$(date +%F).ssm-patch-manager_available-patches.json



