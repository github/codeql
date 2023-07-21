/** Modeling of the `Pathname` class from the Ruby standard library. */

private import codeql.ruby.AST
private import codeql.ruby.ApiGraphs
private import codeql.ruby.Concepts
private import codeql.ruby.dataflow.FlowSummary
private import codeql.ruby.frameworks.data.ModelsAsData
private import codeql.ruby.dataflow.internal.DataFlowImplForPathname

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
   * there are three `PathnameInstance`s - the call to `Pathname.new`, the
   * assignment `pn = ...`, and the read access to `pn` on the second line.
   *
   * Every `PathnameInstance` is considered to be a `FileNameSource`.
   */
  class PathnameInstance extends FileNameSource {
    cached
    PathnameInstance() { any(PathnameConfiguration c).hasFlowTo(this) }
  }

  private class PathnameConfiguration extends Configuration {
    PathnameConfiguration() { this = "PathnameConfiguration" }

    override predicate isSource(DataFlow::Node source) {
      // A call to `Pathname.new`.
      source = API::getTopLevelMember("Pathname").getAnInstantiation()
      or
      // Class methods on `Pathname` that return a new `Pathname`.
      source = API::getTopLevelMember("Pathname").getAMethodCall(["getwd", "pwd",])
    }

    override predicate isSink(DataFlow::Node sink) { any() }

    override predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
      node2 =
        any(DataFlow::CallNode c |
          c.getReceiver() = node1 and
          c.getMethodName() =
            [
              "+", "/", "basename", "cleanpath", "expand_path", "join", "realpath",
              "relative_path_from", "sub", "sub_ext", "to_path"
            ]
        )
    }
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
    PathnameCall
  {
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

  /**
   * Type summaries for the `Pathname` class, i.e. method calls that produce new
   * `Pathname` instances.
   */
  private class PathnameTypeSummary extends ModelInput::TypeModelCsv {
    override predicate row(string row) {
      // type1;type2;path
      row =
        [
          // Pathname#+(path) : Pathname
          "Pathname;Pathname;Method[+].ReturnValue",
          // Pathname#/(path) : Pathname
          "Pathname;Pathname;Method[/].ReturnValue",
          // Pathname#basename(path) : Pathname
          "Pathname;Pathname;Method[basename].ReturnValue",
          // Pathname#cleanpath(path) : Pathname
          "Pathname;Pathname;Method[cleanpath].ReturnValue",
          // Pathname#expand_path(path) : Pathname
          "Pathname;Pathname;Method[expand_path].ReturnValue",
          // Pathname#join(path) : Pathname
          "Pathname;Pathname;Method[join].ReturnValue",
          // Pathname#realpath(path) : Pathname
          "Pathname;Pathname;Method[realpath].ReturnValue",
          // Pathname#relative_path_from(path) : Pathname
          "Pathname;Pathname;Method[relative_path_from].ReturnValue",
          // Pathname#sub(path) : Pathname
          "Pathname;Pathname;Method[sub].ReturnValue",
          // Pathname#sub_ext(path) : Pathname
          "Pathname;Pathname;Method[sub_ext].ReturnValue",
          // Pathname#to_path(path) : Pathname
          "Pathname;Pathname;Method[to_path].ReturnValue",
        ]
    }
  }

  /** Taint flow summaries for the `Pathname` class. */
  private class PathnameTaintSummary extends ModelInput::SummaryModelCsv {
    override predicate row(string row) {
      row =
        [
          // Pathname.new(path)
          "Pathname!;Method[new];Argument[0];ReturnValue;taint",
          // Pathname#dirname
          "Pathname;Method[dirname];Argument[self];ReturnValue;taint",
          // Pathname#each_filename
          "Pathname;Method[each_filename];Argument[self];Argument[block].Parameter[0];taint",
          // Pathname#expand_path
          "Pathname;Method[expand_path];Argument[self];ReturnValue;taint",
          // Pathname#join
          "Pathname;Method[join];Argument[self,any];ReturnValue;taint",
          // Pathname#parent
          "Pathname;Method[parent];Argument[self];ReturnValue;taint",
          // Pathname#realpath
          "Pathname;Method[realpath];Argument[self];ReturnValue;taint",
          // Pathname#relative_path_from
          "Pathname;Method[relative_path_from];Argument[self];ReturnValue;taint",
          // Pathname#to_path
          "Pathname;Method[to_path];Argument[self];ReturnValue;taint",
          // Pathname#basename
          "Pathname;Method[basename];Argument[self];ReturnValue;taint",
          // Pathname#cleanpath
          "Pathname;Method[cleanpath];Argument[self];ReturnValue;taint",
          // Pathname#sub
          "Pathname;Method[sub];Argument[self];ReturnValue;taint",
          // Pathname#sub_ext
          "Pathname;Method[sub_ext];Argument[self];ReturnValue;taint",
        ]
    }
  }
}
