#!/usr/bin/env bash

###############################################################################
# Serverless Automation Project - Remove S3 Notification Configuration
# Author: Sérgio Santos
# Purpose: Safely remove S3 bucket event notifications linked to Lambda
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
# SAFETY CHECK
###############################################################################

echo "⚠️  WARNING: This will REMOVE S3 event notifications!"
echo "📌 Bucket: ${BUCKET_NAME}"
echo "📌 Lambda: ${FUNCTION_NAME}"
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
# GET CURRENT NOTIFICATION CONFIGURATION
###############################################################################

echo "📦 Fetching current S3 notification configuration..."

aws s3api get-bucket-notification-configuration \
  --bucket "${BUCKET_NAME}" \
  --region "${REGION}" > current-config.json || true

echo "📄 Current configuration saved to current-config.json"

###############################################################################
# REMOVE NOTIFICATIONS
###############################################################################

echo "🧹 Removing S3 event notifications..."

aws s3api put-bucket-notification-configuration \
  --bucket "${BUCKET_NAME}" \
  --notification-configuration '{}' \
  --region "${REGION}"

echo "✅ S3 event notifications removed successfully"

###############################################################################
# VALIDATION
###############################################################################

echo "🔍 Validating removal..."

aws s3api get-bucket-notification-configuration \
  --bucket "${BUCKET_NAME}" \
  --region "${REGION}"

echo "📌 If empty configuration is returned, removal was successful"

###############################################################################
# FINAL MESSAGE
###############################################################################

echo ""
echo "🎉 S3 NOTIFICATION CLEANUP COMPLETED"
echo "📌 Bucket: ${BUCKET_NAME}"
echo "📌 Lambda: ${FUNCTION_NAME}"
echo ""
echo "🚀 Event-driven triggers have been safely removed"
