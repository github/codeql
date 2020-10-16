/**
 * @kind path-problem
 */

import python
import experimental.dataflow.DataFlow
import DataFlow::PathGraph
private import experimental.dataflow.internal.DataFlowPrivate as DataFlowPrivate

/**
 * A configuration to check routing of arguments through magic methods.
 */
class ArgumentRoutingConfig extends DataFlow::Configuration {
  ArgumentRoutingConfig() { this = "ArgumentRoutingConfig" }

  override predicate isSource(DataFlow::Node node) {
    node.(DataFlow::CfgNode).getNode().(NameNode).getId() = "arg1"
    or
    exists(AssignmentDefinition def, DataFlowPrivate::DataFlowCall call |
      def.getVariable() = node.(DataFlow::EssaNode).getVar() and
      def.getValue() = call.getNode() and
      call.getNode().(CallNode).getFunction().(NameNode).getId().matches("With\\_%")
    ) and
    node.(DataFlow::EssaNode).getVar().getName().matches("with\\_%")
  }

  override predicate isSink(DataFlow::Node node) {
    exists(CallNode call |
      call.getFunction().(NameNode).getId() = "SINK1" and
      node.(DataFlow::CfgNode).getNode() = call.getAnArg()
    )
  }

  /**
   * This prevents the argument from one call to reach the sink
   * via a different call, by flowing to an argument of that.
   */
  override predicate isBarrierIn(DataFlow::Node node) { isSource(node) }
}

from DataFlow::PathNode source, DataFlow::PathNode sink
where
  source.getNode().getLocation().getFile().getBaseName() in ["classes.py", "argumentPassing.py"] and
  sink.getNode().getLocation().getFile().getBaseName() in ["classes.py", "argumentPassing.py"] and
  exists(ArgumentRoutingConfig cfg | cfg.hasFlowPath(source, sink))
select source.getNode(), source, sink, "Flow found"
