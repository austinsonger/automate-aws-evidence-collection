# Github Action for AWS Evidence Collection


## Use the following  AWS API reference
- https://docs.aws.amazon.com/cli/latest/reference/ec2/describe-client-vpn-endpoints.html


## Github Action 
  - On a recurring schedule to run on the 28th of every month.
    - `aws ec2 describe-client-vpn-endpoints`
    - The output will be written to a json file with current VPN configuration information
