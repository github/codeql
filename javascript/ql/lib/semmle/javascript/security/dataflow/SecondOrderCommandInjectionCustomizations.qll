/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * second order command injection, as well as
 * extension points for adding your own.
 */

import javascript
private import semmle.javascript.PackageExports as Exports
private import semmle.javascript.security.TaintedObjectCustomizations

/** Classes and predicates for reasoning about second order command injection. */
module SecondOrderCommandInjection {
  import semmle.javascript.security.CommonFlowState

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

  /** A source for second order command injection. */
  abstract class Source extends DataFlow::Node {
    /** Gets a string that describes the source. For use in the alert message. */
    abstract string describe();

    /** Gets a flow state for which this is a source. */
    FlowState getAFlowState() { result.isTaint() }

    /** DEPRECATED. Use `getAFlowState()` instead */
    deprecated DataFlow::FlowLabel getALabel() { result = this.getAFlowState().toFlowLabel() }
  }

  /** A parameter of an exported function, seen as a source for second order command injection. */
  class ExternalInputSource extends Source {
    ExternalInputSource() { this = Exports::getALibraryInputParameter() }

    override string describe() { result = "library input" }

    override FlowState getAFlowState() { result.isTaintedObject() or result.isTaint() }
  }

  /** A source of remote flow, seen as a source for second order command injection. */
  class RemoteFlowAsSource extends Source instanceof RemoteFlowSource {
    override string describe() { result = "a user-provided value" }

    override FlowState getAFlowState() { result.isTaint() }
  }

  private class TaintedObjectSourceAsSource extends Source instanceof TaintedObject::Source {
    override FlowState getAFlowState() { result.isTaintedObject() }

    override string describe() { result = "a user-provided value" }
  }

  /** A sanitizer for second order command injection. */
  abstract class Sanitizer extends DataFlow::Node { }

  /** A sink for second order command injection. */
  abstract class Sink extends DataFlow::Node {
    /** Gets a flow state for which this is a sink. */
    FlowState getAFlowState() { result.isTaint() or result.isTaintedObject() }

    /** DERECATED. Use `getAFlowState()` instead. */
    deprecated DataFlow::FlowLabel getALabel() { result = this.getAFlowState().toFlowLabel() }

    /** Gets the command getting invoked. I.e. `git` or `hg`. */
    abstract string getCommand();

    /**
     * Gets an example argument for the comand that allows for second order command injection.
     * E.g. `--upload-pack` for `git`.
     */
    abstract string getVulnerableArgumentExample();
  }

  /**
   * A barrier guard for second order command-injection vulnerabilities.
   */
  abstract class BarrierGuard extends DataFlow::Node {
    /**
     * Holds if this node acts as a barrier for data flow, blocking further flow from `e` if `this` evaluates to `outcome`.
     */
    predicate blocksExpr(boolean outcome, Expr e) { none() }

    /**
     * Holds if this node acts as a barrier for `state`, blocking further flow from `e` if `this` evaluates to `outcome`.
     */
    predicate blocksExpr(boolean outcome, Expr e, FlowState state) { none() }

    /** DEPRECATED. Use `blocksExpr` instead. */
    deprecated predicate sanitizes(boolean outcome, Expr e) { this.blocksExpr(outcome, e) }

    /** DEPRECATED. Use `blocksExpr` instead. */
    deprecated predicate sanitizes(boolean outcome, Expr e, DataFlow::FlowLabel label) {
      this.blocksExpr(outcome, e, FlowState::fromFlowLabel(label))
    }
  }

  /** A subclass of `BarrierGuard` that is used for backward compatibility with the old data flow library. */
  deprecated final private class BarrierGuardLegacy extends TaintTracking::SanitizerGuardNode instanceof BarrierGuard
  {
    override predicate sanitizes(boolean outcome, Expr e) {
      BarrierGuard.super.sanitizes(outcome, e)
    }

    override predicate sanitizes(boolean outcome, Expr e, DataFlow::FlowLabel label) {
      BarrierGuard.super.sanitizes(outcome, e, label)
    }
  }

  /**
   * A sink that invokes a command described by the `VulnerableCommand` class.
   */
  abstract class VulnerableCommandSink extends Sink {
    VulnerableCommand cmd;

    override string getCommand() { result = cmd }

    override string getVulnerableArgumentExample() { result = cmd.getVulnerableArgumentExample() }
  }

  /** A call that (indirectly) executes a shell command with a list of arguments. */
  abstract private class CommandExecutingCall extends DataFlow::CallNode {
    /** Gets the dataflow node representing the command to execute. */
    abstract DataFlow::Node getCommandArg();

    /** Gets the dataflow node representing the arguments to the command. */
    abstract DataFlow::Node getArgList();
  }

  /** A `SystemCommandExecution` seen as a command executing call. */
  private class SystemExecAsCmdCall extends CommandExecutingCall instanceof SystemCommandExecution {
    override DataFlow::Node getCommandArg() {
      result = SystemCommandExecution.super.getACommandArgument()
    }

    override DataFlow::Node getArgList() { result = SystemCommandExecution.super.getArgumentList() }
  }

  /** A function whose parameters is directly used a command and argument list for a shell invocation. */
  private class IndirectCmdFunc extends DataFlow::FunctionNode {
    int cmdIndex;
    int argIndex;

    IndirectCmdFunc() {
      exists(CommandExecutingCall call |
        this.getParameter(cmdIndex).flowsTo(call.getCommandArg()) and
        this.getParameter(argIndex).flowsTo(call.getArgList())
      )
    }

    /** Gets the parameter index that indicates the command to be executed. */
    int getCmdIndex() { result = cmdIndex }

    /** Gets the parameter index that indicates the argument list to be passed to the command. */
    int getArgIndex() { result = argIndex }
  }

  /** A call to a function that eventually executes a shell command with a list of arguments. */
  private class IndirectExecCall extends DataFlow::CallNode, CommandExecutingCall {
    IndirectCmdFunc func;

    IndirectExecCall() { this.getACallee() = func.getFunction() }

    override DataFlow::Node getCommandArg() { result = this.getArgument(func.getCmdIndex()) }

    override DataFlow::Node getArgList() { result = this.getArgument(func.getArgIndex()) }
  }

  /** Gets a dataflow node that ends up being used as an argument list to an invocation of `git` or `hg`. */
  private DataFlow::SourceNode usedAsVersionControlArgs(
    DataFlow::TypeBackTracker t, DataFlow::Node argList, VulnerableCommand cmd
  ) {
    t.start() and
    exists(CommandExecutingCall exec | exec.getCommandArg().mayHaveStringValue(cmd) |
      exec.getArgList() = argList and
      result = argList.getALocalSource()
    )
    or
    exists(DataFlow::TypeBackTracker t2 |
      result = usedAsVersionControlArgs(t2, argList, cmd).backtrack(t2, t)
    )
  }

  /** An argument to an invocation of `git`/`hg` that can cause second order command injection. */
  class ArgSink extends VulnerableCommandSink {
    ArgSink() {
      exists(DataFlow::ArrayCreationNode args |
        args = usedAsVersionControlArgs(DataFlow::TypeBackTracker::end(), _, cmd)
      |
        this = [args.getAnElement(), args.getASpreadArgument()] and
        args.getElement(0).mayHaveStringValue(cmd.getAVulnerableSubCommand()) and
        // not an "--" argument (even if it's earlier, then we assume it's on purpose)
        not args.getElement(_).mayHaveStringValue("--")
      )
    }

    override FlowState getAFlowState() { result.isTaint() }
  }

  /**
   * An arguments array given to an invocation of `git` or `hg` that can cause second order command injection.
   */
  class ArgsArraySink extends VulnerableCommandSink {
    ArgsArraySink() {
      exists(SystemExecAsCmdCall exec | exec.getCommandArg().mayHaveStringValue(cmd) |
        this = exec.getArgList()
      )
    }

    // only vulnerable if an attacker controls the entire array
    override FlowState getAFlowState() { result.isTaintedObject() }
  }

  /**
   * A sanitizer that blocks flow when a string is tested to start with a certain prefix.
   */
  class PrefixStringSanitizer extends BarrierGuard instanceof StringOps::StartsWith {
    override predicate blocksExpr(boolean outcome, Expr e) {
      e = super.getBaseString().asExpr() and
      outcome = super.getPolarity()
    }
  }

  /**
   * A sanitizer that blocks flow when a string does not start with "--"
   */
  class DoubleDashSanitizer extends BarrierGuard instanceof StringOps::StartsWith {
    DoubleDashSanitizer() { super.getSubstring().mayHaveStringValue("--") }

    override predicate blocksExpr(boolean outcome, Expr e) {
      e = super.getBaseString().asExpr() and
      outcome = super.getPolarity().booleanNot()
    }
  }

  /** A call to path.relative which sanitizes the taint. */
  class PathRelativeSanitizer extends Sanitizer {
    PathRelativeSanitizer() { this = NodeJSLib::Path::moduleMember("relative").getACall() }
  }
}
