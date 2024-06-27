private import python
import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.internal.DataFlowPrivate as DataFlowPrivate

/**
 * A configuration to find the call graph edges.
 */
module CallGraphConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) {
    node instanceof DataFlowPrivate::ReturnNode
    or
    node instanceof DataFlow::ArgumentNode
  }

  predicate isSink(DataFlow::Node node) {
    node instanceof DataFlowPrivate::OutNode
    or
    node instanceof DataFlow::ParameterNode
  }
}

module CallGraphFlow = DataFlow::Global<CallGraphConfig>;
