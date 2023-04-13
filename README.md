# Github Action for AWS Evidence Collection

> When you use this. The project should be private for obvious reasons.


#### Use the following  AWS API reference
- https://docs.aws.amazon.com/cli/latest/reference/acm-pca/list-certificate-authorities.html


#### Github Action 
  - On a recurring schedule to run on the 28th of every month.
    - `acm-pca list-certificate-authorities --output json`
    - The output will be written to a json file with current list of certificates.



#### Current Setup

```
name: AWS Evidence Collection

on:
  push:
    branches:
      - main
  schedule:
    # Runs "At 12:00 on day-of-month 28."
    - cron: '0 12 28 * *'

permissions:
  contents: write

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Configure AWS Credentials
        uses: aws-actions/configure-aws-credentials@v2
        with:
         aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
         aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
         aws-region: us-east-1
         
      - id: install-aws-cli
        uses: unfor19/install-aws-cli-action@v1
        with:
         version: 2     # default
         verbose: false # default
         arch: amd64    # allowed values: amd64, arm64
         rootdir: ""    # defaults to "PWD"
         workdir: ""    # defaults to "PWD/unfor19-awscli"
          
      - uses: GuillaumeFalourd/command-output-file-action@v1
        with:
          command_line: aws acm-pca list-certificate-authorities --output json
          output_file_name: Lists/certificates.json
          display_file_content: YES #    
      
      - name: Commit & Push changes
        uses: actions-js/push@master
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
```

