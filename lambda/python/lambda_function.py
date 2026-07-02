import json
import logging
import boto3
import os
from urllib.parse import unquote_plus

# =============================================================================
# CONFIGURATION
# =============================================================================

logger = logging.getLogger()
logger.setLevel(logging.INFO)

s3_client = boto3.client("s3")

ENVIRONMENT = os.getenv("ENVIRONMENT", "dev")
PROJECT_NAME = os.getenv("PROJECT_NAME", "tarefas-automatizadas")

# =============================================================================
# CORE LOGIC
# =============================================================================

def lambda_handler(event, context):
    """
    AWS Lambda entrypoint triggered by S3 events.
    Processes uploaded objects and logs metadata.
    """

    logger.info("Event received: %s", json.dumps(event))

    try:
        records = event.get("Records", [])

        processed_files = []

        for record in records:

            bucket_name = record["s3"]["bucket"]["name"]
            object_key = unquote_plus(record["s3"]["object"]["key"])
            object_size = record["s3"]["object"].get("size", 0)
            event_name = record.get("eventName", "Unknown")

            logger.info(f"Processing file: {object_key} from bucket: {bucket_name}")

            # OPTIONAL: fetch object metadata
            try:
                response = s3_client.head_object(
                    Bucket=bucket_name,
                    Key=object_key
                )

                metadata = response.get("Metadata", {})

            except Exception as e:
                logger.warning(f"Could not fetch metadata for {object_key}: {str(e)}")
                metadata = {}

            processed_data = {
                "bucket": bucket_name,
                "key": object_key,
                "size": object_size,
                "event": event_name,
                "metadata": metadata,
                "status": "processed"
            }

            logger.info(f"Processed object: {json.dumps(processed_data)}")

            processed_files.append(processed_data)

        result = {
            "project": PROJECT_NAME,
            "environment": ENVIRONMENT,
            "processed_count": len(processed_files),
            "files": processed_files
        }

        logger.info("Processing completed successfully")

        return {
            "statusCode": 200,
            "body": json.dumps(result)
        }

    except Exception as e:
        logger.error("Error processing event: %s", str(e))

        return {
            "statusCode": 500,
            "body": json.dumps({
                "error": str(e),
                "message": "Lambda processing failed"
            })
        }
