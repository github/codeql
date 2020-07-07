import python
import semmle.python.dataflow.TaintTracking

class SimpleTest extends TaintKind {
  SimpleTest() { this = "simple.test" }
}

abstract class TestConfig extends TaintTracking::Configuration {
  bindingset[this]
  TestConfig() { any() }
}

class SimpleConfig extends TestConfig {
  SimpleConfig() { this = "Simple config" }

  override predicate isSource(DataFlow::Node node, TaintKind kind) {
    node.asCfgNode().(NameNode).getId() = "SOURCE" and
    kind instanceof SimpleTest
  }

  override predicate isSink(DataFlow::Node node, TaintKind kind) {
    exists(CallNode call |
      call.getFunction().(NameNode).getId() = "SINK" and
      node.asCfgNode() = call.getAnArg()
    ) and
    kind instanceof SimpleTest
  }

  override predicate isBarrier(DataFlow::Node node, TaintKind kind) {
    node.asCfgNode().(CallNode).getFunction().(NameNode).getId() = "SANITIZE" and
    kind instanceof SimpleTest
  }
}

class BasicCustomTaint extends TaintKind {
  BasicCustomTaint() { this = "basic.custom" }

  override TaintKind getTaintForFlowStep(ControlFlowNode fromnode, ControlFlowNode tonode) {
    tonode.(CallNode).getAnArg() = fromnode and
    tonode.(CallNode).getFunction().(NameNode).getId() = "TAINT_FROM_ARG" and
    result = this
  }
}

class BasicCustomConfig extends TestConfig {
  BasicCustomConfig() { this = "Basic custom config" }

  override predicate isSource(DataFlow::Node node, TaintKind kind) {
    node.asCfgNode().(NameNode).getId() = "CUSTOM_SOURCE" and
    kind instanceof SimpleTest
  }

  override predicate isSink(DataFlow::Node node, TaintKind kind) {
    exists(CallNode call |
      call.getFunction().(NameNode).getId() = "CUSTOM_SINK" and
      node.asCfgNode() = call.getAnArg()
    ) and
    kind instanceof SimpleTest
  }
}

class Rock extends TaintKind {
  Rock() { this = "rock" }

  override TaintKind getTaintOfMethodResult(string name) {
    name = "prev" and result instanceof Scissors
  }
}

class Paper extends TaintKind {
  Paper() { this = "paper" }

  override TaintKind getTaintOfMethodResult(string name) {
    name = "prev" and result instanceof Rock
  }
}

class Scissors extends TaintKind {
  Scissors() { this = "scissors" }

  override TaintKind getTaintOfMethodResult(string name) {
    name = "prev" and result instanceof Paper
  }
}

class RockPaperScissorConfig extends TestConfig {
  RockPaperScissorConfig() { this = "Rock-paper-scissors config" }

  override predicate isSource(DataFlow::Node node, TaintKind kind) {
    exists(string name |
      node.asCfgNode().(NameNode).getId() = name and
      kind = name.toLowerCase()
    |
      name = "ROCK" or name = "PAPER" or name = "SCISSORS"
    )
  }

  override predicate isSink(DataFlow::Node node, TaintKind kind) {
    exists(string name | function_param(name, node) |
      name = "paper" and kind = "rock"
      or
      name = "rock" and kind = "scissors"
      or
      name = "scissors" and kind = "paper"
    )
  }
}

private predicate function_param(string funcname, DataFlow::Node arg) {
  exists(FunctionObject f |
    f.getName() = funcname and
    arg.asCfgNode() = f.getArgumentForCall(_, _)
  )
}

class TaintCarrier extends TaintKind {
  TaintCarrier() { this = "explicit.carrier" }

  override TaintKind getTaintOfMethodResult(string name) {
    name = "get_taint" and result instanceof SimpleTest
  }
}

class TaintCarrierConfig extends TestConfig {
  TaintCarrierConfig() { this = "Taint carrier config" }

  override predicate isSource(DataFlow::Node node, TaintKind kind) {
    node.asCfgNode().(NameNode).getId() = "TAINT_CARRIER_SOURCE" and
    kind instanceof TaintCarrier
  }

  override predicate isSink(DataFlow::Node node, TaintKind kind) {
    exists(CallNode call |
      call.getFunction().(NameNode).getId() = "SINK" and
      node.asCfgNode() = call.getAnArg()
    ) and
    kind instanceof SimpleTest
  }

  override predicate isBarrier(DataFlow::Node node, TaintKind kind) {
    node.asCfgNode().(CallNode).getFunction().(NameNode).getId() = "SANITIZE" and
    kind instanceof SimpleTest
  }
}

/* Some more realistic examples */
abstract class UserInput extends TaintKind {
  bindingset[this]
  UserInput() { any() }
}

class UserInputSource extends TaintSource {
  UserInputSource() { this.(CallNode).getFunction().(NameNode).getId() = "user_input" }

  override predicate isSourceOf(TaintKind kind) { kind instanceof UserInput }

  override string toString() { result = "user.input.source" }
}

class SqlInjectionTaint extends UserInput {
  SqlInjectionTaint() { this = "SQL injection" }
}

class CommandInjectionTaint extends UserInput {
  CommandInjectionTaint() { this = "Command injection" }
}

class SqlSanitizer extends Sanitizer {
  SqlSanitizer() { this = "SQL sanitizer" }

  /** Holds if `test` shows value to be untainted with `taint` */
  override predicate sanitizingEdge(TaintKind taint, PyEdgeRefinement test) {
    exists(FunctionObject f, CallNode call |
      f.getName() = "isEscapedSql" and
      test.getTest() = call and
      call.getAnArg() = test.getSourceVariable().getAUse() and
      f.getACall() = call and
      test.getSense() = true
    ) and
    taint instanceof SqlInjectionTaint
  }
}

class CommandSanitizer extends Sanitizer {
  CommandSanitizer() { this = "Command sanitizer" }

  /** Holds if `test` shows value to be untainted with `taint` */
  override predicate sanitizingEdge(TaintKind taint, PyEdgeRefinement test) {
    exists(FunctionObject f |
      f.getName() = "isValidCommand" and
      f.getACall().(CallNode).getAnArg() = test.getSourceVariable().getAUse() and
      test.getSense() = true
    ) and
    taint instanceof CommandInjectionTaint
  }
}

class SqlQuery extends TaintSink {
  SqlQuery() {
    exists(CallNode call |
      call.getFunction().(NameNode).getId() = "sql_query" and
      call.getAnArg() = this
    )
  }

  override string toString() { result = "SQL query" }

  override predicate sinks(TaintKind taint) { taint instanceof SqlInjectionTaint }
}

class OsCommand extends TaintSink {
  OsCommand() {
    exists(CallNode call |
      call.getFunction().(NameNode).getId() = "os_command" and
      call.getAnArg() = this
    )
  }

  override string toString() { result = "OS command" }

  override predicate sinks(TaintKind taint) { taint instanceof CommandInjectionTaint }
}

class Falsey extends TaintKind {
  Falsey() { this = "falsey" }

  override boolean booleanValue() { result = false }
}

class FalseySource extends TaintSource {
  FalseySource() { this.(NameNode).getId() = "FALSEY" }

  override predicate isSourceOf(TaintKind kind) { kind instanceof Falsey }

  override string toString() { result = "falsey.source" }
}

class TaintIterable extends TaintKind {
  TaintIterable() { this = "iterable.simple" }

  override TaintKind getTaintForIteration() { result instanceof SimpleTest }
}

class TaintIterableSource extends TaintSource {
  TaintIterableSource() { this.(NameNode).getId() = "ITERABLE_SOURCE" }

  override predicate isSourceOf(TaintKind kind) { kind instanceof TaintIterable }
}
