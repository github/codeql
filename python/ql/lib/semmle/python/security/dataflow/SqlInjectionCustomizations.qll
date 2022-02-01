/**
 * Provides default sources, sinks and sanitizers for detecting
 * "SQL injection"
 * vulnerabilities, as well as extension points for adding your own.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.Concepts
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.dataflow.new.BarrierGuards
private import semmle.python.frameworks.SqlAlchemy

/**
 * Provides default sources, sinks and sanitizers for detecting
 * "SQL injection"
 * vulnerabilities, as well as extension points for adding your own.
 */
module SqlInjection {
  /**
   * A data flow source for "SQL injection" vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for "SQL injection" vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for "SQL injection" vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A sanitizer guard for "SQL injection" vulnerabilities.
   */
  abstract class SanitizerGuard extends DataFlow::BarrierGuard { }

  /**
   * A source of remote user input, considered as a flow source.
   */
  class RemoteFlowSourceAsSource extends Source, RemoteFlowSource { }

  /**
   * A SQL statement of a SQL construction, considered as a flow sink.
   */
  class SqlConstructionAsSink extends Sink {
    SqlConstructionAsSink() { this = any(SqlConstruction c).getSql() }
  }

  /**
   * A SQL statement of a SQL execution, considered as a flow sink.
   */
  class SqlExecutionAsSink extends Sink {
    SqlExecutionAsSink() { this = any(SqlExecution e).getSql() }
  }

  /**
   * A comparison with a constant string, considered as a sanitizer-guard.
   */
  class StringConstCompareAsSanitizerGuard extends SanitizerGuard, StringConstCompare { }
}
