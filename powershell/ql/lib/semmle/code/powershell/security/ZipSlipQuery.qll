/**
 * Provides a taint tracking configuration for reasoning about
 * zip slip (CWE-022).
 *
 * Note, for performance reasons: only import this file if
 * `ZipSlipFlow` is needed, otherwise
 * `ZipSlipCustomizations` should be imported instead.
 */

import powershell
import semmle.code.powershell.dataflow.flowsources.FlowSources
import semmle.code.powershell.dataflow.DataFlow
import semmle.code.powershell.dataflow.TaintTracking
import ZipSlipCustomizations::ZipSlip

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }
}

module ZipSlipFlow = TaintTracking::Global<Config>;
