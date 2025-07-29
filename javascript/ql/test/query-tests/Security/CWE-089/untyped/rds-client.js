const { RDSDataClient, BatchExecuteStatementCommand, ExecuteStatementCommand, ExecuteSqlCommand } = require("@aws-sdk/client-rds-data");
const express = require('express');
const bodyParser = require('body-parser');
const app = express();
app.use(bodyParser.json());

app.post('/v3/rds/all', async (req, res) => {
    const userQuery = req.body.query; // $ MISSING: Source
    const userQueries = req.body.queries; // $ MISSING: Source

    const client = new RDSDataClient({ region: "us-east-1" });

    const params1 = {
        resourceArn: "arn:aws:rds:us-east-1:123456789012:cluster:my-aurora-cluster",
        secretArn: "arn:aws:secretsmanager:us-east-1:123456789012:secret:my-secret",
        database: "userDatabase",
        sql: userQuery
    };
    await client.send(new ExecuteStatementCommand(params1)); // $ MISSING: Alert

    const params2 = {
        resourceArn: "arn:aws:rds:us-east-1:123456789012:cluster:my-aurora-cluster",
        secretArn: "arn:aws:secretsmanager:us-east-1:123456789012:secret:my-secret",
        database: "userDatabase",
        parameterSets: userQueries.map(sql => ({ sql }))
    };
    await client.send(new BatchExecuteStatementCommand(params2)); // $ MISSING: Alert

    const params = {
        resourceArn: "...",
        secretArn: "...",
        database: "userDatabase",
        sqlStatements: userQuery
    };

    await client.send(new ExecuteSqlCommand(params)); // $ MISSING: Alert

    res.end();
});

const AWS = require('aws-sdk');

app.post('/v2/rds/all', async (req, res) => {
    const userQuery = req.body.query; // $ MISSING: Source
    const userQueries = req.body.queries; // $ MISSING: Source

    const rdsData = new AWS.RDSDataService({ region: "us-east-1" });

    const params1 = {
        resourceArn: "arn:aws:rds:us-east-1:123456789012:cluster:my-aurora-cluster",
        secretArn: "arn:aws:secretsmanager:us-east-1:123456789012:secret:my-secret",
        database: "userDatabase",
        sql: userQuery // $ MISSING: Alert
    };
    await rdsData.executeStatement(params1).promise();

    const params2 = {
        resourceArn: "arn:aws:rds:us-east-1:123456789012:cluster:my-aurora-cluster",
        secretArn: "arn:aws:secretsmanager:us-east-1:123456789012:secret:my-secret",
        database: "userDatabase",
        parameterSets: userQueries.map(sql => ({ sql })) // $ MISSING: Alert
    };
    await rdsData.batchExecuteStatement(params2).promise();

    res.end();
});

app.listen(3000);
