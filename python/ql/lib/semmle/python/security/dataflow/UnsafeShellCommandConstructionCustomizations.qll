/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * shell command constructed from library input vulnerabilities, as
 * well as extension points for adding your own.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.TaintTracking
private import CommandInjectionCustomizations::CommandInjection as CommandInjection
private import semmle.python.Concepts as Concepts
private import semmle.python.ApiGraphs

/**
 * Module containing sources, sinks, and sanitizers for shell command constructed from library input.
 */
module UnsafeShellCommandConstruction {
  /** A source for shell command constructed from library input vulnerabilities. */
  abstract class Source extends DataFlow::Node { }

  /** A sanitizer for shell command constructed from library input vulnerabilities. */
  abstract class Sanitizer extends DataFlow::Node { }

  private import semmle.python.frameworks.Setuptools

  /** An input parameter to a gem seen as a source. */
  private class LibraryInputAsSource extends Source instanceof DataFlow::ParameterNode {
    LibraryInputAsSource() {
      this = Setuptools::getALibraryInput() and
      not this.getParameter().getName().matches(["cmd%", "command%", "%_command", "%_cmd"])
    }
  }

  /** A sink for shell command constructed from library input vulnerabilities. */
  abstract class Sink extends DataFlow::Node {
    Sink() { not this.asExpr() instanceof StringLiteral } // filter out string constants, makes testing easier

    /** Gets a description of how the string in this sink was constructed. */
    abstract string describe();

    /** Gets the dataflow node where the string is constructed. */
    DataFlow::Node getStringConstruction() { result = this }

    /** Gets the dataflow node that executed the string as a shell command. */
    abstract DataFlow::Node getCommandExecution();
  }

  /** Holds if the string constructed at `source` is executed at `shellExec` */
  predicate isUsedAsShellCommand(DataFlow::Node source, Concepts::SystemCommandExecution shellExec) {
    source = backtrackShellExec(TypeTracker::TypeBackTracker::end(), shellExec)
  }

  import semmle.python.dataflow.new.TypeTracking as TypeTracker

  private DataFlow::LocalSourceNode backtrackShellExec(
    TypeTracker::TypeBackTracker t, Concepts::SystemCommandExecution shellExec
  ) {
    t.start() and
    result = any(DataFlow::Node n | shellExec.isShellInterpreted(n)).getALocalSource()
    or
    exists(TypeTracker::TypeBackTracker t2 |
      result = backtrackShellExec(t2, shellExec).backtrack(t2, t)
    )
  }

  /**
   * A string constructed from a string-literal (e.g. `f'foo {sink}'`),
   * where the resulting string ends up being executed as a shell command.
   */
  class StringInterpolationAsSink extends Sink {
    Concepts::SystemCommandExecution s;
    Fstring fstring;

    StringInterpolationAsSink() {
      isUsedAsShellCommand(DataFlow::exprNode(fstring), s) and
      this.asExpr() = fstring.getASubExpression()
    }

    override string describe() { result = "f-string" }

    override DataFlow::Node getCommandExecution() { result = s }

    override DataFlow::Node getStringConstruction() { result.asExpr() = fstring }
  }

  /**
   * A component of a string-concatenation (e.g. `"foo " + sink`),
   * where the resulting string ends up being executed as a shell command.
   */
  class StringConcatAsSink extends Sink {
    Concepts::SystemCommandExecution s;
    BinaryExpr add;

    StringConcatAsSink() {
      add.getOp() instanceof Add and
      isUsedAsShellCommand(any(DataFlow::Node n | n.asExpr() = add), s) and
      this.asExpr() = add.getASubExpression()
    }

    override DataFlow::Node getCommandExecution() { result = s }

    override string describe() { result = "string concatenation" }

    override DataFlow::Node getStringConstruction() { result.asExpr() = add }
  }

  /**
   * A string constructed using a `" ".join(...)` call, where the resulting string ends up being executed as a shell command.
   */
  class ArrayJoin extends Sink {
    Concepts::SystemCommandExecution s;
    DataFlow::MethodCallNode call;

    ArrayJoin() {
      call.getMethodName() = "join" and
      unique( | | call.getArg(_)).asExpr().(StringLiteral).getText() = " " and
      isUsedAsShellCommand(call, s) and
      (
        this = call.getArg(0) and
        not call.getArg(0).asExpr() instanceof List
        or
        this.asExpr() = call.getArg(0).asExpr().(List).getASubExpression()
      )
    }

    override string describe() { result = "array" }

    override DataFlow::Node getCommandExecution() { result = s }

    override DataFlow::Node getStringConstruction() { result = call }
  }

  /**
   * A string constructed from a format call,
   * where the resulting string ends up being executed as a shell command.
   * Either a call to `.format(..)` or a string-interpolation with a `%` operator.
   */
  class TaintedFormatStringAsSink extends Sink {
    Concepts::SystemCommandExecution s;
    DataFlow::Node formatCall;

    TaintedFormatStringAsSink() {
      (
        formatCall.asExpr().(BinaryExpr).getOp() instanceof Mod and
        this.asExpr() = formatCall.asExpr().(BinaryExpr).getASubExpression()
        or
        formatCall.(DataFlow::MethodCallNode).getMethodName() = "format" and
        this =
          [
            formatCall.(DataFlow::MethodCallNode).getArg(_),
            formatCall.(DataFlow::MethodCallNode).getObject()
          ]
      ) and
      isUsedAsShellCommand(formatCall, s)
    }

    override string describe() { result = "formatted string" }

    override DataFlow::Node getCommandExecution() { result = s }

    override DataFlow::Node getStringConstruction() { result = formatCall }
  }

  /**
   * A call to `shlex.quote`, considered as a sanitizer.
   */
  class ShlexQuoteAsSanitizer extends Sanitizer, DataFlow::Node {
    ShlexQuoteAsSanitizer() {
      this = API::moduleImport("shlex").getMember("quote").getACall().getArg(0)
    }
  }
}
