/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * string based query injection vulnerabilities, as well as extension
 * points for adding your own.
 */

import javascript

module SqlInjection {
  /**
   * A data flow source for string based query injection vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for string based query injection vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for string based query injection vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /** A source of remote user input, considered as a flow source for string based query injection. */
  class RemoteFlowSourceAsSource extends Source {
    RemoteFlowSourceAsSource() { this instanceof RemoteFlowSource }
  }

  /** An SQL expression passed to an API call that executes SQL. */
  class SqlInjectionExprSink extends Sink, DataFlow::ValueNode {
    override SQL::SqlString astNode;
  }

  /** An expression that sanitizes a value for the purposes of string based query injection. */
  class SanitizerExpr extends Sanitizer, DataFlow::ValueNode {
    SanitizerExpr() { astNode = any(SQL::SqlSanitizer ss).getOutput() }
  }

  /** An GraphQL expression passed to an API call that executes GraphQL. */
  class GraphqlInjectionSink extends Sink {
    GraphqlInjectionSink() { this instanceof GraphQL::GraphQLString }
  }
}
