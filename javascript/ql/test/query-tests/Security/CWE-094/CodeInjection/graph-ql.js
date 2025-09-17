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

  const root1 = {
    greet: ({ name, title }) => {
      return eval(name + title).toString(); // $ Alert[js/code-injection]
    }
  };
  graphql({
    schema: buildSchema(`
    type Query {
      greet(name: String!, title: String): String
    }
  `),
    source: `
      query GreetUser($name: String!, $title: String) {
        greet(name: $name, title: $title)
      }
    `,
    rootValue: root1,
    variableValues: variables
  });
});
