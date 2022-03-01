import python
import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.internal.DataFlowPrivate as DataFlowPrivate
import experimental.dataflow.TestUtil.RoutingTest

class Argument1RoutingTest extends RoutingTest {
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
  override predicate isBarrierIn(DataFlow::Node node) { this.isSource(node) }
}

// for argument 2 and up, we use a generic approach. Change `maxNumArgs` below if we
// need to increase the maximum number of arguments.
private int maxNumArgs() { result = 7 }

class RestArgumentRoutingTest extends RoutingTest {
  int argNumber;

  RestArgumentRoutingTest() {
    argNumber in [2 .. maxNumArgs()] and
    this = "Argument" + argNumber + "RoutingTest"
  }

  override string flowTag() { result = "arg" + argNumber }

  override predicate relevantFlow(DataFlow::Node source, DataFlow::Node sink) {
    exists(RestArgumentRoutingConfig cfg | cfg.getArgNumber() = argNumber |
      cfg.hasFlow(source, sink)
    )
  }
}

/**
 * A configuration to check routing of arguments through magic methods.
 */
class RestArgumentRoutingConfig extends DataFlow::Configuration {
  int argNumber;

  RestArgumentRoutingConfig() {
    argNumber in [2 .. maxNumArgs()] and
    this = "Argument" + argNumber + "RoutingConfig"
  }

  /** Gets the argument number this configuration is for. */
  int getArgNumber() { result = argNumber }

  override predicate isSource(DataFlow::Node node) {
    node.(DataFlow::CfgNode).getNode().(NameNode).getId() = "arg" + argNumber
  }

  override predicate isSink(DataFlow::Node node) {
    exists(CallNode call |
      call.getFunction().(NameNode).getId() = "SINK" + argNumber and
      node.(DataFlow::CfgNode).getNode() = call.getAnArg()
    )
  }

  /**
   * We want to be able to use `arg` in a sequence of calls such as `func(kw=arg); ... ; func(arg)`.
   * Use-use flow lets the argument to the first call reach the sink inside the second call,
   * making it seem like we handle all cases even if we only handle the last one.
   * We make the test honest by preventing flow into source nodes.
   */
  override predicate isBarrierIn(DataFlow::Node node) { this.isSource(node) }
}
