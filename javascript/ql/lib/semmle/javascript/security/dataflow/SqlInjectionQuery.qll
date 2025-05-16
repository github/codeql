/**
 * Provides a taint tracking configuration for reasoning about string based
 * query injection vulnerabilities
 *
 * Note, for performance reasons: only import this file if
 * `SqlInjection::Configuration` is needed, otherwise
 * `SqlInjectionCustomizations` should be imported instead.
 */

import javascript
import SqlInjectionCustomizations::SqlInjection

/**
 * A taint-tracking configuration for reasoning about string based query injection vulnerabilities.
 */
module SqlInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    exists(LdapJS::TaintPreservingLdapFilterStep filter |
      node1 = filter.getInput() and
      node2 = filter.getOutput()
    )
    or
    exists(HtmlSanitizerCall call |
      node1 = call.getInput() and
      node2 = call
    )
  }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/**
 * Taint-tracking for reasoning about string based query injection vulnerabilities.
 */
module SqlInjectionFlow = TaintTracking::Global<SqlInjectionConfig>;
