/**
 * Provides a taint-tracking configuration for reasoning about command-injection
 * vulnerabilities (CWE-078).
 */

import javascript
import IndirectCommandInjectionCustomizations::IndirectCommandInjection
private import IndirectCommandArgument

/**
 * A taint-tracking configuration for reasoning about command-injection vulnerabilities.
 */
module IndirectCommandInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  /**
   * Holds if `sink` is a data-flow sink for command-injection vulnerabilities, and
   * the alert should be placed at the node `highlight`.
   */
  additional predicate isSinkWithHighlight(DataFlow::Node sink, DataFlow::Node highlight) {
    sink instanceof Sink and highlight = sink
    or
    isIndirectCommandArgument(sink, highlight)
  }

  predicate isSink(DataFlow::Node sink) { isSinkWithHighlight(sink, _) }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }

  predicate observeDiffInformedIncrementalMode() { any() }

  Location getASelectedSourceLocation(DataFlow::Node source) {
    none() // TODO: Make sure that this source location matches the query's select clause: Column 1 does not select a source or sink originating from the flow call on line 25 (/Users/d10c/src/semmle-code/ql/javascript/ql/src/Security/CWE-078/IndirectCommandInjection.ql@29:8:29:16)
  }

  Location getASelectedSinkLocation(DataFlow::Node sink) {
    exists(DataFlow::Node node |
      isSinkWithHighlight(sink, node) and
      result = node.getLocation()
    )
    // TODO: Make sure that this sink location matches the query's select clause: Column 1 does not select a source or sink originating from the flow call on line 25 (/Users/d10c/src/semmle-code/ql/javascript/ql/src/Security/CWE-078/IndirectCommandInjection.ql@29:8:29:16)
  }
}

/**
 * Taint-tracking for reasoning about command-injection vulnerabilities.
 */
module IndirectCommandInjectionFlow = TaintTracking::Global<IndirectCommandInjectionConfig>;

/**
 * DEPRECATED. Use the `IndirectCommandInjectionFlow` module instead.
 */
deprecated class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "IndirectCommandInjection" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  /**
   * Holds if `sink` is a data-flow sink for command-injection vulnerabilities, and
   * the alert should be placed at the node `highlight`.
   */
  predicate isSinkWithHighlight(DataFlow::Node sink, DataFlow::Node highlight) {
    sink instanceof Sink and highlight = sink
    or
    isIndirectCommandArgument(sink, highlight)
  }

  override predicate isSink(DataFlow::Node sink) { this.isSinkWithHighlight(sink, _) }

  override predicate isSanitizer(DataFlow::Node node) { node instanceof Sanitizer }
}
