/**
 * Provides a taint-tracking configuration for detecting pollution
 * vulnerabilities.
 *
 * Note, for performance reasons: only import this file if
 * `AttributePollution::Configuration` is needed, otherwise
 * `AttributePollution` should be imported instead.
 */

private import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import PollutionCustomizations::AttributePollution

/**
 * A taint-tracking configuration for detecting "pollution" vulnerabilities.
 */
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "AttributePollution" }

  override predicate isSource(DataFlow::Node source, DataFlow::FlowState state) {
    source instanceof Source and state instanceof BeforeForIn
  }

  override predicate isSink(DataFlow::Node sink, DataFlow::FlowState state) {
    sink instanceof Sink and state instanceof AfterForIn
  }

  override predicate isAdditionalTaintStep(
    DataFlow::Node nodeFrom, DataFlow::FlowState stateFrom, DataFlow::Node nodeTo,
    DataFlow::FlowState stateTo
  ) {
    // change node state to satisfy sink
    enumeratedAttributeNameStep(nodeFrom, stateFrom, nodeTo, stateTo)
  }
}
