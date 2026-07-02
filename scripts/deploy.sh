#!/usr/bin/env bash

###############################################################################
# Serverless Automation Project - Deploy Script
# Author: Sérgio Santos
# Purpose: Automate full AWS CloudFormation deployment pipeline
###############################################################################

set -euo pipefail

###############################################################################
# CONFIGURATION
###############################################################################

PROJECT_NAME="tarefas-automatizadas"
ENVIRONMENT="dev"
REGION="us-east-1"

STACK_NAME="${PROJECT_NAME}-${ENVIRONMENT}-stack"

TEMPLATE_BUCKET="${PROJECT_NAME}-cf-templates-${ENVIRONMENT}"

STACK_FILE="cloudformation/stack.yaml"

IAM_TEMPLATE="cloudformation/iam.yaml"
LAMBDA_TEMPLATE="cloudformation/lambda.yaml"
BUCKET_TEMPLATE="cloudformation/bucket.yaml"

###############################################################################
# VALIDATION
###############################################################################

echo "🔍 Validating AWS CLI..."

if ! command -v aws &> /dev/null; then
  echo "❌ AWS CLI not installed"
  exit 1
fi

echo "✅ AWS CLI found"

echo "🔍 Checking AWS identity..."

aws sts get-caller-identity >/dev/null

echo "✅ AWS credentials valid"

###############################################################################
# CREATE TEMPLATE BUCKET (IF NOT EXISTS)
###############################################################################

echo "📦 Ensuring template bucket exists..."

if ! aws s3 ls "s3://${TEMPLATE_BUCKET}" >/dev/null 2>&1; then
  echo "🆕 Creating bucket: ${TEMPLATE_BUCKET}"

  aws s3 mb "s3://${TEMPLATE_BUCKET}" --region "${REGION}"
else
  echo "✅ Template bucket already exists"
fi

###############################################################################
# UPLOAD TEMPLATES
###############################################################################

echo "⬆️ Uploading CloudFormation templates..."

aws s3 cp "${BUCKET_TEMPLATE}" "s3://${TEMPLATE_BUCKET}/bucket.yaml"
aws s3 cp "${IAM_TEMPLATE}" "s3://${TEMPLATE_BUCKET}/iam.yaml"
aws s3 cp "${LAMBDA_TEMPLATE}" "s3://${TEMPLATE_BUCKET}/lambda.yaml"
aws s3 cp "${STACK_FILE}" "s3://${TEMPLATE_BUCKET}/stack.yaml"

echo "✅ Templates uploaded successfully"

###############################################################################
# DEPLOY STACK
###############################################################################

echo "🚀 Deploying CloudFormation stack..."

aws cloudformation deploy \
  --template-file "${STACK_FILE}" \
  --stack-name "${STACK_NAME}" \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameter-overrides \
    ProjectName="${PROJECT_NAME}" \
    Environment="${ENVIRONMENT}" \
    BucketTemplateURL="https://${TEMPLATE_BUCKET}.s3.${REGION}.amazonaws.com/bucket.yaml" \
    IAMTemplateURL="https://${TEMPLATE_BUCKET}.s3.${REGION}.amazonaws.com/iam.yaml" \
    LambdaTemplateURL="https://${TEMPLATE_BUCKET}.s3.${REGION}.amazonaws.com/lambda.yaml" \
  --region "${REGION}"

echo "✅ Stack deployment completed"

###############################################################################
# STACK OUTPUTS
###############################################################################

echo "📊 Fetching stack outputs..."

aws cloudformation describe-stacks \
  --stack-name "${STACK_NAME}" \
  --query "Stacks[0].Outputs" \
  --output table

###############################################################################
# FINAL MESSAGE
###############################################################################

echo ""
echo "🎉 DEPLOYMENT FINISHED SUCCESSFULLY"
echo "📌 Stack Name: ${STACK_NAME}"
echo "📌 Region: ${REGION}"
echo ""
echo "🚀 Serverless architecture is now active"
