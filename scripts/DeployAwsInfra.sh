#!/bin/bash
 
# Variables 
STACK_NAME="NetflixCloneInfrastructure"
TEMPLATE_FILE="infra.yml"
REGION="ap-south-1"
 
# Deploy the CloudFormation stack
aws cloudformation deploy \
    --stack-name "$STACK_NAME" \
    --template-file "$TEMPLATE_FILE" \
    --region "$REGION"