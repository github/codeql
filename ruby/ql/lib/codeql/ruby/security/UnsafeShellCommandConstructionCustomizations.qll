/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * shell command constructed from library input vulnerabilities, as
 * well as extension points for adding your own.
 */

private import ruby
private import codeql.ruby.DataFlow
private import codeql.ruby.ApiGraphs
private import codeql.ruby.frameworks.core.Gem::Gem as Gem
private import codeql.ruby.Concepts as Concepts
import codeql.ruby.typetracking.TypeTracking

/**
 * Module containing sources, sinks, and sanitizers for shell command constructed from library input.
 */
module UnsafeShellCommandConstruction {
  /** A source for shell command constructed from library input vulnerabilities. */
  abstract class Source extends DataFlow::Node { }

  /** An input parameter to a gem seen as a source. */
  private class LibraryInputAsSource extends Source instanceof DataFlow::ParameterNode {
    LibraryInputAsSource() {
      this = Gem::getALibraryInput() and
      // we exclude arguments named `cmd` or similar, as they seem to execute commands on purpose
      not exists(string name | name = super.getName() |
        name = ["cmd", "command"]
        or
        name.regexpMatch(".*(Cmd|Command)$")
      )
    }
  }

  /** A sink for shell command constructed from library input vulnerabilities. */
  abstract class Sink extends DataFlow::Node {
    /** Gets a description of how the string in this sink was constructed. */
    abstract string describe();

    /** Gets the dataflow node where the string is constructed. */
    DataFlow::Node getStringConstruction() { result = this }

    /** Gets the dataflow node that executed the string as a shell command. */
    abstract DataFlow::Node getCommandExecution();
  }

  /** Holds if the string constructed at `source` is executed at `shellExec` */
  predicate isUsedAsShellCommand(DataFlow::Node source, Concepts::SystemCommandExecution shellExec) {
    source = backtrackShellExec(TypeBackTracker::end(), shellExec)
  }

  private DataFlow::LocalSourceNode backtrackShellExec(
    TypeBackTracker t, Concepts::SystemCommandExecution shellExec
  ) {
    t.start() and
    result = any(DataFlow::Node n | shellExec.isShellInterpreted(n)).getALocalSource()
    or
    exists(TypeBackTracker t2 | result = backtrackShellExec(t2, shellExec).backtrack(t2, t))
  }

  /**
   * A string constructed from a string-literal (e.g. `"foo #{sink}"`),
   * where the resulting string ends up being executed as a shell command.
   */
  class StringInterpolationAsSink extends Sink {
    Concepts::SystemCommandExecution s;
    Ast::StringlikeLiteral lit;

    StringInterpolationAsSink() {
      isUsedAsShellCommand(any(DataFlow::Node n | n.asExpr().getExpr() = lit), s) and
      this.asExpr().getExpr() = lit.getComponent(_)
    }

    override string describe() { result = "string construction" }

    override DataFlow::Node getCommandExecution() { result = s }

    override DataFlow::Node getStringConstruction() { result.asExpr().getExpr() = lit }
  }

  /**
   * A component of a string-concatenation (e.g. `"foo " + sink`),
   * where the resulting string ends up being executed as a shell command.
   */
  class StringConcatAsSink extends Sink {
    Concepts::SystemCommandExecution s;
    Ast::AddExprRoot add;

    StringConcatAsSink() {
      isUsedAsShellCommand(any(DataFlow::Node n | n.asExpr().getExpr() = add), s) and
      this.asExpr().getExpr() = add.getALeaf()
    }

    override DataFlow::Node getCommandExecution() { result = s }

    override string describe() { result = "string concatenation" }

    override DataFlow::Node getStringConstruction() { result.asExpr().getExpr() = add }
  }

  /**
   * A string constructed using a `.join(" ")` call, where the resulting string ends up being executed as a shell command.
   */
  class ArrayJoin extends Sink {
    Concepts::SystemCommandExecution s;
    DataFlow::CallNode call;

    ArrayJoin() {
      call.getMethodName() = "join" and
      call.getNumberOfArguments() = 1 and
      call.getArgument(0).getConstantValue().getString() = " " and
      isUsedAsShellCommand(call, s) and
      (
        this = call.getReceiver() and
        not call.getReceiver().asExpr() instanceof Cfg::CfgNodes::ExprNodes::ArrayLiteralCfgNode
        or
        this.asExpr() =
          call.getReceiver()
              .asExpr()
              .(Cfg::CfgNodes::ExprNodes::ArrayLiteralCfgNode)
              .getAnArgument()
      )
    }

    override string describe() { result = "array" }

    override DataFlow::Node getCommandExecution() { result = s }

    override DataFlow::Node getStringConstruction() { result = call }
  }

  import codeql.ruby.security.TaintedFormatStringSpecific as TaintedFormat

  /**
   * A string constructed from a printf-style call,
   * where the resulting string ends up being executed as a shell command.
   */
  class TaintedFormatStringAsSink extends Sink {
    Concepts::SystemCommandExecution s;
    TaintedFormat::PrintfStyleCall call;

    TaintedFormatStringAsSink() {
      isUsedAsShellCommand(call, s) and
      this = [call.getFormatArgument(_), call.getFormatString()]
    }

    override string describe() { result = "formatted string" }

    override DataFlow::Node getCommandExecution() { result = s }

    override DataFlow::Node getStringConstruction() { result = call }
  }
}
