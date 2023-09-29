/**
 * Provides classes for working with Apollo GraphQL connectors.
 */

import javascript

/** Provides classes modeling concepts of Apollo GraphQL. */
module ApolloGraphQL {
  /** A string-valued expression that is interpreted as a Apollo GraphQL query. */
  abstract class GraphQLString extends DataFlow::Node { }

  /** A string-valued expression that is interpreted as a Apollo GraphQL query. */
  abstract class ApolloGraphQLServer extends DataFlow::Node { }
}

/**
 * Provides classes modeling the apollo packages [@apollo/server](https://npmjs.com/package/@apollo/server`)
 */
private module Apollo {
  /** Get an instanceof of `Apollo` */
  private API::Node apollo() {
    result =
      API::moduleImport([
          "@apollo/server", "apollo/server", "@apollo/apollo-server-express",
          "@apollo/apollo-server-core", "apollo-server", "apollo-server-express"
        ]).getMember("ApolloServer")
  }

  /** Get an instanceof of `gql` */
  private API::Node gql() {
    result =
      API::moduleImport([
          "@apollo/server", "apollo/server", "@apollo/apollo-server-express",
          "@apollo/apollo-server-core", "apollo-server", "apollo-server-express"
        ]).getMember("gql")
  }

  /** A string that is interpreted as a GraphQL query by a `octokit` package. */
  private class ApolloGraphQLString extends GraphQL::GraphQLString {
    ApolloGraphQLString() { this = gql().getACall() }
  }

  /** A string that is interpreted as a GraphQL query by a `graphql` package. */
  private class ApolloServer extends ApolloGraphQL::ApolloGraphQLServer {
    ApolloServer() {
      this = apollo().getAnInstantiation()
      // or this = apollo().getAnInstantiation().getOptionArgument(0, "cors")
    }

    predicate isPermissive() {
      this.(DataFlow::NewNode)
          .getOptionArgument(0, "cors")
          .getALocalSource()
          .getAPropertyWrite("origin")
          .getRhs()
          .mayHaveBooleanValue(true)
    }
  }
}
