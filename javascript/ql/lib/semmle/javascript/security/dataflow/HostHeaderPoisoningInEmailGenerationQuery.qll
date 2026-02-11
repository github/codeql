/**
 * Provides a taint tracking configuration for reasoning about host header
 * poisoning in email generation.
 */

import javascript

/**
 * A taint tracking configuration for host header poisoning.
 */
module HostHeaderPoisoningConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) {
    exists(Http::RequestHeaderAccess input | node = input |
      input.getKind() = "header" and
      input.getAHeaderName() = "host"
    )
  }

  predicate isSink(DataFlow::Node node) { exists(EmailSender email | node = email.getABody()) }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/**
 * Taint tracking configuration host header poisoning.
 */
module HostHeaderPoisoningFlow = TaintTracking::Global<HostHeaderPoisoningConfig>;

/**
 * DEPRECATED. Use the `HostHeaderPoisoningFlow` module instead.
 */
deprecated class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "TaintedHostHeader" }

  override predicate isSource(DataFlow::Node node) { HostHeaderPoisoningConfig::isSource(node) }

  override predicate isSink(DataFlow::Node node) { HostHeaderPoisoningConfig::isSink(node) }
}
