const { S3Client, SelectObjectContentCommand } = require("@aws-sdk/client-s3");
const AWS = require('aws-sdk');
const express = require('express');
const bodyParser = require('body-parser');

const app = express();
app.use(bodyParser.json());

app.post('/client/v3/execute', async (req, res) => {
    let maliciousInput = req.body.filter; // $ Source
    const client = new S3Client({ region: "us-east-1" });
    const params = {
        Bucket: "my-bucket",
        Key: "data.csv",
        ExpressionType: "SQL",
        Expression: "SELECT * FROM S3Object WHERE " + maliciousInput,
    };
    await client.send(new SelectObjectContentCommand(params)); // $ Alert
    res.end();
});

app.post('/client/v2/execute', async (req, res) => {
    let maliciousInput = req.body.filter; // $ Source
    const s3 = new AWS.S3({ region: "us-east-1" });
    const params = {
        Bucket: "my-bucket",
        Key: "data.csv",
        ExpressionType: "SQL",
        Expression: "SELECT * FROM S3Object WHERE " + maliciousInput, // $ Alert
    };
    await s3.selectObjectContent(params).promise();
    res.end();

    const params1 = {
        Bucket: "my-bucket",
        Key: "data.csv",
        ExpressionType: "SQL",
        Expression: "SELECT * FROM S3Object WHERE " + maliciousInput, // $ Alert
    };

    s3.selectObjectContent(params1, (err, data) => {
        res.end();
    });
});
