import semmle.python.dataflow.new.DataFlow

/**
 * A configuration to find all flows.
 * To be used on tiny programs.
 */
module AllFlowsConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { any() }

  predicate isSink(DataFlow::Node node) { any() }
}

module AllFlowsFlow = DataFlow::Global<AllFlowsConfig>;

from DataFlow::CfgNode source, DataFlow::CfgNode sink
where
  source != sink and
  AllFlowsFlow::flow(source, sink)
select source, sink
