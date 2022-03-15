import python
import experimental.semmle.python.Concepts
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import semmle.python.dataflow.new.RemoteFlowSources

/**
 * A taint-tracking configuration for tracking untrusted user input used in file read.
 */
class CsvInjectionFlowConfig extends TaintTracking::Configuration {
  CsvInjectionFlowConfig() { this = "CsvInjectionFlowConfig" }

  override predicate isSource(DataFlow::Node source) {
    source instanceof RemoteFlowSource
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(CsvWriter csvwriter | sink = csvwriter.getAnInput())
  }
}
