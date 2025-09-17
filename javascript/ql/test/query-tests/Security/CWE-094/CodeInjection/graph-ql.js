const express = require('express');
const { graphql, buildSchema } = require('graphql');

const app = express();
app.use(express.json());

const schema = buildSchema(`
  type Query {
    greet(name: String!): String
    calc(expr: String!): String
  }
`);

const root = {
  greet: ({ name }) => {
    return `Hello, ${name}!`;
  },
  calc: ({ expr }) => {
    try {
      return eval(expr).toString(); // $ Alert[js/code-injection]
    } catch (e) {
      return `Error: ${e.message}`;
    }
  }
};

app.post('/graphql', async (req, res) => {
  const { query, variables } = req.body; // $ Source[js/code-injection]
  const result = await graphql({
    schema,
    source: query,
    rootValue: root,
    variableValues: variables
  });
  res.json(result);
});
