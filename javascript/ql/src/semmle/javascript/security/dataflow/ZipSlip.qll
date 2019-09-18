/**
 * Provides a taint tracking configuration for reasoning about unsafe
 * zip and tar archive extraction.
 *
 * Note, for performance reasons: only import this file if
 * `ZipSlip::Configuration` is needed, otherwise
 * `ZipSlipCustomizations` should be imported instead.
 */

import javascript

module ZipSlip {
  import ZipSlipCustomizations::ZipSlip

  /** A taint tracking configuration for unsafe archive extraction. */
  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "ZipSlip" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    override predicate isSanitizer(DataFlow::Node sanitizer) { sanitizer instanceof Sanitizer }

    override predicate isSanitizerGuard(TaintTracking::SanitizerGuardNode nd) {
      nd instanceof SanitizerGuard
    }
  }
}
