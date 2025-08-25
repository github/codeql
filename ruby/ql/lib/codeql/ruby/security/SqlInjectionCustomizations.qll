/**
 * Provides default sources, sinks and sanitizers for detecting SQL injection
 * vulnerabilities, as well as extension points for adding your own.
 */

private import codeql.ruby.Concepts
private import codeql.ruby.DataFlow
private import codeql.ruby.dataflow.BarrierGuards
private import codeql.ruby.dataflow.RemoteFlowSources
private import codeql.ruby.ApiGraphs
private import codeql.ruby.frameworks.data.internal.ApiGraphModels

/**
 * Provides default sources, sinks and sanitizers for detecting SQL injection
 * vulnerabilities, as well as extension points for adding your own.
 */
module SqlInjection {
  /** A data flow source for SQL injection vulnerabilities. */
  abstract class Source extends DataFlow::Node { }

  /** A data flow sink for SQL injection vulnerabilities. */
  abstract class Sink extends DataFlow::Node { }

  /** A sanitizer for SQL injection vulnerabilities. */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A source of remote user input, considered as a flow source.
   */
  private class RemoteFlowSourceAsSource extends Source, RemoteFlowSource { }

  /**
   * An SQL statement of a SQL execution, considered as a flow sink.
   */
  private class SqlExecutionAsSink extends Sink {
    SqlExecutionAsSink() { this = any(SqlExecution e).getSql() }
  }

  /**
   * An SQL statement of a SQL construction, considered as a flow sink.
   */
  private class SqlConstructionAsSink extends Sink {
    SqlConstructionAsSink() { this = any(SqlConstruction e).getSql() }
  }

  /**
   * A comparison with a constant string, considered as a sanitizer-guard.
   */
  private class StringConstCompareAsSanitizerGuard extends Sanitizer, StringConstCompareBarrier { }

  /**
   * An inclusion check against an array of constant strings, considered as a
   * sanitizer-guard.
   */
  class StringConstArrayInclusionCallAsSanitizer extends Sanitizer,
    StringConstArrayInclusionCallBarrier
  { }

  private class SqlSanitizationAsSanitizer extends Sanitizer, SqlSanitization { }

  private class ExternalSqlInjectionSink extends Sink {
    ExternalSqlInjectionSink() { this = ModelOutput::getASinkNode("sql-injection").asSink() }
  }
}
