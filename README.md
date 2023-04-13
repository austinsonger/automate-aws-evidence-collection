# Github Action for AWS Evidence Collection


## Use the following  AWS API reference
- https://docs.aws.amazon.com/cli/latest/reference/acm/index.html


## Github Action 
  - On a recurring schedule to run on the 28th of every month.
    - `aws acm list-certificates --output json`
    - The output will be written to a json file with current list of certificates.


## Current Setup

```
name: AWS Evidence Collection

on:
  schedule:
    # Runs "At 12:00 on day-of-month 28."
    - cron: '0 12 28 * *'
 
jobs:
  write-to-console:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Configure AWS Credentials
        uses: aws-actions/configure-aws-credentials@v2
        with:
         aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
         aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}

      - id: install-aws-cli
        uses: unfor19/install-aws-cli-action@v1
        with:
         version: 2     # default
         verbose: false # default
         arch: amd64    # allowed values: amd64, arm64
         rootdir: ""    # defaults to "PWD"
         workdir: ""    # defaults to "PWD/unfor19-awscli"
      - run: aws acm list-certificates --output json
        shell: bash

      - name: Overwrite file
        uses: "DamianReeves/write-file-action@master"
        with:
          path: Lists/certificates.json
          write-mode: overwrite
          contents: |
            console.log('some contents')
            
      - name: Commit & Push
        uses: Andro999b/push@v1.3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          branch: main
          force: true
          
          

```

