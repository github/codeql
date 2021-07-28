/**
 * Provides a taint tracking configuration for reasoning about XML
 * External Entity (XXE) vulnerabilities.
 *
 * Note, for performance reasons: only import this file if
 * `Xxe::Configuration` is needed, otherwise `XxeCustomizations`
 * should be imported instead.
 */

import javascript

module Xxe {
  import XxeCustomizations::Xxe

  /**
   * A taint-tracking configuration for reasoning about XXE vulnerabilities.
   */
  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "Xxe" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    override predicate isSanitizer(DataFlow::Node node) {
      super.isSanitizer(node) or
      node instanceof Sanitizer
    }
  }
}
