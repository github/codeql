import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.internal.DataFlowPrivate as DataFlowPrivate

/**
 * A configuration to find all "maximal" flows.
 * To be used on small programs.
 */
module MaximalFlowsConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) {
    node instanceof DataFlow::ParameterNode
    or
    node instanceof DataFlow::EssaNode and
    not exists(DataFlow::EssaNode pred | DataFlow::localFlowStep(pred, node))
  }

  predicate isSink(DataFlow::Node node) {
    node instanceof DataFlowPrivate::ReturnNode
    or
    node instanceof DataFlow::EssaNode and
    not exists(node.(DataFlow::EssaNode).getVar().getASourceUse())
  }
}

module MaximalFlowsFlow = DataFlow::Global<MaximalFlowsConfig>;
