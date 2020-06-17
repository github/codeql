import python
import experimental.dataflow.DataFlow

class SimpleConfig extends DataFlow::Configuration {
  SimpleConfig() { this = "SimpleConfig" }

  // TODO: make a test out of this
  override predicate isSource(DataFlow::Node node) {
    node.asEssaNode() instanceof EssaNodeDefinition
  }

  // TODO: make a test out of this
  override predicate isSink(DataFlow::Node node) {
    not exists(EssaDefinition succ |
      node.asEssaNode().getDefinition() = pred(succ)
    )
  }

  EssaDefinition pred(EssaDefinition n) {
    // result = value(n.(EssaNodeDefinition))
    // or
    result = n.(EssaNodeRefinement).getInput()
    or
    result = n.(EssaEdgeRefinement).getInput()
    or
    result = n.(PhiFunction).getShortCircuitInput()
  }
}

from
  DataFlow::Node source,
  DataFlow::Node sink
where
exists(SimpleConfig cfg | cfg.hasFlow(source, sink))
select
source, sink
