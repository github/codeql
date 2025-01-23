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

  predicate observeDiffInformedIncrementalMode() {
    // TODO(diff-informed): Manually verify if config can be diff-informed.
    // ql/src/Security/CWE-089/SqlInjection.ql:35: Column 1 does not select a source or sink originating from the flow call on line 28
    // ql/src/Security/CWE-089/SqlInjection.ql:35: Column 5 does not select a source or sink originating from the flow call on line 28
    // ql/src/experimental/heuristics/ql/src/Security/CWE-089/SqlInjection.ql:37: Column 1 does not select a source or sink originating from the flow call on line 30
    // ql/src/experimental/heuristics/ql/src/Security/CWE-089/SqlInjection.ql:37: Column 5 does not select a source or sink originating from the flow call on line 30
    none()
  }
}

/**
 * Taint-tracking for reasoning about string based query injection vulnerabilities.
 */
module SqlInjectionFlow = TaintTracking::Global<SqlInjectionConfig>;

/**
 * DEPRECATED. Use the `SqlInjectionFlow` module instead.
 */
deprecated class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "SqlInjection" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  override predicate isSanitizer(DataFlow::Node node) {
    super.isSanitizer(node) or
    node instanceof Sanitizer
  }

  override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
    SqlInjectionConfig::isAdditionalFlowStep(pred, succ)
  }
}
