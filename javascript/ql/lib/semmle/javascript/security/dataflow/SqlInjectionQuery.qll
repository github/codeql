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
    any() // TODO: Make sure that the location overrides match the query's select clause: Column 1 does not select a source or sink originating from the flow call on line 28 (/Users/d10c/src/semmle-code/ql/javascript/ql/src/Security/CWE-089/SqlInjection.ql@35:8:35:21), Column 1 does not select a source or sink originating from the flow call on line 30 (/Users/d10c/src/semmle-code/ql/javascript/ql/src/experimental/heuristics/ql/src/Security/CWE-089/SqlInjection.ql@37:8:37:21), Column 5 does not select a source or sink originating from the flow call on line 28 (/Users/d10c/src/semmle-code/ql/javascript/ql/src/Security/CWE-089/SqlInjection.ql@35:82:35:97), Column 5 does not select a source or sink originating from the flow call on line 30 (/Users/d10c/src/semmle-code/ql/javascript/ql/src/experimental/heuristics/ql/src/Security/CWE-089/SqlInjection.ql@37:82:37:97)
  }

  Location getASelectedSourceLocation(DataFlow::Node source) {
    none() // TODO: Make sure that this source location matches the query's select clause: Column 1 does not select a source or sink originating from the flow call on line 28 (/Users/d10c/src/semmle-code/ql/javascript/ql/src/Security/CWE-089/SqlInjection.ql@35:8:35:21), Column 1 does not select a source or sink originating from the flow call on line 30 (/Users/d10c/src/semmle-code/ql/javascript/ql/src/experimental/heuristics/ql/src/Security/CWE-089/SqlInjection.ql@37:8:37:21), Column 5 does not select a source or sink originating from the flow call on line 28 (/Users/d10c/src/semmle-code/ql/javascript/ql/src/Security/CWE-089/SqlInjection.ql@35:82:35:97), Column 5 does not select a source or sink originating from the flow call on line 30 (/Users/d10c/src/semmle-code/ql/javascript/ql/src/experimental/heuristics/ql/src/Security/CWE-089/SqlInjection.ql@37:82:37:97)
  }

  Location getASelectedSinkLocation(DataFlow::Node sink) {
    none() // TODO: Make sure that this sink location matches the query's select clause: Column 1 does not select a source or sink originating from the flow call on line 28 (/Users/d10c/src/semmle-code/ql/javascript/ql/src/Security/CWE-089/SqlInjection.ql@35:8:35:21), Column 1 does not select a source or sink originating from the flow call on line 30 (/Users/d10c/src/semmle-code/ql/javascript/ql/src/experimental/heuristics/ql/src/Security/CWE-089/SqlInjection.ql@37:8:37:21), Column 5 does not select a source or sink originating from the flow call on line 28 (/Users/d10c/src/semmle-code/ql/javascript/ql/src/Security/CWE-089/SqlInjection.ql@35:82:35:97), Column 5 does not select a source or sink originating from the flow call on line 30 (/Users/d10c/src/semmle-code/ql/javascript/ql/src/experimental/heuristics/ql/src/Security/CWE-089/SqlInjection.ql@37:82:37:97)
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
