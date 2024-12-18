import python
import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.internal.DataFlowPrivate as DataFlowPrivate
import utils.test.dataflow.RoutingTest

module Argument1RoutingTest implements RoutingTestSig {
  class Argument = Unit;

  string flowTag(Argument arg) { result = "arg1" and exists(arg) }

  predicate relevantFlow(DataFlow::Node source, DataFlow::Node sink, Argument arg) {
    (
      Argument1ExtraRoutingFlow::flow(source, sink)
      or
      ArgumentRoutingFlow::flow(source, sink) and
      ArgumentRoutingConfig::isArgSource(source, 1) and
      ArgumentRoutingConfig::isGoodSink(sink, 1)
    ) and
    exists(arg)
  }
}

class ArgNumber extends int {
  ArgNumber() { this in [1 .. 7] }
}

module ArgumentRoutingConfig implements DataFlow::ConfigSig {
  additional predicate isArgSource(DataFlow::Node node, ArgNumber argNumber) {
    node.(DataFlow::CfgNode).getNode().(NameNode).getId() = "arg" + argNumber
  }

  predicate isSource(DataFlow::Node node) { isArgSource(node, _) }

  additional predicate isGoodSink(DataFlow::Node node, ArgNumber argNumber) {
    exists(CallNode call |
      call.getFunction().(NameNode).getId() = "SINK" + argNumber and
      node.(DataFlow::CfgNode).getNode() = call.getAnArg()
    )
  }

  additional predicate isBadSink(DataFlow::Node node, ArgNumber argNumber) {
    exists(CallNode call |
      call.getFunction().(NameNode).getId() = "SINK" + argNumber + "_F" and
      node.(DataFlow::CfgNode).getNode() = call.getAnArg()
    )
  }

  predicate isSink(DataFlow::Node node) { isGoodSink(node, _) or isBadSink(node, _) }

  /**
   * We want to be able to use `arg` in a sequence of calls such as `func(kw=arg); ... ; func(arg)`.
   * Use-use flow lets the argument to the first call reach the sink inside the second call,
   * making it seem like we handle all cases even if we only handle the last one.
   * We make the test honest by preventing flow into source nodes.
   */
  predicate isBarrierIn(DataFlow::Node node) { isSource(node) }
}

module ArgumentRoutingFlow = DataFlow::Global<ArgumentRoutingConfig>;

module Argument1ExtraRoutingConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) {
    exists(AssignmentDefinition def, DataFlow::CallCfgNode call |
      def.getDefiningNode() = node.(DataFlow::CfgNode).getNode() and
      def.getValue() = call.getNode() and
      call.getFunction().asCfgNode().(NameNode).getId().matches("With\\_%")
    ) and
    node.(DataFlow::CfgNode).getNode().(NameNode).getId().matches("with\\_%")
  }

  predicate isSink(DataFlow::Node node) {
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
  predicate isBarrierIn(DataFlow::Node node) { isSource(node) }
}

module Argument1ExtraRoutingFlow = DataFlow::Global<Argument1ExtraRoutingConfig>;

module RestArgumentRoutingTest implements RoutingTestSig {
  class Argument = ArgNumber;

  string flowTag(Argument arg) { result = "arg" + arg }

  predicate relevantFlow(DataFlow::Node source, DataFlow::Node sink, Argument arg) {
    ArgumentRoutingFlow::flow(source, sink) and
    ArgumentRoutingConfig::isArgSource(source, arg) and
    ArgumentRoutingConfig::isGoodSink(sink, arg) and
    arg > 1
  }
}

/** Bad flow from `arg<n>` to `SINK<N>_F` */
module BadArgumentRoutingTestSinkF implements RoutingTestSig {
  class Argument = ArgNumber;

  string flowTag(Argument arg) { result = "bad" + arg }

  predicate relevantFlow(DataFlow::Node source, DataFlow::Node sink, Argument arg) {
    ArgumentRoutingFlow::flow(source, sink) and
    ArgumentRoutingConfig::isArgSource(source, arg) and
    ArgumentRoutingConfig::isBadSink(sink, arg)
  }
}

/** Bad flow from `arg<n>` to `SINK<M>` or `SINK<M>_F`, where `n != m`. */
module BadArgumentRoutingTestWrongSink implements RoutingTestSig {
  class Argument = ArgNumber;

  string flowTag(Argument arg) { result = "bad" + arg }

  predicate relevantFlow(DataFlow::Node source, DataFlow::Node sink, Argument arg) {
    ArgumentRoutingFlow::flow(source, sink) and
    ArgumentRoutingConfig::isArgSource(source, any(ArgNumber i | not i = arg)) and
    (
      ArgumentRoutingConfig::isGoodSink(sink, arg)
      or
      ArgumentRoutingConfig::isBadSink(sink, arg)
    )
  }
}

import MakeTest<MergeTests4<MakeTestSig<Argument1RoutingTest>, MakeTestSig<RestArgumentRoutingTest>,
  MakeTestSig<BadArgumentRoutingTestSinkF>, MakeTestSig<BadArgumentRoutingTestWrongSink>>>
