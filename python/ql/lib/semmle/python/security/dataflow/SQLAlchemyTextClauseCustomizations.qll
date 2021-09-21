/**
 * Provides default sources, sinks and sanitizers for detecting
 * "SQLAlchemy TextClause injection"
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
 * "SQLAlchemy TextClause injection"
 * vulnerabilities, as well as extension points for adding your own.
 */
module SQLAlchemyTextClause {
  /**
   * A data flow source for "SQLAlchemy TextClause injection" vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for "SQLAlchemy TextClause injection" vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for "SQLAlchemy TextClause injection" vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A sanitizer guard for "SQLAlchemy TextClause injection" vulnerabilities.
   */
  abstract class SanitizerGuard extends DataFlow::BarrierGuard { }

  /**
   * A source of remote user input, considered as a flow source.
   */
  class RemoteFlowSourceAsSource extends Source, RemoteFlowSource { }

  /**
   * The text argument of a SQLAlchemy TextClause construction, considered as a flow sink.
   */
  class TextArgAsSink extends Sink {
    TextArgAsSink() { this = any(SqlAlchemy::TextClause::TextClauseConstruction tcc).getTextArg() }
  }

  /**
   * A comparison with a constant string, considered as a sanitizer-guard.
   */
  class StringConstCompareAsSanitizerGuard extends SanitizerGuard, StringConstCompare { }
}
