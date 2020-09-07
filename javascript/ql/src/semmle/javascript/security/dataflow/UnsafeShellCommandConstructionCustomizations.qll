/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * shell command constructed from library input vulnerabilities,
 * as well as extension points for adding your own.
 */

import javascript
private import semmle.javascript.security.dataflow.RemoteFlowSources
private import semmle.javascript.PackageExports as Exports

/**
 * Module containing sources, sinks, and sanitizers for shell command constructed from library input.
 */
module UnsafeShellCommandConstruction {
  import IndirectCommandArgument
  import semmle.javascript.security.IncompleteBlacklistSanitizer as IncompleteBlacklistSanitizer

  /**
   * A data flow source for shell command constructed from library input.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for shell command constructed from library input.
   */
  abstract class Sink extends DataFlow::Node {
    /**
     * Gets a description how the shell command is constructed for this sink.
     */
    abstract string getSinkType();

    /**
     * Gets the dataflow node that executes the shell command.
     */
    abstract SystemCommandExecution getCommandExecution();

    /**
     * Gets the node that should be highlighted for this sink.
     * E.g. for a string concatenation, the sink is one of the leaves and the highlight is the concatenation root.
     */
    abstract DataFlow::Node getAlertLocation();
  }

  /**
   * A sanitizer for shell command constructed from library input.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A parameter of an exported function, seen as a source for shell command constructed from library input.
   */
  class ExternalInputSource extends Source, DataFlow::ParameterNode {
    ExternalInputSource() {
      this =
        Exports::getAValueExportedBy(Exports::getTopmostPackageJSON())
            .(DataFlow::FunctionNode)
            .getAParameter() and
      not this.getName() = ["cmd", "command"] // looks to be on purpose.
    }
  }

  /**
   * Gets a node that is later executed as a shell command in the command execution `sys`.
   */
  private DataFlow::Node isExecutedAsShellCommand(
    DataFlow::TypeBackTracker t, SystemCommandExecution sys
  ) {
    t.start() and result = sys.getACommandArgument() and sys.isShellInterpreted(result)
    or
    t.start() and isIndirectCommandArgument(result, sys)
    or
    exists(DataFlow::TypeBackTracker t2 |
      t2 = t.smallstep(result, isExecutedAsShellCommand(t2, sys))
    )
  }

  /**
   * A string concatenation that is later executed as a shell command.
   */
  class StringConcatEndingInCommandExecutionSink extends Sink, StringOps::ConcatenationLeaf {
    SystemCommandExecution sys;
    StringOps::ConcatenationRoot root;

    StringConcatEndingInCommandExecutionSink() {
      this = root.getALeaf() and
      root = isExecutedAsShellCommand(DataFlow::TypeBackTracker::end(), sys) and
      exists(string prev | prev = this.getPreviousLeaf().getStringValue() |
        prev.regexpMatch(".* ('|\")?[0-9a-zA-Z/:_-]*")
      )
    }

    override string getSinkType() { result = "String concatenation" }

    override SystemCommandExecution getCommandExecution() { result = sys }

    override DataFlow::Node getAlertLocation() { result = root }
  }

  /**
   * An element pushed to an array, where the array is later used to execute a shell command.
   */
  class ArrayAppendEndingInCommandExecutinSink extends Sink {
    DataFlow::SourceNode array;
    SystemCommandExecution sys;

    ArrayAppendEndingInCommandExecutinSink() {
      this =
        [array.(DataFlow::ArrayCreationNode).getAnElement(),
            array.getAMethodCall(["push", "unshift"]).getAnArgument()] and
      exists(DataFlow::MethodCallNode joinCall | array.getAMethodCall("join") = joinCall |
        joinCall = isExecutedAsShellCommand(DataFlow::TypeBackTracker::end(), sys) and
        joinCall.getNumArgument() = 1 and
        joinCall.getArgument(0).getStringValue() = " "
      )
    }

    override string getSinkType() { result = "Array element" }

    override SystemCommandExecution getCommandExecution() { result = sys }

    override DataFlow::Node getAlertLocation() { result = this }
  }

  /**
   * A formatted string that is later executed as a shell command.
   */
  class FormatedStringInCommandExecutionSink extends Sink {
    PrintfStyleCall call;
    SystemCommandExecution sys;

    FormatedStringInCommandExecutionSink() {
      this = call.getFormatArgument(_) and
      call = isExecutedAsShellCommand(DataFlow::TypeBackTracker::end(), sys) and
      exists(string formatString | call.getFormatString().mayHaveStringValue(formatString) |
        formatString.regexpMatch(".* ('|\")?[0-9a-zA-Z/:_-]*%.*")
      )
    }

    override string getSinkType() { result = "Formatted string" }

    override SystemCommandExecution getCommandExecution() { result = sys }

    override DataFlow::Node getAlertLocation() { result = this }
  }

  /**
   * A sanitizer like: "'"+name.replace(/'/g,"'\\''")+"'"
   * Which sanitizes on Unix.
   * The sanitizer is only safe if sorounded by single-quotes, which is assumed.
   */
  class ReplaceQuotesSanitizer extends Sanitizer, StringReplaceCall {
    ReplaceQuotesSanitizer() {
      this.getAReplacedString() = "'" and
      this.isGlobal() and
      this.getRawReplacement().mayHaveStringValue(["'\\''", ""])
    }
  }

  /**
   * A chain of replace calls that replaces all unsafe chars for shell-commands.
   */
  class ChainSanitizer extends Sanitizer, IncompleteBlacklistSanitizer::StringReplaceCallSequence {
    ChainSanitizer() {
      forall(string char |
        char = ["&", "`", "$", "|", ">", "<", "#", ";", "(", ")", "[", "]", "\n"]
      |
        this.getAMember().getAReplacedString() = char
      )
    }
  }

  /**
   * A sanitizer that sanitizers paths that exist in the file-system.
   * For example: `x` is sanitized in `fs.existsSync(x)` or `fs.existsSync(x + "/suffix/path")`.
   */
  class PathExistsSanitizerGuard extends TaintTracking::SanitizerGuardNode, DataFlow::CallNode {
    PathExistsSanitizerGuard() {
      this = DataFlow::moduleMember("path", "exist").getACall() or
      this = DataFlow::moduleMember("fs", "existsSync").getACall()
    }

    override predicate sanitizes(boolean outcome, Expr e) {
      outcome = true and
      (
        e = getArgument(0).asExpr() or
        e = getArgument(0).(StringOps::ConcatenationRoot).getALeaf().asExpr()
      )
    }
  }
}
