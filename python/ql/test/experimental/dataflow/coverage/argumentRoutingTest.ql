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
  override predicate isBarrierIn(DataFlow::Node node) { isSource(node) }
}

class Argument2RoutingTest extends RoutingTest {
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

class Argument3RoutingTest extends RoutingTest {
  Argument3RoutingTest() { this = "Argument3RoutingTest" }

  override string flowTag() { result = "arg3" }

  override predicate relevantFlow(DataFlow::Node source, DataFlow::Node sink) {
    exists(Argument3RoutingConfig cfg | cfg.hasFlow(source, sink))
  }
}

/**
 * A configuration to check routing of arguments through magic methods.
 */
class Argument3RoutingConfig extends DataFlow::Configuration {
  Argument3RoutingConfig() { this = "Argument3RoutingConfig" }

  override predicate isSource(DataFlow::Node node) {
    node.(DataFlow::CfgNode).getNode().(NameNode).getId() = "arg3"
  }

  override predicate isSink(DataFlow::Node node) {
    exists(CallNode call |
      call.getFunction().(NameNode).getId() = "SINK3" and
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

class Argument4RoutingTest extends RoutingTest {
  Argument4RoutingTest() { this = "Argument4RoutingTest" }

  override string flowTag() { result = "arg4" }

  override predicate relevantFlow(DataFlow::Node source, DataFlow::Node sink) {
    exists(Argument4RoutingConfig cfg | cfg.hasFlow(source, sink))
  }
}

/**
 * A configuration to check routing of arguments through magic methods.
 */
class Argument4RoutingConfig extends DataFlow::Configuration {
  Argument4RoutingConfig() { this = "Argument4RoutingConfig" }

  override predicate isSource(DataFlow::Node node) {
    node.(DataFlow::CfgNode).getNode().(NameNode).getId() = "arg4"
  }

  override predicate isSink(DataFlow::Node node) {
    exists(CallNode call |
      call.getFunction().(NameNode).getId() = "SINK4" and
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

class Argument5RoutingTest extends RoutingTest {
  Argument5RoutingTest() { this = "Argument5RoutingTest" }

  override string flowTag() { result = "arg5" }

  override predicate relevantFlow(DataFlow::Node source, DataFlow::Node sink) {
    exists(Argument5RoutingConfig cfg | cfg.hasFlow(source, sink))
  }
}

/**
 * A configuration to check routing of arguments through magic methods.
 */
class Argument5RoutingConfig extends DataFlow::Configuration {
  Argument5RoutingConfig() { this = "Argument5RoutingConfig" }

  override predicate isSource(DataFlow::Node node) {
    node.(DataFlow::CfgNode).getNode().(NameNode).getId() = "arg5"
  }

  override predicate isSink(DataFlow::Node node) {
    exists(CallNode call |
      call.getFunction().(NameNode).getId() = "SINK5" and
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

class Argument6RoutingTest extends RoutingTest {
  Argument6RoutingTest() { this = "Argument6RoutingTest" }

  override string flowTag() { result = "arg6" }

  override predicate relevantFlow(DataFlow::Node source, DataFlow::Node sink) {
    exists(Argument6RoutingConfig cfg | cfg.hasFlow(source, sink))
  }
}

/**
 * A configuration to check routing of arguments through magic methods.
 */
class Argument6RoutingConfig extends DataFlow::Configuration {
  Argument6RoutingConfig() { this = "Argument6RoutingConfig" }

  override predicate isSource(DataFlow::Node node) {
    node.(DataFlow::CfgNode).getNode().(NameNode).getId() = "arg6"
  }

  override predicate isSink(DataFlow::Node node) {
    exists(CallNode call |
      call.getFunction().(NameNode).getId() = "SINK6" and
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

class Argument7RoutingTest extends RoutingTest {
  Argument7RoutingTest() { this = "Argument7RoutingTest" }

  override string flowTag() { result = "arg7" }

  override predicate relevantFlow(DataFlow::Node source, DataFlow::Node sink) {
    exists(Argument7RoutingConfig cfg | cfg.hasFlow(source, sink))
  }
}

/**
 * A configuration to check routing of arguments through magic methods.
 */
class Argument7RoutingConfig extends DataFlow::Configuration {
  Argument7RoutingConfig() { this = "Argument7RoutingConfig" }

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
