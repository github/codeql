var express = require('express');
var app = express();

import { Octokit } from "@octokit/core";
const kit = new Octokit();

app.get('/post/:id', function(req, res) {
    const id = req.params.id;
    // NOT OK
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
    `);
});

import { graphql, withCustomRequest } from "@octokit/graphql";

app.get('/user/:id/', function(req, res) {
    const id = req.params.id;
    const response = graphql(`foo ${id}`); // NOT OK

    const myGraphql = withCustomRequest(request);
    const response = myGraphql(`foo ${id}`); // NOT OK

    const withDefaults = graphql.defaults({});
    withDefaults(`foo ${id}`); // NOT OK
});

const { request } = require("@octokit/request");

app.get('/article/:id/', async function(req, res) {
    const id = req.params.id;
    const result = await request("POST /graphql", {
      headers: {
        authorization: "token 0000000000000000000000000000000000000001",
      },
      query: `foo ${id}`, // NOT OK
    });

    const withDefaults = request.defaults({});
    withDefaults("POST /graphql", { query: `foo ${id}` }); // NOT OK
});

import { Octokit as Core } from "@octokit/rest";
const kit2 = new Core();

app.get('/event/:id/', async function(req, res) {
    const id = req.params.id;
    const result = await kit2.graphql(`foo ${id}`); // NOT OK

    const result2 = await kit2.request("POST /graphql", { query: `foo ${id}` }); // NOT OK
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
  const id = req.query.id;
  const result = await nativeGraphql(schema, "{ foo" + id + " }", root); // NOT OK
  
  fetch("https://my-grpahql-server.com/graphql", {
    method: "POST",
    headers: {
      "Content-Type": "application/json"
    },
    body: JSON.stringify({
      // NOT OK
      query: `{
        thing {
          name
          url
          ${id}
        }
      }`
    })
  })

  fetch("https://my-grpahql-server.com/graphql", {
    method: "POST",
    headers: {
      "Content-Type": "application/json"
    },
    body: JSON.stringify({
      // OK
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

    const id = req.params.id;
    const result = await kit.graphql(`foo ${id}`); // NOT OK
});
