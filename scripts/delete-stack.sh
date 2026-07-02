#!/usr/bin/env bash

###############################################################################
# Serverless Automation Project - Destroy Script
# Author: Sérgio Santos
# Purpose: Safely delete all AWS CloudFormation stacks created by the project
###############################################################################

set -euo pipefail

###############################################################################
# CONFIGURATION
###############################################################################

PROJECT_NAME="tarefas-automatizadas"
ENVIRONMENT="dev"

STACK_NAME="${PROJECT_NAME}-${ENVIRONMENT}-stack"

REGION="us-east-1"

TEMPLATE_BUCKET="${PROJECT_NAME}-cf-templates-${ENVIRONMENT}"

###############################################################################
# SAFETY CHECK
###############################################################################

echo "⚠️  WARNING: This will DELETE the entire infrastructure!"
echo "📌 Stack: ${STACK_NAME}"
echo ""

read -p "❗ Are you sure you want to continue? (yes/no): " CONFIRM

if [[ "$CONFIRM" != "yes" ]]; then
  echo "❌ Operation cancelled by user"
  exit 1
fi

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
# DELETE CLOUD FORMATION STACK
###############################################################################

echo "🧨 Deleting CloudFormation stack: ${STACK_NAME}"

aws cloudformation delete-stack \
  --stack-name "${STACK_NAME}" \
  --region "${REGION}"

echo "⏳ Waiting for stack deletion to complete..."

aws cloudformation wait stack-delete-complete \
  --stack-name "${STACK_NAME}" \
  --region "${REGION}"

echo "✅ Stack deleted successfully"

###############################################################################
# OPTIONAL: CLEANUP S3 TEMPLATE BUCKET
###############################################################################

echo "🧹 Cleaning up template bucket: ${TEMPLATE_BUCKET}"

if aws s3 ls "s3://${TEMPLATE_BUCKET}" >/dev/null 2>&1; then

  echo "📦 Removing all objects from bucket..."

  aws s3 rm "s3://${TEMPLATE_BUCKET}" --recursive

  echo "🪣 Deleting bucket..."

  aws s3 rb "s3://${TEMPLATE_BUCKET}"

  echo "✅ Bucket deleted successfully"

else
  echo "ℹ️ Template bucket does not exist or already deleted"
fi

###############################################################################
# FINAL MESSAGE
###############################################################################

echo ""
echo "🎉 INFRASTRUCTURE CLEANUP COMPLETED"
echo "📌 Stack removed: ${STACK_NAME}"
echo "📌 Region: ${REGION}"
echo ""
echo "🚀 All resources have been safely removed"
