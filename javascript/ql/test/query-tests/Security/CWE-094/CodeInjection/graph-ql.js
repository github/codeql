const express = require('express');
const { graphql, buildSchema, GraphQLObjectType, GraphQLString } = require('graphql');

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

  const MutationType = new GraphQLObjectType({
    name: 'Mutation',
    fields: {
      runEval: {
        type: GraphQLString,
        args: {
          value: { type: GraphQLString }
        },
        resolve: (_, { value }, context) => { // $ Source[js/code-injection]
          return eval(value); // $ Alert[js/code-injection]
        }
      }
    }
  });
  
  const schema = new GraphQLSchema({
    query: QueryType,
    mutation: MutationType
  });

  await graphql({
    schema,
    source: query,
    variableValues: variables
  });
});
