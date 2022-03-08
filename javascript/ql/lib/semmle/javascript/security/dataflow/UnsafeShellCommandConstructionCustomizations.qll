/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * shell command constructed from library input vulnerabilities,
 * as well as extension points for adding your own.
 */

import javascript
private import semmle.javascript.security.dataflow.RemoteFlowSources
private import semmle.javascript.PackageExports as Exports
private import semmle.javascript.dataflow.InferredTypes

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
  class ExternalInputSource extends Source, DataFlow::SourceNode {
    ExternalInputSource() {
      this = Exports::getALibraryInputParameter() and
      not (
        // looks to be on purpose.
        this.(DataFlow::ParameterNode).getName() = ["cmd", "command"]
        or
        this.(DataFlow::ParameterNode).getName().regexpMatch(".*(Cmd|Command)$") // ends with "Cmd" or "Command"
      )
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
    or
    exists(DataFlow::TypeBackTracker t2, StringOps::ConcatenationRoot prev |
      t = t2.continue() and
      isExecutedAsShellCommand(t2, sys) = prev and
      result = prev.getALeaf()
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
    SystemCommandExecution sys;

    ArrayAppendEndingInCommandExecutinSink() {
      exists(DataFlow::SourceNode array |
        this =
          [
            array.(DataFlow::ArrayCreationNode).getAnElement(),
            array.getAMethodCall(["push", "unshift"]).getAnArgument()
          ] and
        exists(DataFlow::MethodCallNode joinCall | array.getAMethodCall("join") = joinCall |
          joinCall = isExecutedAsShellCommand(DataFlow::TypeBackTracker::end(), sys) and
          joinCall.getNumArgument() = 1 and
          joinCall.getArgument(0).getStringValue() = " "
        )
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
    SystemCommandExecution sys;

    FormatedStringInCommandExecutionSink() {
      exists(PrintfStyleCall call |
        this = call.getFormatArgument(_) and
        call = isExecutedAsShellCommand(DataFlow::TypeBackTracker::end(), sys) and
        exists(string formatString | call.getFormatString().mayHaveStringValue(formatString) |
          formatString.regexpMatch(".* ('|\")?[0-9a-zA-Z/:_-]*%.*")
        )
      )
    }

    override string getSinkType() { result = "Formatted string" }

    override SystemCommandExecution getCommandExecution() { result = sys }

    override DataFlow::Node getAlertLocation() { result = this }
  }

  /**
   * Gets a node that ends up in an array that is ultimately executed as a shell script by `sys`.
   */
  private DataFlow::SourceNode endsInShellExecutedArray(
    DataFlow::TypeBackTracker t, SystemCommandExecution sys
  ) {
    t.start() and
    result = sys.getArgumentList().getALocalSource() and
    // the array gets joined to a string when `shell` is set to true.
    sys.getOptionsArg()
        .getALocalSource()
        .getAPropertyWrite("shell")
        .getRhs()
        .asExpr()
        .(BooleanLiteral)
        .getValue() = "true"
    or
    exists(DataFlow::TypeBackTracker t2 |
      result = endsInShellExecutedArray(t2, sys).backtrack(t2, t)
    )
  }

  /**
   * An argument to a command invocation where the `shell` option is set to true.
   */
  class ShellTrueCommandExecutionSink extends Sink {
    SystemCommandExecution sys;

    ShellTrueCommandExecutionSink() {
      // `shell` is set to true. That means string-concatenation happens behind the scenes.
      // We just assume that a `shell` option in any library means the same thing as it does in NodeJS.
      exists(DataFlow::SourceNode arr |
        arr = endsInShellExecutedArray(DataFlow::TypeBackTracker::end(), sys)
      |
        this = arr.(DataFlow::ArrayCreationNode).getAnElement()
        or
        this = arr.getAMethodCall(["push", "unshift"]).getAnArgument()
      )
    }

    override string getSinkType() { result = "Shell argument" }

    override SystemCommandExecution getCommandExecution() { result = sys }

    override DataFlow::Node getAlertLocation() { result = this }
  }

  /**
   * A joined path (`path.{resolve/join}(..)`) that is later executed as a shell command.
   * Joining a path is similar to string concatenation that automatically inserts slashes.
   */
  class JoinedPathEndingInCommandExecutionSink extends Sink {
    SystemCommandExecution sys;

    JoinedPathEndingInCommandExecutionSink() {
      exists(DataFlow::MethodCallNode joinCall |
        this = joinCall.getAnArgument() and
        joinCall = DataFlow::moduleMember("path", ["resolve", "join"]).getACall() and
        joinCall = isExecutedAsShellCommand(DataFlow::TypeBackTracker::end(), sys)
      )
    }

    override string getSinkType() { result = "Path concatenation" }

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
   * Gets an unsafe shell character.
   */
  private string getAShellChar() {
    result = ["&", "`", "$", "|", ">", "<", "#", ";", "(", ")", "[", "]", "\n"]
  }

  /**
   * A chain of replace calls that replaces all unsafe chars for shell-commands.
   */
  class ChainSanitizer extends Sanitizer, IncompleteBlacklistSanitizer::StringReplaceCallSequence {
    ChainSanitizer() {
      forall(string char | char = getAShellChar() | this.getAMember().getAReplacedString() = char)
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
        e = this.getArgument(0).asExpr() or
        e = this.getArgument(0).(StringOps::ConcatenationRoot).getALeaf().asExpr()
      )
    }
  }

  /**
   * A guard of the form `typeof x === "<T>"`, where <T> is  "number", or "boolean",
   * which sanitizes `x` in its "then" branch.
   */
  class TypeOfSanitizer extends TaintTracking::SanitizerGuardNode, DataFlow::ValueNode {
    Expr x;
    override EqualityTest astNode;

    TypeOfSanitizer() { TaintTracking::isTypeofGuard(astNode, x, ["number", "boolean"]) }

    override predicate sanitizes(boolean outcome, Expr e) {
      outcome = astNode.getPolarity() and
      e = x
    }
  }

  /** A guard that checks whether `x` is a number. */
  class NumberGuard extends TaintTracking::SanitizerGuardNode instanceof DataFlow::CallNode {
    Expr x;
    boolean polarity;

    NumberGuard() { TaintTracking::isNumberGuard(this, x, polarity) }

    override predicate sanitizes(boolean outcome, Expr e) { e = x and outcome = polarity }
  }

  private import semmle.javascript.dataflow.internal.AccessPaths
  private import semmle.javascript.dataflow.InferredTypes

  /**
   * Holds if `instance` is an instance of the access-path `ap`, and there exists a guard
   * that ensures that `instance` is not equal to `char`.
   *
   * For example if `ap` is `str[i]` and `char` is `<`:
   * ```JavaScript
   * if (str[i] !== "<" && ...) {
   *   var foo = str[i]; // <- `instance`
   * }
   * ```
   * or
   * ```JavaScript
   * if (!(str[i] == "<" || ...)) {
   *   var foo = str[i]; // <- `instance`
   * }
   * ```
   */
  private predicate blocksCharInAccess(AccessPath ap, string char, Expr instance) {
    exists(BasicBlock bb, ConditionGuardNode guard, EqualityTest test |
      test.getAnOperand().mayHaveStringValue(char) and
      char = getAShellChar() and
      guard.getTest() = test and
      guard.dominates(bb) and
      test.getAnOperand() = ap.getAnInstance() and
      instance = ap.getAnInstanceIn(bb) and
      guard.getOutcome() != test.getPolarity()
    )
  }

  /**
   * A sanitizer for a single character, where the character cannot be an unsafe shell character.
   */
  class SanitizedChar extends Sanitizer, DataFlow::ValueNode {
    override PropAccess astNode;

    SanitizedChar() {
      exists(AccessPath ap | this.asExpr() = ap.getAnInstance() |
        forall(string char | char = getAShellChar() | blocksCharInAccess(ap, char, astNode))
      ) and
      astNode.getPropertyNameExpr().analyze().getTheType() = TTNumber()
    }
  }
}
