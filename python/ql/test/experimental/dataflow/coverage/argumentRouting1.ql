import python
import experimental.dataflow.DataFlow
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
}

from DataFlow::Node source, DataFlow::Node sink
where
  source.getLocation().getFile().getBaseName() in ["classes.py", "argumentPassing.py"] and
  sink.getLocation().getFile().getBaseName() in ["classes.py", "argumentPassing.py"] and
  exists(ArgumentRoutingConfig cfg | cfg.hasFlow(source, sink))
select source, sink
