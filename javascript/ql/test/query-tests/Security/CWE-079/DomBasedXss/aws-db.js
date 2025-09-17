const { AthenaClient, GetQueryResultsCommand } = require('@aws-sdk/client-athena');
const { S3Client, GetObjectCommand } = require("@aws-sdk/client-s3");
const { RDSDataClient, ExecuteStatementCommand } = require("@aws-sdk/client-rds-data");
const { DynamoDBClient, GetItemCommand } = require("@aws-sdk/client-dynamodb");


const express = require('express');
const bodyParser = require('body-parser');
const app = express();
app.use(bodyParser.json());

app.post('/v3/all', async (req, res) => {
    const client = new AthenaClient({ region: "us-east-1" });
    const results = await client.send(new GetQueryResultsCommand({ QueryExecutionId }));
    document.body.innerHTML = results.ResultSet.Rows[0].Data[0].VarCharValue; // $ Alert[js/xss-additional-sources-dom-test]
    
    const s3 = new S3Client({ region: "us-east-1" });
    const command = new GetObjectCommand({ Bucket: bucket, Key: key });
    const response = await s3.send(command);
    document.body.innerHTML = response.Body.toString(); // $ Alert[js/xss-additional-sources-dom-test]

    const clientRDS = new RDSDataClient({ region: "us-east-1" });
    const response2 = await clientRDS.send(new ExecuteStatementCommand(command));
    document.body.innerHTML = response2.records; // $ Alert[js/xss-additional-sources-dom-test]

    const clientDyamo = new DynamoDBClient({ region: "us-east-1" });
    const response3 = await clientDyamo.send(new GetItemCommand(command));
    document.body.innerHTML = response3.Item; // $ Alert[js/xss-additional-sources-dom-test]

});


app.post('/v2/all', async (req, res) => {
    const AWS = require('aws-sdk');
    const athena = new AWS.Athena();
    const params = {
        QueryString: 'SELECT * FROM my_table',
        ResultConfiguration: { OutputLocation: 's3://bucket/prefix/' }
    };
    const { QueryExecutionId } = await athena.startQueryExecution(params).promise();

    const results = await athena.getQueryResults({ QueryExecutionId }).promise();
    document.body.innerHTML = results.ResultSet.Rows[0].Data[0].VarCharValue; // $ Alert[js/xss-additional-sources-dom-test]

    athena.getQueryResults({ QueryExecutionId }, (err, data) => {
        document.body.innerHTML = data.ResultSet.Rows[0].Data[0].VarCharValue; // $ Alert[js/xss-additional-sources-dom-test]
    });

    const s3 = new AWS.S3({ region: "us-east-1" });
    const response = await s3.getObject({ Bucket: "bucket", Key: "key" }).promise();
    document.body.innerHTML = response.Body.toString(); // $ Alert[js/xss-additional-sources-dom-test]

    s3.getObject({ Bucket: "bucket", Key: "key" }, (err, data) => {
        document.body.innerHTML = data.Body.toString(); // $ Alert[js/xss-additional-sources-dom-test]
    });
    
    const rdsData = new AWS.RDSDataService({ region: "us-east-1" });
    const response1 = await rdsData.executeStatement(params).promise();
    document.body.innerHTML = response1.records; // $ Alert[js/xss-additional-sources-dom-test]

    rdsData.executeStatement(params, function(err, data) {
        document.body.innerHTML = data.records; // $ Alert[js/xss-additional-sources-dom-test]
    });

    const response2 = await rdsData.batchExecuteStatement(params).promise();
    document.body.innerHTML = response2.updateResults; // $ Alert[js/xss-additional-sources-dom-test]

    rdsData.batchExecuteStatement(params, function(err, data) {
        document.body.innerHTML = data.updateResults; // $ Alert[js/xss-additional-sources-dom-test]
    });

    const dynamodb = new AWS.DynamoDB({ region: "us-east-1" });
    dynamodb.executeStatement(params, (err, data) => {
        document.body.innerHTML = data.Item; // $ Alert[js/xss-additional-sources-dom-test]
    });
    dynamodb.executeStatement(params).promise().then(data => {
        document.body.innerHTML = data.Item; // $ Alert[js/xss-additional-sources-dom-test]
    });
});
