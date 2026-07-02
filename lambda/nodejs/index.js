'use strict';

const AWS = require('aws-sdk');

// AWS clients
const s3 = new AWS.S3();

// Environment variables
const PROJECT_NAME = process.env.PROJECT_NAME || 'tarefas-automatizadas';
const ENVIRONMENT = process.env.ENVIRONMENT || 'dev';

/**
 * Lambda handler triggered by S3 events
 */
exports.handler = async (event) => {
    console.log('Event received:', JSON.stringify(event, null, 2));

    try {
        const records = event.Records || [];

        const processedFiles = [];

        for (const record of records) {

            const bucket = record.s3.bucket.name;
            const key = decodeURIComponent(record.s3.object.key.replace(/\+/g, ' '));
            const size = record.s3.object.size || 0;
            const eventName = record.eventName || 'Unknown';

            console.log(`Processing file: ${key} from bucket: ${bucket}`);

            let metadata = {};

            try {
                const head = await s3.headObject({
                    Bucket: bucket,
                    Key: key
                }).promise();

                metadata = head.Metadata || {};

            } catch (err) {
                console.warn(`Could not fetch metadata for ${key}:`, err.message);
            }

            const processedData = {
                bucket,
                key,
                size,
                event: eventName,
                metadata,
                status: 'processed'
            };

            console.log('Processed object:', JSON.stringify(processedData));

            processedFiles.push(processedData);
        }

        const result = {
            project: PROJECT_NAME,
            environment: ENVIRONMENT,
            processed_count: processedFiles.length,
            files: processedFiles
        };

        console.log('Processing completed successfully');

        return {
            statusCode: 200,
            body: JSON.stringify(result)
        };

    } catch (error) {
        console.error('Error processing event:', error);

        return {
            statusCode: 500,
            body: JSON.stringify({
                error: error.message,
                message: 'Lambda processing failed'
            })
        };
    }
};
