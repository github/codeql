/**
 * Provides a taint-tracking configuration for reasoning about stored
 * cross-site scripting vulnerabilities.
 *
 * Note, for performance reasons: only import this file if
 * `StoredXSS::Configuration` is needed, otherwise
 * `XSS::StoredXSS` should be imported instead.
 */

import ruby
import codeql.ruby.DataFlow
import codeql.ruby.TaintTracking

/** Provides a taint-tracking configuration for cross-site scripting vulnerabilities. */
module StoredXss {
  import XSS::StoredXss

  /**
   * A taint-tracking configuration for reasoning about Stored XSS.
   */
  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "StoredXss" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    override predicate isSanitizer(DataFlow::Node node) {
      super.isSanitizer(node) or
      node instanceof Sanitizer
    }

    override predicate isSanitizerGuard(DataFlow::BarrierGuard guard) {
      guard instanceof SanitizerGuard
    }

    override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
      isAdditionalXssTaintStep(node1, node2)
    }
  }
}

/** DEPRECATED: Alias for StoredXss */
deprecated module StoredXSS = StoredXss;
