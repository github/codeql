/**
 * Provides a taint-tracking configuration for detecting "tar slip" vulnerabilities.
 *
 * Note, for performance reasons: only import this file if
 * `TarSlip::Configuration` is needed, otherwise
 * `TarSlipCustomizations` should be imported instead.
 */

private import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import TarSlipCustomizations::TarSlip

private module TarSlipConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }
}

/** Global taint-tracking for detecting "tar slip" vulnerabilities. */
module TarSlipFlow = TaintTracking::Global<TarSlipConfig>;
