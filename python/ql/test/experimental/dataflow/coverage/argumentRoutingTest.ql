import python
import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.internal.DataFlowPrivate as DataFlowPrivate
import experimental.dataflow.TestUtil.RoutingTest

class Argument1RoutingTest extends RoutingTest {
  Argument1RoutingTest() { this = "Argument1RoutingTest" }

  override string flowTag() { result = "arg1" }

  override predicate relevantFlow(DataFlow::Node source, DataFlow::Node sink) {
    exists(Argument1ExtraRoutingConfig cfg | cfg.hasFlow(source, sink))
    or
    exists(ArgumentRoutingConfig cfg |
      cfg.hasFlow(source, sink) and
      cfg.isArgSource(source, 1) and
      cfg.isGoodSink(sink, 1)
    )
  }
}

class ArgNumber extends int {
  ArgNumber() { this in [1 .. 7] }
}

class ArgumentRoutingConfig extends DataFlow::Configuration {
  ArgumentRoutingConfig() { this = "ArgumentRoutingConfig" }

  predicate isArgSource(DataFlow::Node node, ArgNumber argNumber) {
    node.(DataFlow::CfgNode).getNode().(NameNode).getId() = "arg" + argNumber
  }

  override predicate isSource(DataFlow::Node node) { this.isArgSource(node, _) }

  predicate isGoodSink(DataFlow::Node node, ArgNumber argNumber) {
    exists(CallNode call |
      call.getFunction().(NameNode).getId() = "SINK" + argNumber and
      node.(DataFlow::CfgNode).getNode() = call.getAnArg()
    )
  }

  predicate isBadSink(DataFlow::Node node, ArgNumber argNumber) {
    exists(CallNode call |
      call.getFunction().(NameNode).getId() = "SINK" + argNumber + "_F" and
      node.(DataFlow::CfgNode).getNode() = call.getAnArg()
    )
  }

  override predicate isSink(DataFlow::Node node) {
    this.isGoodSink(node, _) or this.isBadSink(node, _)
  }

  /**
   * We want to be able to use `arg` in a sequence of calls such as `func(kw=arg); ... ; func(arg)`.
   * Use-use flow lets the argument to the first call reach the sink inside the second call,
   * making it seem like we handle all cases even if we only handle the last one.
   * We make the test honest by preventing flow into source nodes.
   */
  override predicate isBarrierIn(DataFlow::Node node) { this.isSource(node) }
}

class Argument1ExtraRoutingConfig extends DataFlow::Configuration {
  Argument1ExtraRoutingConfig() { this = "Argument1ExtraRoutingConfig" }

  override predicate isSource(DataFlow::Node node) {
    exists(AssignmentDefinition def, DataFlow::CallCfgNode call |
      def.getVariable() = node.(DataFlow::EssaNode).getVar() and
      def.getValue() = call.getNode() and
      call.getFunction().asCfgNode().(NameNode).getId().matches("With\\_%")
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

class RestArgumentRoutingTest extends RoutingTest {
  ArgNumber argNumber;

  RestArgumentRoutingTest() {
    argNumber > 1 and
    this = "Argument" + argNumber + "RoutingTest"
  }

  override string flowTag() { result = "arg" + argNumber }

  override predicate relevantFlow(DataFlow::Node source, DataFlow::Node sink) {
    exists(ArgumentRoutingConfig cfg |
      cfg.hasFlow(source, sink) and
      cfg.isArgSource(source, argNumber) and
      cfg.isGoodSink(sink, argNumber)
    )
  }
}

/** Bad flow from `arg<n>` to `SINK<N>_F` */
class BadArgumentRoutingTestSinkF extends RoutingTest {
  ArgNumber argNumber;

  BadArgumentRoutingTestSinkF() { this = "BadArgumentRoutingTestSinkF" + argNumber }

  override string flowTag() { result = "bad" + argNumber }

  override predicate relevantFlow(DataFlow::Node source, DataFlow::Node sink) {
    exists(ArgumentRoutingConfig cfg |
      cfg.hasFlow(source, sink) and
      cfg.isArgSource(source, argNumber) and
      cfg.isBadSink(sink, argNumber)
    )
  }
}

/** Bad flow from `arg<n>` to `SINK<M>` or `SINK<M>_F`, where `n != m`. */
class BadArgumentRoutingTestWrongSink extends RoutingTest {
  ArgNumber argNumber;

  BadArgumentRoutingTestWrongSink() { this = "BadArgumentRoutingTestWrongSink" + argNumber }

  override string flowTag() { result = "bad" + argNumber }

  override predicate relevantFlow(DataFlow::Node source, DataFlow::Node sink) {
    exists(ArgumentRoutingConfig cfg |
      cfg.hasFlow(source, sink) and
      cfg.isArgSource(source, any(ArgNumber i | not i = argNumber)) and
      (
        cfg.isGoodSink(sink, argNumber)
        or
        cfg.isBadSink(sink, argNumber)
      )
    )
  }
}
