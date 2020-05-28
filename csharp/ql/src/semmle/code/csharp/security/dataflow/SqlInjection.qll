/**
 * Provides a taint-tracking configuration for reasoning about SQL injection vulnerabilities.
 */

import csharp

module SqlInjection {
  import semmle.code.csharp.security.dataflow.flowsources.Remote
  import semmle.code.csharp.security.dataflow.flowsources.Local
  import semmle.code.csharp.frameworks.Sql
  import semmle.code.csharp.security.Sanitizers

  /**
   * A source specific to SQL injection vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A sink for SQL injection vulnerabilities.
   */
  abstract class Sink extends DataFlow::ExprNode { }

  /**
   * A sanitizer for SQL injection vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::ExprNode { }

  /**
   * A taint-tracking configuration for SQL injection vulnerabilities.
   */
  class TaintTrackingConfiguration extends TaintTracking::Configuration {
    TaintTrackingConfiguration() { this = "SqlInjection" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    override predicate isSanitizer(DataFlow::Node node) { node instanceof Sanitizer }
  }

  /** A source of remote user input. */
  class RemoteSource extends Source {
    RemoteSource() { this instanceof RemoteFlowSource }
  }

  /** A source of local user input. */
  class LocalSource extends Source {
    LocalSource() { this instanceof LocalFlowSource }
  }

  /** An SQL expression passed to an API call that executes SQL. */
  class SqlInjectionExprSink extends Sink {
    SqlInjectionExprSink() { exists(SqlExpr s | this.getExpr() = s.getSql()) }
  }

  private class SimpleTypeSanitizer extends Sanitizer, SimpleTypeSanitizedExpr { }

  private class GuidSanitizer extends Sanitizer, GuidSanitizedExpr { }
}
