/** Modeling of the `Pathname` class from the Ruby standard library. */

private import codeql.ruby.AST
private import codeql.ruby.ApiGraphs
private import codeql.ruby.Concepts
private import codeql.ruby.DataFlow
private import codeql.ruby.dataflow.FlowSummary
private import codeql.ruby.dataflow.internal.DataFlowDispatch

/**
 * Modeling of the `Pathname` class from the Ruby standard library.
 *
 * https://docs.ruby-lang.org/en/3.1/Pathname.html
 */
module Pathname {
  /**
   * An instance of the `Pathname` class. For example, in
   *
   * ```rb
   * pn = Pathname.new "foo.txt'"
   * puts pn.read
   * ```
   *
   * there are three `PathnameInstance`s – the call to `Pathname.new`, the
   * assignment `pn = ...`, and the read access to `pn` on the second line.
   *
   * Every `PathnameInstance` is considered to be a `FileNameSource`.
   */
  class PathnameInstance extends FileNameSource, DataFlow::Node {
    PathnameInstance() { this = pathnameInstance() }
  }

  private DataFlow::Node pathnameInstance() {
    // A call to `Pathname.new`.
    result = API::getTopLevelMember("Pathname").getAnInstantiation()
    or
    // Class methods on `Pathname` that return a new `Pathname`.
    result = API::getTopLevelMember("Pathname").getAMethodCall(["getwd", "pwd",])
    or
    // Instance methods on `Pathname` that return a new `Pathname`.
    exists(DataFlow::CallNode c | result = c |
      c.getReceiver() = pathnameInstance() and
      c.getMethodName() =
        [
          "+", "/", "basename", "cleanpath", "expand_path", "join", "realpath",
          "relative_path_from", "sub", "sub_ext", "to_path"
        ]
    )
    or
    exists(DataFlow::Node inst |
      inst = pathnameInstance() and
      inst.(DataFlow::LocalSourceNode).flowsTo(result)
    )
  }

  /** A call where the receiver is a `Pathname`. */
  class PathnameCall extends DataFlow::CallNode {
    PathnameCall() { this.getReceiver() instanceof PathnameInstance }
  }

  /**
   * A call to `Pathname#open` or `Pathname#opendir`, considered as a
   * `FileSystemAccess`.
   */
  class PathnameOpen extends FileSystemAccess::Range, PathnameCall {
    PathnameOpen() { this.getMethodName() = ["open", "opendir"] }

    override DataFlow::Node getAPathArgument() { result = this.getReceiver() }
  }

  /** A call to `Pathname#read`, considered as a `FileSystemReadAccess`. */
  class PathnameRead extends FileSystemReadAccess::Range, PathnameCall {
    PathnameRead() { this.getMethodName() = "read" }

    // The path is the receiver (the `Pathname` object).
    override DataFlow::Node getAPathArgument() { result = this.getReceiver() }

    // The read data is the return value of the call.
    override DataFlow::Node getADataNode() { result = this }
  }

  /** A call to `Pathname#write`, considered as a `FileSystemWriteAccess`. */
  class PathnameWrite extends FileSystemWriteAccess::Range, PathnameCall {
    PathnameWrite() { this.getMethodName() = "write" }

    // The path is the receiver (the `Pathname` object).
    override DataFlow::Node getAPathArgument() { result = this.getReceiver() }

    // The data to write is the 0th argument.
    override DataFlow::Node getADataNode() { result = this.getArgument(0) }
  }

  /** A call to `Pathname#to_s`, considered as a `FileNameSource`. */
  class PathnameToSFilenameSource extends FileNameSource, PathnameCall {
    PathnameToSFilenameSource() { this.getMethodName() = "to_s" }
  }

  private class PathnamePermissionModification extends FileSystemPermissionModification::Range,
    PathnameCall {
    private DataFlow::Node permissionArg;

    PathnamePermissionModification() {
      exists(string methodName | this.getMethodName() = methodName |
        methodName = ["chmod", "mkdir"] and permissionArg = this.getArgument(0)
        or
        methodName = "mkpath" and permissionArg = this.getKeywordArgument("mode")
        or
        methodName = "open" and permissionArg = this.getArgument(1)
        // TODO: defaults for optional args? This may depend on the umask
      )
    }

    override DataFlow::Node getAPermissionNode() { result = permissionArg }
  }

  /** Flow summary for `Pathname.new`. */
  private class NewSummary extends SummarizedCallable {
    NewSummary() { this = "Pathname.new" }

    override MethodCall getACall() {
      result = API::getTopLevelMember("Pathname").getAnInstantiation().getExprNode().getExpr()
    }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[0]" and
      output = "ReturnValue" and
      preservesValue = false
    }
  }

  /** Flow summary for `Pathname#dirname`. */
  private class DirnameSummary extends SimpleSummarizedCallable {
    DirnameSummary() { this = "dirname" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self]" and
      output = "ReturnValue" and
      preservesValue = false
    }
  }

  /** Flow summary for `Pathname#each_filename`. */
  private class EachFilenameSummary extends SimpleSummarizedCallable {
    EachFilenameSummary() { this = "each_filename" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self]" and
      output = "Argument[block].Parameter[0]" and
      preservesValue = false
    }
  }

  /** Flow summary for `Pathname#expand_path`. */
  private class ExpandPathSummary extends SimpleSummarizedCallable {
    ExpandPathSummary() { this = "expand_path" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self]" and
      output = "ReturnValue" and
      preservesValue = false
    }
  }

  /** Flow summary for `Pathname#join`. */
  private class JoinSummary extends SimpleSummarizedCallable {
    JoinSummary() { this = "join" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = ["Argument[self]", "Argument[any]"] and
      output = "ReturnValue" and
      preservesValue = false
    }
  }

  /** Flow summary for `Pathname#parent`. */
  private class ParentSummary extends SimpleSummarizedCallable {
    ParentSummary() { this = "parent" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self]" and
      output = "ReturnValue" and
      preservesValue = false
    }
  }

  /** Flow summary for `Pathname#realpath`. */
  private class RealpathSummary extends SimpleSummarizedCallable {
    RealpathSummary() { this = "realpath" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self]" and
      output = "ReturnValue" and
      preservesValue = false
    }
  }

  /** Flow summary for `Pathname#relative_path_from`. */
  private class RelativePathFromSummary extends SimpleSummarizedCallable {
    RelativePathFromSummary() { this = "relative_path_from" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self]" and
      output = "ReturnValue" and
      preservesValue = false
    }
  }

  /** Flow summary for `Pathname#to_path`. */
  private class ToPathSummary extends SimpleSummarizedCallable {
    ToPathSummary() { this = "to_path" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self]" and
      output = "ReturnValue" and
      preservesValue = false
    }
  }
}
