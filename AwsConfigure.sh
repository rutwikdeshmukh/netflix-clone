#!/bin/bash

region="<YOUR_REGION>"
profile_name="<PROFILE_NAME>"
access_key="<YOUR_ACCESS_KEY>"
secret_key="<YOUR_SECRET_KEY>"
output="yaml"

aws configure --profile $profile_name <<EOF
$access_key
$secret_key
$region
$output
EOF