/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * SQL injection vulnerabilities, as well as extension points for
 * adding your own.
 */

import javascript

module SqlInjection {
  /**
   * A data flow source for SQL injection vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for SQL injection vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for SQL injection vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /** A source of remote user input, considered as a flow source for SQL injection. */
  class RemoteFlowSourceAsSource extends Source {
    RemoteFlowSourceAsSource() { this instanceof RemoteFlowSource }
  }

  /** An SQL expression passed to an API call that executes SQL. */
  class SqlInjectionExprSink extends Sink, DataFlow::ValueNode {
    override SQL::SqlString astNode;
  }

  /** An expression that sanitizes a value for the purposes of SQL injection. */
  class SanitizerExpr extends Sanitizer, DataFlow::ValueNode {
    SanitizerExpr() { astNode = any(SQL::SqlSanitizer ss).getOutput() }
  }
}
