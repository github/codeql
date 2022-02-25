import semmle.python.dataflow.new.DataFlow

/**
 * A configuration to find all flows.
 * To be used on tiny programs.
 */
class AllFlowsConfig extends DataFlow::Configuration {
  AllFlowsConfig() { this = "AllFlowsConfig" }

  override predicate isSource(DataFlow::Node node) { any() }

  override predicate isSink(DataFlow::Node node) { any() }
}

from DataFlow::CfgNode source, DataFlow::CfgNode sink
where
  source != sink and
  exists(AllFlowsConfig cfg | cfg.hasFlow(source, sink))
select source, sink
