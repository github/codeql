/**
 * Provides a taint-tracking configuration for reasoning about reflected
 * cross-site scripting vulnerabilities.
 */

import go

module ReflectedXss {
  import ReflectedXssCustomizations::ReflectedXss

  /**
   * A taint-tracking configuration for reasoning about XSS.
   */
  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "ReflectedXss" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    override predicate isSanitizer(DataFlow::Node node) {
      super.isSanitizer(node) or
      node instanceof Sanitizer
    }

    override predicate isBarrierGuard(DataFlow::BarrierGuard guard) { guard instanceof SanitizerGuard }
  }
}
