/**
 * @kind path-problem
 */

import python
import semmle.python.dataflow.new.DataFlow
import DataFlow::PathGraph

/**
 * A configuration to check routing of arguments through magic methods.
 */
class ArgumentRoutingConfig extends DataFlow::Configuration {
  ArgumentRoutingConfig() { this = "ArgumentRoutingConfig" }

  override predicate isSource(DataFlow::Node node) {
    node.(DataFlow::CfgNode).getNode().(NameNode).getId() = "arg7"
  }

  override predicate isSink(DataFlow::Node node) {
    exists(CallNode call |
      call.getFunction().(NameNode).getId() = "SINK7" and
      node.(DataFlow::CfgNode).getNode() = call.getAnArg()
    )
  }

  /**
   * We want to be able to use `arg` in a sequence of calls such as `func(kw=arg); ... ; func(arg)`.
   * Use-use flow lets the argument to the first call reach the sink inside the second call,
   * making it seem like we handle all cases even if we only handle the last one.
   * We make the test honest by preventing flow into source nodes.
   */
  override predicate isBarrierIn(DataFlow::Node node) { isSource(node) }
}

from DataFlow::PathNode source, DataFlow::PathNode sink
where
  source.getNode().getLocation().getFile().getBaseName() in ["classes.py", "argumentPassing.py"] and
  sink.getNode().getLocation().getFile().getBaseName() in ["classes.py", "argumentPassing.py"] and
  exists(ArgumentRoutingConfig cfg | cfg.hasFlowPath(source, sink))
select source.getNode(), source, sink, "Flow found"
