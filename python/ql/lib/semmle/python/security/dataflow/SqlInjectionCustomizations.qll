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
   * DEPRECATED: Use `ActiveThreatModelSource` from Concepts instead!
   */
  deprecated class RemoteFlowSourceAsSource = ActiveThreatModelSourceAsSource;

  /**
   * An active threat-model source, considered as a flow source.
   */
  private class ActiveThreatModelSourceAsSource extends Source, ActiveThreatModelSource { }

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
   * A comparison with a constant, considered as a sanitizer-guard.
   */
  class ConstCompareAsSanitizerGuard extends Sanitizer, ConstCompareBarrier { }

  /** DEPRECATED: Use ConstCompareAsSanitizerGuard instead. */
  deprecated class StringConstCompareAsSanitizerGuard = ConstCompareAsSanitizerGuard;

  private import semmle.python.frameworks.data.ModelsAsData

  /** A sink for sql-injection from model data. */
  private class DataAsSqlSink extends Sink {
    DataAsSqlSink() { this = ModelOutput::getASinkNode("sql-injection").asSink() }
  }
}
