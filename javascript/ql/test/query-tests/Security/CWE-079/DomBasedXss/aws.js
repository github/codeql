const AWS = require('aws-sdk');
const { AthenaClient } = require('@aws-sdk/client-athena');
const { S3Client } = require('@aws-sdk/client-s3');
const { RDSDataClient } = require('@aws-sdk/client-rds-data');
const { DynamoDBClient } = require('@aws-sdk/client-dynamodb');
const express = require('express');

const app = express();

// AWS V3 Common tests
app.post('/aws-v3-common', async (req, res) => {
    const athenaClient = new AthenaClient({});
    const result = await athenaClient.send({});
    document.body.innerHTML = result.comment; // $ Alert[js/xss-additional-sources-dom-test]
    
    const s3Client = new S3Client({});
    const result2 = await s3Client.send({});
    document.body.innerHTML = result2.comment; // $ Alert[js/xss-additional-sources-dom-test]
    
    const rdsDataClient = new RDSDataClient({});
    const result3 = await rdsDataClient.send({});
    document.body.innerHTML = result3.comment; // $ Alert[js/xss-additional-sources-dom-test]
    
    const dynamoClient = new DynamoDBClient({});
    const result4 = await dynamoClient.send({});
    document.body.innerHTML = result4.comment; // $ Alert[js/xss-additional-sources-dom-test]
});

// Athena Client V2 tests
app.post('/athena-v2', async (req, res) => {
    const athena = new AWS.Athena();

    const data = await athena.getQueryResults({}).promise();
    document.body.innerHTML = data.comment; // $ Alert[js/xss-additional-sources-dom-test]

    athena.getQueryResults({}, function(err, data) {
        document.body.innerHTML = data.comment; // $ Alert[js/xss-additional-sources-dom-test]
    });
});

// S3 Client V2 tests
app.post('/s3-v2', async (req, res) => {
    const s3 = new AWS.S3();
    

    const data = await s3.getObject({}).promise();
    document.body.innerHTML = data.comment; // $ Alert[js/xss-additional-sources-dom-test]

    s3.getObject({}, function(err, data) {
        document.body.innerHTML = data.comment; // $ Alert[js/xss-additional-sources-dom-test]
    });
});

// RDS Data Client V2 tests
app.post('/rds-data-v2', async (req, res) => {
    const rdsData = new AWS.RDSDataService();
    
    const data = await rdsData.executeStatement({}).promise();
    document.body.innerHTML = data.comment; // $ Alert[js/xss-additional-sources-dom-test]

    rdsData.executeStatement({}, function(err, data) {
        document.body.innerHTML = data.comment; // $ Alert[js/xss-additional-sources-dom-test]
    });
    
    const data2 = await rdsData.batchExecuteStatement({}).promise();
    document.body.innerHTML = data2.comment; // $ Alert[js/xss-additional-sources-dom-test]
    
    rdsData.batchExecuteStatement({}, function(err, data) {
        document.body.innerHTML = data.comment; // $ Alert[js/xss-additional-sources-dom-test]
    });
});

// DynamoDB Client V2 tests
app.post('/dynamodb-v2', async (req, res) => {
    const dynamodb = new AWS.DynamoDB();
    
    const data = await dynamodb.executeStatement({}).promise();
    document.body.innerHTML = data.comment; // $ Alert[js/xss-additional-sources-dom-test]
    
    dynamodb.executeStatement({}, function(err, data) {
        document.body.innerHTML = data.comment; // $ Alert[js/xss-additional-sources-dom-test]
    });
    
    const data2 = await dynamodb.batchExecuteStatement({}).promise();
    document.body.innerHTML = data2.comment; // $ Alert[js/xss-additional-sources-dom-test]
    
    dynamodb.batchExecuteStatement({}, function(err, data) {
        document.body.innerHTML = data.comment; // $ Alert[js/xss-additional-sources-dom-test]
    });
    
    const data3 = await dynamodb.query({}).promise();
    document.body.innerHTML = data3.comment; // $ Alert[js/xss-additional-sources-dom-test]
    
    dynamodb.query({}, function(err, data) {
        document.body.innerHTML = data.comment; // $ Alert[js/xss-additional-sources-dom-test]
    });
    
    const data4 = await dynamodb.scan({}).promise();
    document.body.innerHTML = data4.comment; // $ Alert[js/xss-additional-sources-dom-test]
    
    dynamodb.scan({}, function(err, data) {
        document.body.innerHTML = data.comment; // $ Alert[js/xss-additional-sources-dom-test]
    });
    
    const data5 = await dynamodb.getItem({}).promise();
    document.body.innerHTML = data5.comment; // $ Alert[js/xss-additional-sources-dom-test]
    
    dynamodb.getItem({}, function(err, data) {
        document.body.innerHTML = data.comment; // $ Alert[js/xss-additional-sources-dom-test]
    });
    
    const data6 = await dynamodb.batchGetItem({}).promise();
    document.body.innerHTML = data6.comment; // $ Alert[js/xss-additional-sources-dom-test]
    
    dynamodb.batchGetItem({}, function(err, data) {
        document.body.innerHTML = data.comment; // $ Alert[js/xss-additional-sources-dom-test]
    });
});
