# Simple helper scripts make it easy to create and destroy the vulnerable environment.

#!/bin/bash
echo " Deploying vulnerable IAM user via CloudFormation..."
aws cloudformation deploy \
  --template-file vulnerable_iam_setup.yml \
  --stack-name VulnerableIAMStack \
  --capabilities CAPABILITY_IAM

echo " Deployment complete. Check the stack outputs for the access keys."
