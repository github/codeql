import {DynamoDBClient, ExecuteStatementCommand, BatchExecuteStatementCommand, DynamoDB} from "@aws-sdk/client-dynamodb";
const express = require('express');

const app = express();
const region = 'us-east-1';

app.post('/partiql/v3/execute', async (req, res) => {
    const client = new DynamoDBClient({});
    let maliciousInput = req.body.data; // $ Source

    const statement = `SELECT * FROM Users WHERE username = '${maliciousInput}'`;
    const command = new ExecuteStatementCommand({
        Statement: statement
    });
    await client.send(command); // $ Alert

    const updateStatement = "UPDATE Users SET status = 'active' WHERE id = " + maliciousInput;
    const updateCommand = new ExecuteStatementCommand({
        Statement: updateStatement
    });
    await client.send(updateCommand); // $ Alert


    const batchInput = {
        Statements: [{
                Statement: `SELECT * FROM Users WHERE username = '${maliciousInput}'`
            },
            {
                Statement: "UPDATE Users SET role = 'user' WHERE username = bob"
            }
        ]
    };

    const batchCommand = new BatchExecuteStatementCommand(batchInput);
    await client.send(batchCommand); // $ MISSING: Alert

    const batchInput2 = {
        Statements: maliciousInput.map(input => ({
            Statement: `SELECT * FROM SensitiveData WHERE username = '${input}'`
        }))
    };

    const batchCommand2 = new BatchExecuteStatementCommand(batchInput2);
    await client.send(batchCommand2); // $ MISSING: Alert

    const client2 = new DynamoDB({});
    await client2.send(command); // $ Alert
    await client2.send(batchCommand); // $ MISSING: Alert
});

app.post('/partiql/v2/execute', async (req, res) => {
    const AWS = require('aws-sdk');
    const dynamodb = new AWS.DynamoDB({
        region: 'us-east-1'
    });
    let maliciousInput = req.body.data; // $ Source
    const params = {
        Statement: `SELECT * FROM Users WHERE username = '${maliciousInput}'`  // $ Alert
    };

    dynamodb.executeStatement(params, function(err, data) {});
    const params2 = {
        Statements: [{
                Statement: `SELECT * FROM Users WHERE username = '${maliciousInput}'`  // $ Alert
            },
            {
                Statement: `SELECT * FROM Users WHERE username = '${maliciousInput}'` // $ Alert
            }
        ]
    };

    dynamodb.batchExecuteStatement(params2, function(err, data) {});
});
