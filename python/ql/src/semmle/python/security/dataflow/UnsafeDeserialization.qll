/**
 * Provides a taint-tracking configuration for detecting arbitrary code execution
 * vulnerabilities due to deserializing user-controlled data.
 */

import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import semmle.python.Concepts
import semmle.python.dataflow.new.RemoteFlowSources

/**
 * A taint-tracking configuration for detecting arbitrary code execution
 * vulnerabilities due to deserializing user-controlled data.
 */
class UnsafeDeserializationConfiguration extends TaintTracking::Configuration {
  UnsafeDeserializationConfiguration() { this = "UnsafeDeserializationConfiguration" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    exists(Decoding d |
      d.mayExecuteInput() and
      sink = d.getAnInput()
    )
  }
}
