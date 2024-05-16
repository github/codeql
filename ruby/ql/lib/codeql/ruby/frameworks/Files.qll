/**
 * Provides classes for working with file system libraries.
 */

private import codeql.ruby.AST
private import codeql.ruby.Concepts
private import codeql.ruby.ApiGraphs
private import codeql.ruby.DataFlow
private import codeql.ruby.dataflow.FlowSummary
private import core.IO
private import core.Kernel::Kernel
private import core.internal.IOOrFile

/**
 * Classes and predicates for modeling the core `File` module.
 *
 * Because `File` is a subclass of `IO`, all `FileInstance`s and
 * `FileModuleReader`s are also `IOInstance`s and `IOModuleReader`s
 * respectively.
 */
module File {
  /**
   * An instance of the `File` class, for example in
   *
   * ```rb
   * f = File.new("foo.txt")
   * puts f.read()
   * ```
   *
   * there are 3 `FileInstance`s - the call to `File.new`, the assignment
   * `f = ...`, and the read access to `f` on the second line.
   */
  class FileInstance extends IO::IOInstance {
    FileInstance() { this = fileInstance() }
  }

  /**
   * A call to `File.open`, considered as a `FileSystemAccess`.
   */
  class FileOpen extends DataFlow::CallNode, FileSystemAccess::Range {
    FileOpen() { this = API::getTopLevelMember("File").getAMethodCall("open") }

    override DataFlow::Node getAPathArgument() { result = this.getArgument(0) }
  }

  /**
   * A read using the `File` module, e.g. the `f.read` call in
   *
   * ```rb
   *   f = File.new("foo.txt")
   *   puts f.read()
   * ```
   */
  class FileModuleReader extends IO::FileReader {
    FileModuleReader() { this.getApi() = "File" }

    override DataFlow::Node getADataNode() { result = this.getADataNodeImpl() }

    override DataFlow::Node getAPathArgument() { result = this.getAPathArgumentImpl() }
  }

  /**
   * A call to a `File` method that may return one or more filenames.
   */
  class FileModuleFilenameSource extends FileNameSource, DataFlow::CallNode {
    FileModuleFilenameSource() {
      // Class methods
      this =
        API::getTopLevelMember("File")
            .getAMethodCall([
                "absolute_path", "basename", "expand_path", "join", "path", "readlink",
                "realdirpath", "realpath"
              ])
      or
      // Instance methods
      exists(File::FileInstance fi |
        this.getReceiver() = fi and
        this.getMethodName() = ["path", "to_path"]
      )
    }
  }

  private class FileModulePermissionModification extends FileSystemPermissionModification::Range,
    DataFlow::CallNode
  {
    private DataFlow::Node permissionArg;

    FileModulePermissionModification() {
      exists(string methodName | this = API::getTopLevelMember("File").getAMethodCall(methodName) |
        methodName in ["chmod", "lchmod"] and permissionArg = this.getArgument(0)
        or
        methodName = "mkfifo" and permissionArg = this.getArgument(1)
        or
        methodName in ["new", "open"] and permissionArg = this.getArgument(2)
        // TODO: defaults for optional args? This may depend on the umask
      )
    }

    override DataFlow::Node getAPermissionNode() { result = permissionArg }
  }

  /**
   * A flow summary for several methods on the `File` class that propagate taint
   * from their first argument to the return value.
   */
  class FilePathConversionSummary extends SummarizedCallable {
    string methodName;

    FilePathConversionSummary() {
      methodName = ["absolute_path", "dirname", "expand_path", "path", "realdirpath", "realpath"] and
      this = "File." + methodName
    }

    override MethodCall getACall() {
      result = API::getTopLevelMember("File").getAMethodCall(methodName).asExpr().getExpr()
    }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[0]" and
      output = "ReturnValue" and
      preservesValue = false
    }
  }

  /**
   * A flow summary for `File.join`, which propagates taint from every argument to
   * its return value.
   */
  class FileJoinSummary extends SummarizedCallable {
    FileJoinSummary() { this = "File.join" }

    override MethodCall getACall() {
      result = API::getTopLevelMember("File").getAMethodCall("join").asExpr().getExpr()
    }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[0,1..]" and
      output = "ReturnValue" and
      preservesValue = false
    }
  }
}

/**
 * Classes and predicates for modeling the `FileUtils` module from the standard
 * library.
 */
module FileUtils {
  /**
   * A call to a FileUtils method that may return one or more filenames.
   */
  class FileUtilsFilenameSource extends FileNameSource {
    FileUtilsFilenameSource() {
      // Note that many methods in FileUtils accept a `noop` option that will
      // perform a dry run of the command. This means that, for instance, `rm`
      // and similar methods may not actually delete/unlink a file when called.
      this =
        API::getTopLevelMember("FileUtils")
            .getAMethodCall([
                "chmod", "chmod_R", "chown", "chown_R", "getwd", "makedirs", "mkdir", "mkdir_p",
                "mkpath", "remove", "remove_dir", "remove_entry", "rm", "rm_f", "rm_r", "rm_rf",
                "rmdir", "rmtree", "safe_unlink", "touch"
              ])
    }
  }

  private class FileUtilsPermissionModification extends FileSystemPermissionModification::Range,
    DataFlow::CallNode
  {
    private DataFlow::Node permissionArg;

    FileUtilsPermissionModification() {
      exists(string methodName |
        this = API::getTopLevelMember("FileUtils").getAMethodCall(methodName)
      |
        methodName in ["chmod", "chmod_R"] and permissionArg = this.getArgument(0)
        or
        methodName in ["install", "makedirs", "mkdir", "mkdir_p", "mkpath"] and
        permissionArg = this.getKeywordArgument("mode")
        // TODO: defaults for optional args? This may depend on the umask
      )
    }

    override DataFlow::Node getAPermissionNode() { result = permissionArg }
  }
}

/**
 * Classes and predicates for modeling the core `Dir` module.
 */
module Dir {
  /**
   * A call to a method on `Dir` that operates on a path as its first argument, and produces file-names.
   * Considered as a `FileNameSource` and a `FileSystemAccess`.
   */
  class DirGlob extends FileSystemAccess::Range, FileNameSource instanceof DataFlow::CallNode {
    DirGlob() {
      this =
        API::getTopLevelMember("Dir")
            .getAMethodCall(["glob", "[]", "children", "each_child", "entries", "foreach"])
    }

    override DataFlow::Node getAPathArgument() { result = super.getArgument(0) }
  }

  /**
   * A call to a method on `Dir` that operates on a path as its first argument, considered as a `FileSystemAccess`.
   */
  class DirPathAccess extends FileSystemAccess::Range instanceof DataFlow::CallNode {
    DirPathAccess() {
      this =
        API::getTopLevelMember("Dir")
            .getAMethodCall([
                "chdir", "chroot", "delete", "empty?", "exist?", "exists?", "mkdir", "new", "open",
                "rmdir", "unlink"
              ])
    }

    override DataFlow::Node getAPathArgument() { result = super.getArgument(0) }
  }
  // TODO: Model that `(Dir.new "foo").each { |f| ... }` yields a filename (and some other public methods)
}
