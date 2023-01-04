/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * second order command injection, as well as
 * extension points for adding your own.
 */

private import ruby
private import codeql.ruby.frameworks.core.Gem::Gem as Gem
private import codeql.ruby.dataflow.RemoteFlowSources
private import codeql.ruby.Concepts as Concepts

/** Classes and predicates for reasoning about second order command injection. */
module SecondOrderCommandInjection {
  /** A shell command that allows for second order command injection. */
  private class VulnerableCommand extends string {
    VulnerableCommand() { this = ["git", "hg"] }

    /**
     * Gets a vulnerable subcommand of this command.
     * E.g. `git` has `clone` and `pull` as vulnerable subcommands.
     * And every command of `hg` is vulnerable due to `--config=alias.<alias>=<command>`.
     */
    bindingset[result]
    string getAVulnerableSubCommand() {
      this = "git" and result = ["clone", "ls-remote", "fetch", "pull"]
      or
      this = "hg" and exists(result)
    }

    /** Gets an example argument that can cause this command to execute arbitrary code. */
    string getVulnerableArgumentExample() {
      this = "git" and result = "--upload-pack"
      or
      this = "hg" and result = "--config=alias.<alias>=<command>"
    }
  }

  /** A source for second order command injection vulnerabilities. */
  abstract class Source extends DataFlow::Node {
    /** Gets a string that describes the source. For use in the alert message. */
    abstract string describe();
  }

  /** A parameter of an exported function, seen as a source for second order command injection. */
  class ExternalInputSource extends Source {
    ExternalInputSource() { this = Gem::getALibraryInput() }

    override string describe() { result = "library input" }
  }

  /** A source of remote flow, seen as a source for second order command injection. */
  class RemoteFlowAsSource extends Source instanceof RemoteFlowSource {
    override string describe() { result = "a user-provided value" }
  }

  /** A sink for second order command injection vulnerabilities. */
  abstract class Sink extends DataFlow::Node {
    /** Gets the command getting invoked. I.e. `git` or `hg`. */
    abstract string getCommand();

    /**
     * Gets an example argument for the comand that allows for second order command injection.
     * E.g. `--upload-pack` for `git`.
     */
    abstract string getVulnerableArgumentExample();

    /** Gets the node where the shell command is executed. */
    abstract DataFlow::Node getCommandExecution();
  }

  /**
   * A sink that invokes a command described by the `VulnerableCommand` class.
   */
  abstract class VulnerableCommandSink extends Sink {
    VulnerableCommand cmd;

    override string getCommand() { result = cmd }

    override string getVulnerableArgumentExample() { result = cmd.getVulnerableArgumentExample() }
  }

  private import codeql.ruby.typetracking.TypeTracker

  /** A sanitizer for second order command injection vulnerabilities. */
  abstract class Sanitizer extends DataFlow::Node { }

  import codeql.ruby.typetracking.TypeTracker

  private DataFlow::LocalSourceNode usedAsArgList(
    TypeBackTracker t, Concepts::SystemCommandExecution exec
  ) {
    t.start() and
    result = exec.getArgumentList().getALocalSource()
    or
    exists(TypeBackTracker t2 |
      result = usedAsArgList(t2, exec).backtrack(t2, t)
      or
      // step through splat expressions
      t2 = t.continue() and
      result.asExpr().getExpr() =
        usedAsArgList(t2, exec).asExpr().getExpr().(Ast::SplatExpr).getOperand()
    )
  }

  /** Gets a dataflow node that ends up being used as an argument list to an invocation of `git` or `hg`. */
  private DataFlow::LocalSourceNode usedAsVersionControlArgs(
    TypeBackTracker t, DataFlow::Node argList, VulnerableCommand cmd,
    Concepts::SystemCommandExecution exec
  ) {
    t.start() and
    exec.getACommandArgument().getConstantValue().getStringlikeValue() = cmd and
    exec.getArgumentList() = argList and
    result = argList.getALocalSource()
    or
    // TODO: This second base-case is untested.
    t.start() and
    exists(Cfg::CfgNodes::ExprNodes::ArrayLiteralCfgNode arr |
      argList = usedAsArgList(TypeBackTracker::end(), exec) and
      arr = argList.asExpr() and
      arr.getArgument(0).getConstantValue().getStringlikeValue() = cmd
    |
      result = argList.getALocalSource()
      or
      result
          .flowsTo(any(DataFlow::Node n |
              n.asExpr().getExpr() = arr.getArgument(_).getExpr().(Ast::SplatExpr).getOperand()
            ))
    )
    or
    exists(TypeBackTracker t2 |
      result = usedAsVersionControlArgs(t2, argList, cmd, exec).backtrack(t2, t)
      or
      // step through splat expressions (TODO: untested?)
      t2 = t.continue() and
      result
          .flowsTo(any(DataFlow::Node n |
              n.asExpr().getExpr() =
                usedAsVersionControlArgs(t2, argList, cmd, exec)
                    .asExpr()
                    .getExpr()
                    .(Ast::SplatExpr)
                    .getOperand()
            ))
    )
  }

  private import codeql.ruby.dataflow.internal.DataFlowDispatch as Dispatch

  class CallSink extends Sink {
    VulnerableCommand cmd;
    Concepts::SystemCommandExecution exec;

    CallSink() {
      exists(DataFlow::CallNode list |
        usedAsVersionControlArgs(TypeBackTracker::end(), _, cmd, exec) = list and
        list.getMethodName() = "[]" and
        exists(int i, int j | i < j |
          list.getArgument(i).getConstantValue().getStringlikeValue() =
            cmd.getAVulnerableSubCommand() and
          this = list.getArgument(j)
        )
      )
    }

    override string getCommand() { result = cmd }

    override string getVulnerableArgumentExample() { result = cmd.getVulnerableArgumentExample() }

    override DataFlow::Node getCommandExecution() { result = exec }
  }

  // TODO: THis indirect call is untested.
  private class IndirectVcsCall extends DataFlow::CallNode {
    VulnerableCommand cmd;
    Concepts::SystemCommandExecution exec;

    IndirectVcsCall() {
      // TODO: This entire thing is ugly.
      exists(Dispatch::DataFlowCallable calleeDis, Ast::Callable callee, DataFlow::Node list |
        calleeDis =
          Dispatch::viableCallable(any(Dispatch::DataFlowCall c | c.asCall() = this.asExpr())) and
        calleeDis.asCallable() = callee and
        list.asExpr().getExpr() = callee.getParameter(0).(Ast::SplatParameter).getDefiningAccess() and
        // TODO: multiple nodes in the same position, i need to figure that out if this makes production.
        usedAsVersionControlArgs(TypeBackTracker::end(), _, cmd, exec).getLocation() =
          list.getLocation()
      )
    }

    VulnerableCommand getCommand() { result = cmd }

    Concepts::SystemCommandExecution getCommandExecution() { result = exec }
  }

  class IndirectCallSink extends Sink {
    VulnerableCommand cmd;
    IndirectVcsCall call;

    IndirectCallSink() {
      exists(int i |
        call.getCommand() = cmd and
        call.getArgument(i).getConstantValue().getStringlikeValue() = cmd.getAVulnerableSubCommand() and
        this = call.getArgument(any(int j | j > i))
      )
    }

    override string getCommand() { result = cmd }

    override string getVulnerableArgumentExample() { result = cmd.getVulnerableArgumentExample() }

    override DataFlow::Node getCommandExecution() { result = call.getCommandExecution() }
  }
}
