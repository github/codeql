/**
 * @name Forward Partial Dataflow
 * @description Forward Partial Dataflow
 * @kind path-problem
 * @precision low
 * @problem.severity error
 * @id actions/test-dataflow
 * @tags actions
 *       debug
 */

import actions
import codeql.actions.DataFlow
import codeql.actions.TaintTracking
import codeql.actions.dataflow.FlowSources
import PartialFlow::PartialPathGraph

private module MyConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source instanceof RemoteFlowSource and
    source.getLocation().getFile().getBaseName() = "non-existant-test.yml"
  }

  predicate isSink(DataFlow::Node sink) { none() }
}

private module MyFlow = TaintTracking::Global<MyConfig>; // or DataFlow::Global<..>

int explorationLimit() { result = 10 }

private module PartialFlow = MyFlow::FlowExplorationFwd<explorationLimit/0>;

from PartialFlow::PartialPathNode source, PartialFlow::PartialPathNode sink
where PartialFlow::partialFlow(source, sink, _)
select sink.getNode(), source, sink, "This node receives taint from $@.", source.getNode(),
  "this source"
