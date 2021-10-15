/**
 * Provides a taint-tracking configuration for detecting "SQL injection" vulnerabilities.
 *
 * Note, for performance reasons: only import this file if
 * `SqlInjection::Configuration` is needed, otherwise
 * `SqlInjectionCustomizations` should be imported instead.
 */

private import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking

/**
 * Provides a taint-tracking configuration for detecting "SQL injection" vulnerabilities.
 */
module SqlInjection {
  import SqlInjectionCustomizations::SqlInjection

  /**
   * A taint-tracking configuration for detecting "SQL injection" vulnerabilities.
   */
  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "SqlInjection" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    override predicate isSanitizer(DataFlow::Node node) { node instanceof Sanitizer }

    override predicate isSanitizerGuard(DataFlow::BarrierGuard guard) {
      guard instanceof SanitizerGuard
    }
  }
}

/**
 * DEPRECATED: Don't extend this class for customization, since this will lead to bad
 * performance, instead use the new `SqlInjectionCustomizations.qll` file, and extend
 * its' classes.
 */
deprecated class SQLInjectionConfiguration = SqlInjection::Configuration;
