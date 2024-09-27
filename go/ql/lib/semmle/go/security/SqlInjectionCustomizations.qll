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
   * DEPRECATED: Use `ActiveThreatModelSource` or `Source` instead.
   */
  deprecated class UntrustedFlowAsSource = ThreatModelFlowAsSource;

  /** A source of untrusted data, considered as a taint source for SQL injection. */
  private class ThreatModelFlowAsSource extends Source instanceof ActiveThreatModelSource { }

  /** An SQL string, considered as a taint sink for SQL injection. */
  class SqlQueryAsSink extends Sink instanceof SQL::QueryString { }

  /** A NoSql query, considered as a taint sink for SQL injection. */
  class NoSqlQueryAsSink extends Sink instanceof NoSql::Query { }

  /**
   * A numeric- or boolean-typed node, considered a sanitizer for sql injection.
   */
  class NumericOrBooleanSanitizer extends Sanitizer {
    NumericOrBooleanSanitizer() {
      this.getType() instanceof NumericType or this.getType() instanceof BoolType
    }
  }
}
