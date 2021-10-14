/**
 * Provides a taint tracking configuration for reasoning about zip-slip vulnerabilities.
 *
 * Note: for performance reasons, only import this file if `ZipSlip::Configuration` is needed,
 * otherwise `ZipSlipCustomizations` should be imported instead.
 */

import go

/** Provides a taint tracking configuration for reasoning about zip-slip vulnerabilities. */
module ZipSlip {
  import ZipSlipCustomizations::ZipSlip

  /**
   * A taint-tracking configuration for reasoning about zip-slip vulnerabilities.
   */
  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "ZipSlip" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    override predicate isSanitizer(DataFlow::Node node) {
      super.isSanitizer(node) or
      node instanceof Sanitizer
    }

    override predicate isSanitizerGuard(DataFlow::BarrierGuard guard) {
      guard instanceof SanitizerGuard
    }
  }
}
