import python
import experimental.dataflow.DataFlow

/**
 * A configuration to check routing of arguments through magic methods.
 */
class ArgumentRoutingConfig extends DataFlow::Configuration {
  ArgumentRoutingConfig() { this = "ArgumentRoutingConfig" }

  override predicate isSource(DataFlow::Node node) {
    node.(DataFlow::CfgNode).getNode().(NameNode).getId() = "arg4"
  }

  override predicate isSink(DataFlow::Node node) {
    exists(CallNode call |
      call.getFunction().(NameNode).getId() = "SINK4" and
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
