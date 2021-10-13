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
class Configuration extends TaintTracking::Configuration {
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
