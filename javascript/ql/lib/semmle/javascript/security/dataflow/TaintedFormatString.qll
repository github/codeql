/**
 * Provides a taint-tracking configuration for reasoning about format
 * injections.
 *
 *
 * Note, for performance reasons: only import this file if
 * `TaintedFormatString::Configuration` is needed, otherwise
 * `TaintedFormatStringCustomizations` should be imported instead.
 */

import javascript
import semmle.javascript.security.dataflow.DOM

module TaintedFormatString {
  import TaintedFormatStringCustomizations::TaintedFormatString

  /**
   * A taint-tracking configuration for format injections.
   */
  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "TaintedFormatString" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    override predicate isSanitizer(DataFlow::Node node) {
      super.isSanitizer(node) or
      node instanceof Sanitizer
    }
  }
}
