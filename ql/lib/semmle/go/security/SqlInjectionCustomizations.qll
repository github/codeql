/**
 * Provides default sources, sinks and sanitizers for reasoning about SQL-injection vulnerabilities,
 * as well as extension points for adding your own.
 */

import go

/**
 * Provides extension points for customizing the taint tracking configuration for reasoning about
 * SQL-injection vulnerabilities.
 */
module SqlInjection {
  /**
   * A data flow source for SQL-injection vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for SQL-injection vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for SQL-injection vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A sanitizer guard for SQL-injection vulnerabilities.
   */
  abstract class SanitizerGuard extends DataFlow::BarrierGuard { }

  /** A source of untrusted data, considered as a taint source for SQL injection. */
  class UntrustedFlowAsSource extends Source {
    UntrustedFlowAsSource() { this instanceof UntrustedFlowSource }
  }

  /** An SQL string, considered as a taint sink for SQL injection. */
  class SqlQueryAsSink extends Sink {
    SqlQueryAsSink() { this instanceof SQL::QueryString }
  }

  /** A NoSQL query, considered as a taint sink for SQL injection. */
  class NoSqlQueryAsSink extends Sink {
    NoSqlQueryAsSink() { this instanceof NoSQL::Query }
  }
}
