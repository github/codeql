var express = require('express');
var app = express();

import { Octokit } from "@octokit/core";
const kit = new Octokit();

app.get('/post/:id', function(req, res) {
    const id = req.params.id; // $ Source
    const response = kit.graphql(`
      query {
        repository(owner: "github", name: "${id}") {
          object(expression: "master:foo") {
            ... on Blob {
              text
            }
          }
        }
      }
    `); // $ Alert
});

import { graphql, withCustomRequest } from "@octokit/graphql";

app.get('/user/:id/', function(req, res) {
    const id = req.params.id; // $ Source
    const response = graphql(`foo ${id}`); // $ Alert

    const myGraphql = withCustomRequest(request);
    const response = myGraphql(`foo ${id}`); // $ Alert

    const withDefaults = graphql.defaults({});
    withDefaults(`foo ${id}`); // $ Alert
});

const { request } = require("@octokit/request");

app.get('/article/:id/', async function(req, res) {
    const id = req.params.id; // $ Source
    const result = await request("POST /graphql", {
      headers: {
        authorization: "token 0000000000000000000000000000000000000001",
      },
      query: `foo ${id}`, // $ Alert
    });

    const withDefaults = request.defaults({});
    withDefaults("POST /graphql", { query: `foo ${id}` }); // $ Alert
});

import { Octokit as Core } from "@octokit/rest";
const kit2 = new Core();

app.get('/event/:id/', async function(req, res) {
    const id = req.params.id; // $ Source
    const result = await kit2.graphql(`foo ${id}`); // $ Alert

    const result2 = await kit2.request("POST /graphql", { query: `foo ${id}` }); // $ Alert
});

import { graphql as nativeGraphql, buildSchema }  from 'graphql';
var schema = buildSchema(`
  type Query {
    hello: String
  }
`);
var root = {
  hello: () => {
    return 'Hello world!';
  },
};

app.get('/thing/:id', async function(req, res) {
  const id = req.query.id; // $ Source
  const result = await nativeGraphql(schema, "{ foo" + id + " }", root); // $ Alert

  fetch("https://my-grpahql-server.com/graphql", {
    method: "POST",
    headers: {
      "Content-Type": "application/json"
    },
    body: JSON.stringify({
      query: `{
        thing {
          name
          url
          ${id}
        }
      }` // $ Alert
    })
  })

  fetch("https://my-grpahql-server.com/graphql", {
    method: "POST",
    headers: {
      "Content-Type": "application/json"
    },
    body: JSON.stringify({

      query: `{
        thing {
          name
          url
          $id
        }
      }`,
      variables: {
        id: id
      }
    })
  })
});

const github = require('@actions/github');
app.get('/event/:id/', async function(req, res) {
    const kit = github.getOctokit("foo")

    const id = req.params.id; // $ Source
    const result = await kit.graphql(`foo ${id}`); // $ Alert
});
