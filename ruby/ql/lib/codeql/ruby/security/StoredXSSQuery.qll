/**
 * Provides a taint-tracking configuration for reasoning about stored
 * cross-site scripting vulnerabilities.
 *
 * Note, for performance reasons: only import this file if
 * `StoredXssFlow` is needed, otherwise
 * `XSS::StoredXss` should be imported instead.
 */

import codeql.ruby.AST
import codeql.ruby.DataFlow
import codeql.ruby.TaintTracking

/**
 * Provides a taint-tracking configuration for cross-site scripting vulnerabilities.
 * DEPRECATED: Use StoredXssFlow
 */
deprecated module StoredXss {
  import XSS::StoredXss

  /**
   * DEPRECATED.
   *
   * A taint-tracking configuration for reasoning about Stored XSS.
   */
  deprecated class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "StoredXss" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    override predicate isSanitizer(DataFlow::Node node) {
      super.isSanitizer(node) or
      node instanceof Sanitizer
    }

    override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
      isAdditionalXssTaintStep(node1, node2)
    }
  }

  import TaintTracking::Global<StoredXssConfig>
}

private module StoredXssConfig implements DataFlow::ConfigSig {
  private import XSS::StoredXss

  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    isAdditionalXssTaintStep(node1, node2)
  }
}

/**
 * Taint-tracking for reasoning about Stored XSS.
 */
module StoredXssFlow = TaintTracking::Global<StoredXssConfig>;
