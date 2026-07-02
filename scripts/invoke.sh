#!/usr/bin/env bash

###############################################################################
# Serverless Automation Project - Lambda Invocation Script
# Author: Sérgio Santos
# Purpose: Test AWS Lambda function execution manually via AWS CLI
###############################################################################

set -euo pipefail

###############################################################################
# CONFIGURATION
###############################################################################

PROJECT_NAME="tarefas-automatizadas"
ENVIRONMENT="dev"
REGION="us-east-1"

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
# SAMPLE EVENT PAYLOAD
###############################################################################

echo "📦 Preparing sample S3 event payload..."

read -r -d '' PAYLOAD << EOF
{
  "Records": [
    {
      "eventVersion": "2.1",
      "eventSource": "aws:s3",
      "awsRegion": "${REGION}",
      "eventTime": "2026-01-01T00:00:00.000Z",
      "eventName": "ObjectCreated:Put",
      "s3": {
        "s3SchemaVersion": "1.0",
        "bucket": {
          "name": "example-bucket"
        },
        "object": {
          "key": "test-file.txt",
          "size": 1024
        }
      }
    }
  ]
}
EOF

###############################################################################
# INVOKE LAMBDA
###############################################################################

echo "🚀 Invoking Lambda function: ${FUNCTION_NAME}"

RESPONSE_FILE="lambda-response.json"

aws lambda invoke \
  --function-name "${FUNCTION_NAME}" \
  --payload "${PAYLOAD}" \
  --region "${REGION}" \
  "${RESPONSE_FILE}" \
  > /dev/null

###############################################################################
# DISPLAY RESPONSE
###############################################################################

echo "📊 Lambda response:"
echo "----------------------------------------"
cat "${RESPONSE_FILE}"
echo ""
echo "----------------------------------------"

###############################################################################
# LOG LOCATION INFO
###############################################################################

echo ""
echo "📌 Next step: check CloudWatch Logs"
echo "🔗 https://${REGION}.console.aws.amazon.com/cloudwatch/home?region=${REGION}#logsV2:log-groups"

###############################################################################
# SUCCESS MESSAGE
###############################################################################

echo ""
echo "🎉 LAMBDA INVOCATION COMPLETED SUCCESSFULLY"
echo "📌 Function: ${FUNCTION_NAME}"
echo "📌 Region: ${REGION}"
