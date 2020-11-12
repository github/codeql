import python
import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.internal.DataFlowPrivate as DataFlowPrivate
import experimental.dataflow.FlowTestUtil.FlowTest

class Argument1RoutingTest extends FlowTest {
  Argument1RoutingTest() { this = "Argument1RoutingTest" }

  override string flowTag() { result = "arg1" }

  override predicate relevantFlow(DataFlow::Node source, DataFlow::Node sink) {
    exists(Argument1RoutingConfig cfg | cfg.hasFlow(source, sink))
  }
}

/**
 * A configuration to check routing of arguments through magic methods.
 */
class Argument1RoutingConfig extends DataFlow::Configuration {
  Argument1RoutingConfig() { this = "Argument1RoutingConfig" }

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
   * We want to be able to use `arg` in a sequence of calls such as `func(kw=arg); ... ; func(arg)`.
   * Use-use flow lets the argument to the first call reach the sink inside the second call,
   * making it seem like we handle all cases even if we only handle the last one.
   * We make the test honest by preventing flow into source nodes.
   */
  override predicate isBarrierIn(DataFlow::Node node) { isSource(node) }
}

class Argument2RoutingTest extends FlowTest {
  Argument2RoutingTest() { this = "Argument2RoutingTest" }

  override string flowTag() { result = "arg2" }

  override predicate relevantFlow(DataFlow::Node source, DataFlow::Node sink) {
    exists(Argument2RoutingConfig cfg | cfg.hasFlow(source, sink))
  }
}

/**
 * A configuration to check routing of arguments through magic methods.
 */
class Argument2RoutingConfig extends DataFlow::Configuration {
  Argument2RoutingConfig() { this = "Argument2RoutingConfig" }

  override predicate isSource(DataFlow::Node node) {
    node.(DataFlow::CfgNode).getNode().(NameNode).getId() = "arg2"
  }

  override predicate isSink(DataFlow::Node node) {
    exists(CallNode call |
      call.getFunction().(NameNode).getId() = "SINK2" and
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
