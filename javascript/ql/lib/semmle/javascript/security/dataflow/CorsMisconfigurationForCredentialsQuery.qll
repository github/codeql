/**
 * Provides a dataflow taint tracking configuration for reasoning
 * about CORS misconfiguration for credentials transfer.
 *
 * Note, for performance reasons: only import this file if
 * `CorsMisconfigurationForCredentials::Configuration` is needed,
 * otherwise `CorsMisconfigurationForCredentialsCustomizations` should
 * be imported instead.
 */

import javascript
import CorsMisconfigurationForCredentialsCustomizations::CorsMisconfigurationForCredentials

/**
 * A data flow configuration for CORS misconfiguration for credentials transfer.
 */
module CorsMisconfigurationConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) {
    node instanceof Sanitizer or
    node = TaintTracking::AdHocWhitelistCheckSanitizer::getABarrierNode()
  }

  predicate observeDiffInformedIncrementalMode() {
    // TODO(diff-informed): Manually verify if config can be diff-informed.
    // ql/src/Security/CWE-346/CorsMisconfigurationForCredentials.ql:22: Column 5 selects sink.getCredentialsHeader
    // ql/src/experimental/heuristics/ql/src/Security/CWE-346/CorsMisconfigurationForCredentials.ql:25: Column 5 selects sink.getCredentialsHeader
    none()
  }
}

/**
 * Data flow for CORS misconfiguration for credentials transfer.
 */
module CorsMisconfigurationFlow = TaintTracking::Global<CorsMisconfigurationConfig>;

/**
 * DEPRECATED. Use the `CorsMisconfigurationFlow` module instead.
 */
deprecated class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "CorsMisconfigurationForCredentials" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  override predicate isSanitizer(DataFlow::Node node) {
    super.isSanitizer(node) or
    node instanceof Sanitizer
  }

  override predicate isSanitizerGuard(TaintTracking::SanitizerGuardNode guard) {
    guard instanceof TaintTracking::AdHocWhitelistCheckSanitizer
  }
}
