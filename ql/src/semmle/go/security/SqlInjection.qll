/**
 * Provides a taint tracking configuration for reasoning about SQL-injection vulnerabilities.
 *
 * Note: for performance reasons, only import this file if `SqlInjection::Configuration` is needed,
 * otherwise `SqlInjectionCustomizations` should be imported instead.
 */

import go

/**
 * Provides a taint tracking configuration for reasoning about SQL-injection vulnerabilities.
 */
module SqlInjection {
  import SqlInjectionCustomizations::SqlInjection

  /**
   * A taint-tracking configuration for reasoning about SQL-injection vulnerabilities.
   */
  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "SqlInjection" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
      NoSQL::isAdditionalMongoTaintStep(pred, succ)
    }

    override predicate isSanitizer(DataFlow::Node node) {
      super.isSanitizer(node) or
      node instanceof Sanitizer
    }

    override predicate isSanitizerGuard(DataFlow::BarrierGuard guard) {
      guard instanceof SanitizerGuard
    }
  }
}
