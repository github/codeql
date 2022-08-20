/**
 * Provides classes for working with GraphQL connectors.
 */

import javascript

/** Provides classes modeling concepts of GraphQL connectors. */
module GraphQL {
  /** A string-valued expression that is interpreted as a GraphQL query. */
  abstract class GraphQLString extends DataFlow::Node { }
}

/**
 * Provides classes modeling the octokit packages [@octokit/core](https://npmjs.com/package/@octokit/core),
 * [@octokit/graphql](https://npmjs.com/package/@octokit/graphql), [@octokit/rest](https://npmjs.com/package/@octokit/rest),
 * and [@octokit/request](https://npmjs.com/package/@octokit/request).
 */
private module Octokit {
  /** Get an instanceof of `Octokit` */
  private API::Node octokit() {
    result =
      API::moduleImport(["@octokit/core", "@octokit/rest"]).getMember("Octokit").getInstance()
    or
    result = API::moduleImport("@actions/github").getMember("getOctokit").getReturn()
  }

  /**
   * Gets a reference to a `graphql` function from a `octokit` package.
   */
  private API::Node graphQLCallee() {
    result = API::moduleImport(["@octokit/graphql", "@octokit/core"]).getMember("graphql")
    or
    result = octokit().getMember("graphql")
    or
    result = API::moduleImport("@octokit/graphql").getMember("withCustomRequest").getReturn()
    or
    result = graphQLCallee().getMember("defaults").getReturn()
  }

  /**
   * Gets a reference to a `request` function from a `octokit` package.
   */
  private API::Node requestCallee() {
    result =
      API::moduleImport(["@octokit/core", "@octokit/request", "@octokit/graphql"])
          .getMember("request")
    or
    result = octokit().getMember("request")
    or
    result = requestCallee().getMember("defaults").getReturn()
  }

  /** A string that is interpreted as a GraphQL query by a `octokit` package. */
  private class GraphQLString extends GraphQL::GraphQLString {
    GraphQLString() { this = graphQLCallee().getACall().getArgument(0) }
  }

  /**
   * A call to `request` seen as a client request.
   * E.g. `await request("POST /graphql", { query: {...data} });`
   */
  private class RequestClientRequest extends ClientRequest::Range, API::CallNode {
    RequestClientRequest() { this = requestCallee().getACall() }

    override DataFlow::Node getUrl() {
      result = this.getArgument(0) // contains both the method and the URL, but it's close enough
    }

    override DataFlow::Node getHost() { none() }

    override DataFlow::Node getADataNode() { result = this.getArgument(1) }
  }
}

/**
 * Provides classes modeling [graphql](https://npmjs.com/package/graphql).
 */
private module GraphQLLib {
  /** A string that is interpreted as a GraphQL query by a `graphql` package. */
  private class GraphQLString extends GraphQL::GraphQLString {
    GraphQLString() {
      this = API::moduleImport("graphql").getMember("graphql").getACall().getArgument(1)
    }
  }

  /**
   * A client request that appears to be a GraphQL query.
   * Using a client-request in this way to execute GraphQL is documented by e.g:
   *  - [graphql](https://graphql.org/graphql-js/graphql-clients/)
   *  - [shopify](https://shopify.dev/tutorials/graphql-with-node-and-express)
   *  - [@octokit/request](https://npmjs.com/package/@octokit/request)
   */
  private class GraphQLRequest extends GraphQL::GraphQLString {
    GraphQLRequest() {
      exists(ClientRequest req |
        this =
          [req.getADataNode(), req.getADataNode().(JsonStringifyCall).getInput()]
              .getALocalSource()
              .getAPropertyWrite("query")
              .getRhs()
      |
        containsGraphQLIndicator(req.getUrl())
      )
    }
  }

  /**
   * Holds if `node` is a node that likely contains an URL to a GraphQL endpoint.
   */
  private predicate containsGraphQLIndicator(DataFlow::Node node) {
    node.getStringValue().regexpMatch("(?i).*graphql.*")
    or
    node.(DataFlow::PropRead).getPropertyName().regexpMatch("(?i).*graphql.*")
    or
    containsGraphQLIndicator(node.(StringOps::Concatenation).getAnOperand())
    or
    containsGraphQLIndicator(node.getAPredecessor())
  }
}
