import python
import semmle.python.dataflow.TaintTracking

class SimpleTest extends TaintKind {
  SimpleTest() { this = "simple.test" }
}

class SimpleSink extends TaintSink {
  override string toString() { result = "Simple sink" }

  SimpleSink() {
    exists(CallNode call |
      call.getFunction().(NameNode).getId() = "SINK" and
      this = call.getAnArg()
    )
  }

  override predicate sinks(TaintKind taint) { taint instanceof SimpleTest }
}

class SimpleSource extends TaintSource {
  SimpleSource() { this.(NameNode).getId() = "SOURCE" }

  override predicate isSourceOf(TaintKind kind) { kind instanceof SimpleTest }

  override string toString() { result = "simple.source" }
}

class SimpleSanitizer extends Sanitizer {
  SimpleSanitizer() { this = "Simple sanitizer" }

  override predicate sanitizingNode(TaintKind taint, ControlFlowNode node) {
    node.(CallNode).getFunction().(NameNode).getId() = "SANITIZE" and
    taint instanceof SimpleTest
  }

  override predicate sanitizingDefinition(TaintKind taint, EssaDefinition def) {
    exists(CallNode call |
      def.(ArgumentRefinement).getInput().getAUse() = call.getAnArg() and
      call.getFunction().(NameNode).getId() = "SANITIZE"
    ) and
    taint instanceof SimpleTest
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

class BasicCustomSink extends TaintSink {
  override string toString() { result = "Basic custom sink" }

  BasicCustomSink() {
    exists(CallNode call |
      call.getFunction().(NameNode).getId() = "CUSTOM_SINK" and
      this = call.getAnArg()
    )
  }

  override predicate sinks(TaintKind taint) { taint instanceof BasicCustomTaint }
}

class BasicCustomSource extends TaintSource {
  BasicCustomSource() { this.(NameNode).getId() = "CUSTOM_SOURCE" }

  override predicate isSourceOf(TaintKind kind) { kind instanceof BasicCustomTaint }

  override string toString() { result = "basic.custom.source" }
}

class Rock extends TaintKind {
  Rock() { this = "rock" }

  override TaintKind getTaintOfMethodResult(string name) {
    name = "prev" and result instanceof Scissors
  }

  predicate isSink(ControlFlowNode sink) {
    exists(CallNode call |
      call.getArg(0) = sink and
      call.getFunction().(NameNode).getId() = "paper"
    )
  }
}

class Paper extends TaintKind {
  Paper() { this = "paper" }

  override TaintKind getTaintOfMethodResult(string name) {
    name = "prev" and result instanceof Rock
  }

  predicate isSink(ControlFlowNode sink) {
    exists(CallNode call |
      call.getArg(0) = sink and
      call.getFunction().(NameNode).getId() = "scissors"
    )
  }
}

class Scissors extends TaintKind {
  Scissors() { this = "scissors" }

  override TaintKind getTaintOfMethodResult(string name) {
    name = "prev" and result instanceof Paper
  }

  predicate isSink(ControlFlowNode sink) {
    exists(CallNode call |
      call.getArg(0) = sink and
      call.getFunction().(NameNode).getId() = "rock"
    )
  }
}

class RockPaperScissorSource extends TaintSource {
  RockPaperScissorSource() {
    exists(string name | this.(NameNode).getId() = name |
      name = "ROCK" or name = "PAPER" or name = "SCISSORS"
    )
  }

  override predicate isSourceOf(TaintKind kind) { kind = this.(NameNode).getId().toLowerCase() }

  override string toString() { result = "rock.paper.scissors.source" }
}

private predicate function_param(string funcname, ControlFlowNode arg) {
  exists(FunctionObject f |
    f.getName() = funcname and
    arg = f.getArgumentForCall(_, _)
  )
}

class RockPaperScissorSink extends TaintSink {
  RockPaperScissorSink() {
    exists(string name | function_param(name, this) |
      name = "rock" or name = "paper" or name = "scissors"
    )
  }

  override predicate sinks(TaintKind taint) {
    exists(string name | function_param(name, this) |
      name = "paper" and taint = "rock"
      or
      name = "rock" and taint = "scissors"
      or
      name = "scissors" and taint = "paper"
    )
  }

  override string toString() { result = "rock.paper.scissors.sink" }
}

class TaintCarrier extends TaintKind {
  TaintCarrier() { this = "explicit.carrier" }

  override TaintKind getTaintOfMethodResult(string name) {
    name = "get_taint" and result instanceof SimpleTest
  }
}

/* There is no sink for `TaintCarrier`. It is not "dangerous" in itself; it merely holds a `SimpleTest`. */
class TaintCarrierSource extends TaintSource {
  TaintCarrierSource() { this.(NameNode).getId() = "TAINT_CARRIER_SOURCE" }

  override predicate isSourceOf(TaintKind kind) { kind instanceof TaintCarrier }

  override string toString() { result = "taint.carrier.source" }
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
