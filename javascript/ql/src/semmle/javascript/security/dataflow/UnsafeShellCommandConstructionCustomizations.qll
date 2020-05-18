/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * shell command constructed from library input vulnerabilities,
 * as well as extension points for adding your own.
 */

import javascript
import semmle.javascript.security.dataflow.RemoteFlowSources

/**
 * Module containing sources, sinks, and sanitizers for shell command constructed from library input.
 */
module UnsafeShellCommandConstruction {
  import IndirectCommandArgument

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
   * Gets the number of occurrences of "/" in `path`.
   */
  bindingset[path]
  private int countSlashes(string path) {
    not exists(path.indexOf("/")) and result = 0
    or
    result = max(int n | exists(path.indexOf("/", n, 0)) | n)
  }

  /**
   * Gets the topmost package.json that appears in the project.
   *
   * There can be multiple results if the there exists multiple package.json that are equally deeply nested in the folder structure.
   * Results are limited to package.json files that are at most nested 2 directories deep.
   */
  private PackageJSON getTopmostPackageJSON() {
    result =
      min(PackageJSON j |
        countSlashes(j.getFile().getRelativePath()) <= 2
      |
        j order by countSlashes(j.getFile().getRelativePath())
      )
  }

  /**
   * Gets a value exported by the main module from a package.json.
   * The value is either directly the `module.exports` value, a nested property of `module.exports`, or a method on an exported class.
   */
  private DataFlow::Node getAnExportedValue() {
    exists(PackageJSON pack | pack = getTopmostPackageJSON() |
      result = getAnExportFromModule(pack.getMainModule())
    )
    or
    result = getAnExportedValue().(DataFlow::PropWrite).getRhs()
    or
    exists(DataFlow::SourceNode callee |
      callee = getAnExportedValue().(DataFlow::NewNode).getCalleeNode().getALocalSource()
    |
      result = callee.getAPropertyRead("prototype").getAPropertyWrite()
      or
      result = callee.(DataFlow::ClassNode).getAnInstanceMethod()
    )
    or
    result = getAnExportedValue().getALocalSource()
    or
    result = getAnExportedValue().(DataFlow::SourceNode).getAPropertyReference()
    or
    exists(Module mod | mod = getAnExportedValue().getEnclosingExpr().(Import).getImportedModule() |
      result = getAnExportFromModule(mod)
    )
    or
    exists(DataFlow::ClassNode cla | cla = getAnExportedValue() |
      result = cla.getAnInstanceMethod() or
      result = cla.getAStaticMethod() or
      result = cla.getConstructor()
    )
  }

  /**
   * Gets an exported node from the module `mod`.
   */
  private DataFlow::Node getAnExportFromModule(Module mod) {
    result.analyze().getAValue() = mod.(NodeModule).getAModuleExportsValue()
    or
    exists(ASTNode export | result.getEnclosingExpr() = export | mod.exports(_, export))
  }

  /**
   * A parameter of an exported function, seen as a source for shell command constructed from library input.
   */
  class ExternalInputSource extends Source, DataFlow::ParameterNode {
    ExternalInputSource() {
      this = getAnExportedValue().(DataFlow::FunctionNode).getAParameter() and
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
        prev.regexpMatch(".* ('|\")?[0-9a-zA-Z/]*")
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
        formatString.regexpMatch(".* ('|\")?[0-9a-zA-Z/]*%.*")
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
