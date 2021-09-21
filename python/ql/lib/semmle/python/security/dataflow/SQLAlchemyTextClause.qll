/**
 * Provides a taint-tracking configuration for detecting "SQLAlchemy TextClause injection" vulnerabilities.
 *
 * Note, for performance reasons: only import this file if
 * `SQLAlchemyTextClause::Configuration` is needed, otherwise
 * `SQLAlchemyTextClauseCustomizations` should be imported instead.
 */

private import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking

/**
 * Provides a taint-tracking configuration for detecting "SQLAlchemy TextClause injection" vulnerabilities.
 */
module SQLAlchemyTextClause {
  import SQLAlchemyTextClauseCustomizations::SQLAlchemyTextClause

  /**
   * A taint-tracking configuration for detecting "SQLAlchemy TextClause injection" vulnerabilities.
   */
  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "SQLAlchemyTextClause" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    override predicate isSanitizer(DataFlow::Node node) { node instanceof Sanitizer }

    override predicate isSanitizerGuard(DataFlow::BarrierGuard guard) {
      guard instanceof SanitizerGuard
    }
  }
}
