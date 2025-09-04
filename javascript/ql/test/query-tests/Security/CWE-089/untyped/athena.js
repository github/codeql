const { AthenaClient, StartQueryExecutionCommand, CreateNamedQueryCommand, UpdateNamedQueryCommand, CreatePreparedStatementCommand } = require("@aws-sdk/client-athena");
const AWS = require('aws-sdk');
const express = require('express');
const bodyParser = require('body-parser');
const app = express();
app.use(bodyParser.json());

app.post('/v3/athena/all', async (req, res) => {
    const userQuery = req.body.query; // $ Source

    const client = new AthenaClient({ region: "us-east-1" });

    const params1 = {   
        QueryString: "SQL" + userQuery,
        QueryExecutionContext: { Database: "default" },
        ResultConfiguration: { OutputLocation: "s3://my-results/" }
    };
    const p = new StartQueryExecutionCommand(params1);
    await client.send(p); // $ Alert

    const params2 = {
        Name: "user_query",
        Database: "default",
        QueryString: userQuery,
        Description: "User-provided query"
    };
    await client.send(new CreateNamedQueryCommand(params2)); // $ Alert -- This only stores query to database, not executed

    const params3 = {
        NamedQueryId: "namedQueryId",
        Name: "user_query_updated",
        Database: "default",
        QueryString: userQuery,
        Description: "Updated user-provided query"
    };
    await client.send(new UpdateNamedQueryCommand(params3)); // $ Alert -- This only stores query to database, not executed

    res.end();
});


app.post('/v2/athena/all', async (req, res) => {
    const userQuery = req.body.query; // $ Source

    const athena = new AWS.Athena({ region: "us-east-1" });

    const params1 = {
        QueryString: userQuery,  // $ Alert
        QueryExecutionContext: { Database: "default" },
        ResultConfiguration: { OutputLocation: "s3://my-results/" }
    };
    await athena.startQueryExecution(params1).promise();

    const params2 = {
        Name: "user_query",
        Database: "default",
        QueryString: userQuery, // $ Alert -- This only stores query to database, not executed
        Description: "User-provided query"
    };
    await athena.createNamedQuery(params2).promise();

    const params3 = {
        NamedQueryId: "namedQueryId",
        Name: "user_query_updated",
        Database: "default",
        QueryString: userQuery, // $ Alert -- This only stores query to database, not executed
        Description: "Updated user-provided query"
    };
    await athena.updateNamedQuery(params3).promise();

    res.end();
});

app.post('/dynamodb-v3', async (req, res) => {
    const userQueryStatement = req.body.query; // $ Source
    const client = new AthenaClient({ region: "us-east-1" });
    const input = {
        StatementName: "STRING_VALUE",
        WorkGroup: "STRING_VALUE",
        QueryStatement: userQueryStatement,
        Description: "STRING_VALUE",
    };
    const command = new CreatePreparedStatementCommand(input);
    await client.send(command); // $ Alert
});
