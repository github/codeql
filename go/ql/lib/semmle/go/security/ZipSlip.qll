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

  private module Config implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) { source instanceof Source }

    predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }
  }

  /** Tracks taint flow for reasoning about zip-slip vulnerabilities. */
  module Flow = TaintTracking::Global<Config>;
}
