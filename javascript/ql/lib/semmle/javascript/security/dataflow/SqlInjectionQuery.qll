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

  predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(LdapJS::TaintPreservingLdapFilterStep filter |
      pred = filter.getInput() and
      succ = filter.getOutput()
    )
    or
    exists(HtmlSanitizerCall call |
      pred = call.getInput() and
      succ = call
    )
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
