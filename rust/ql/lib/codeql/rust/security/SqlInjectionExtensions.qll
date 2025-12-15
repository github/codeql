/**
 * Provides classes and predicates for reasoning about database
 * queries built from user-controlled sources (that is, SQL injection
 * vulnerabilities).
 */

import rust
private import codeql.rust.dataflow.DataFlow
private import codeql.rust.dataflow.FlowSink
private import codeql.rust.Concepts
private import codeql.util.Unit
private import codeql.rust.security.Barriers as Barriers

/**
 * Provides default sources, sinks and barriers for detecting SQL injection
 * vulnerabilities, as well as extension points for adding your own.
 */
module SqlInjection {
  /**
   * A data flow source for SQL injection vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for SQL injection vulnerabilities.
   */
  abstract class Sink extends QuerySink::Range {
    override string getSinkType() { result = "SqlInjection" }
  }

  /**
   * A barrier for SQL injection vulnerabilities.
   */
  abstract class Barrier extends DataFlow::Node { }

  /**
   * An active threat-model source, considered as a flow source.
   */
  private class ActiveThreatModelSourceAsSource extends Source, ActiveThreatModelSource { }

  /**
   * A flow sink that is the statement of an SQL construction.
   */
  class SqlConstructionAsSink extends Sink {
    SqlConstructionAsSink() { this = any(SqlConstruction c).getSql() }
  }

  /**
   * A flow sink that is the statement of an SQL execution.
   */
  class SqlExecutionAsSink extends Sink {
    SqlExecutionAsSink() { this = any(SqlExecution e).getSql() }
  }

  /**
   * A sink for sql-injection from model data.
   */
  private class ModelsAsDataSink extends Sink {
    ModelsAsDataSink() { sinkNode(this, "sql-injection") }
  }

  /**
   * A barrier for SQL injection vulnerabilities for nodes whose type is a numeric
   * type, which is unlikely to expose any vulnerability.
   */
  private class NumericTypeBarrier extends Barrier instanceof Barriers::NumericTypeBarrier { }

  private class BooleanTypeBarrier extends Barrier instanceof Barriers::BooleanTypeBarrier { }

  private class FieldlessEnumTypeBarrier extends Barrier instanceof Barriers::FieldlessEnumTypeBarrier
  { }
}
