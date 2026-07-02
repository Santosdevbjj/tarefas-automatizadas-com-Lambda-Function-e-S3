#!/usr/bin/env bash

###############################################################################
# Serverless Automation Project - S3 Notification Configuration Script
# Author: Sérgio Santos
# Purpose: Configure S3 bucket event notifications to trigger AWS Lambda
###############################################################################

set -euo pipefail

###############################################################################
# CONFIGURATION
###############################################################################

PROJECT_NAME="tarefas-automatizadas"
ENVIRONMENT="dev"
REGION="us-east-1"

BUCKET_NAME="${PROJECT_NAME}-${ENVIRONMENT}-bucket"
FUNCTION_NAME="${PROJECT_NAME}-${ENVIRONMENT}-s3-event-processor"

###############################################################################
# CHECK AWS CLI
###############################################################################

echo "🔍 Checking AWS CLI..."

if ! command -v aws &> /dev/null; then
  echo "❌ AWS CLI not installed"
  exit 1
fi

aws sts get-caller-identity >/dev/null

echo "✅ AWS credentials validated"

###############################################################################
# GET LAMBDA ARN
###############################################################################

echo "🔎 Retrieving Lambda function ARN..."

LAMBDA_ARN=$(aws lambda get-function \
  --function-name "${FUNCTION_NAME}" \
  --region "${REGION}" \
  --query "Configuration.FunctionArn" \
  --output text)

echo "✅ Lambda ARN: ${LAMBDA_ARN}"

###############################################################################
# GET AWS ACCOUNT ID
###############################################################################

ACCOUNT_ID=$(aws sts get-caller-identity \
  --query "Account" \
  --output text)

echo "📌 AWS Account ID: ${ACCOUNT_ID}"

###############################################################################
# ADD LAMBDA PERMISSION FOR S3 INVOCATION
###############################################################################

echo "🔐 Adding Lambda invoke permission for S3..."

aws lambda add-permission \
  --function-name "${FUNCTION_NAME}" \
  --statement-id "s3-invoke-permission-${ENVIRONMENT}" \
  --action "lambda:InvokeFunction" \
  --principal "s3.amazonaws.com" \
  --source-arn "arn:aws:s3:::${BUCKET_NAME}" \
  --source-account "${ACCOUNT_ID}" \
  --region "${REGION}" || true

echo "✅ Permission configured (or already exists)"

###############################################################################
# CREATE S3 NOTIFICATION CONFIGURATION
###############################################################################

echo "📦 Configuring S3 bucket notifications..."

NOTIFICATION_PAYLOAD=$(cat <<EOF
{
  "LambdaFunctionConfigurations": [
    {
      "Id": "S3ToLambdaEventTrigger",
      "LambdaFunctionArn": "${LAMBDA_ARN}",
      "Events": [
        "s3:ObjectCreated:*"
      ]
    }
  ]
}
EOF
)

aws s3api put-bucket-notification-configuration \
  --bucket "${BUCKET_NAME}" \
  --notification-configuration "${NOTIFICATION_PAYLOAD}" \
  --region "${REGION}"

echo "✅ S3 notification configuration applied"

###############################################################################
# VALIDATION
###############################################################################

echo "🔍 Validating S3 notification configuration..."

aws s3api get-bucket-notification-configuration \
  --bucket "${BUCKET_NAME}" \
  --region "${REGION}"

###############################################################################
# FINAL MESSAGE
###############################################################################

echo ""
echo "🎉 S3 NOTIFICATION CONFIGURATION COMPLETED"
echo "📌 Bucket: ${BUCKET_NAME}"
echo "📌 Lambda: ${FUNCTION_NAME}"
echo "📌 Event: s3:ObjectCreated:*"
echo ""
echo "🚀 Your event-driven architecture is now ACTIVE"
