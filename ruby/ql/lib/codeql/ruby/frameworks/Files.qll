/**
 * Provides classes for working with file system libraries.
 */

private import ruby
private import codeql.ruby.Concepts
private import codeql.ruby.ApiGraphs
private import codeql.ruby.DataFlow
private import codeql.ruby.frameworks.StandardLibrary
private import codeql.ruby.dataflow.FlowSummary

private DataFlow::Node ioInstanceInstantiation() {
  result = API::getTopLevelMember("IO").getAnInstantiation() or
  result = API::getTopLevelMember("IO").getAMethodCall(["for_fd", "open", "try_convert"])
}

private DataFlow::Node ioInstance() {
  result = ioInstanceInstantiation()
  or
  exists(DataFlow::Node inst |
    inst = ioInstance() and
    inst.(DataFlow::LocalSourceNode).flowsTo(result)
  )
}

// Match some simple cases where a path argument specifies a shell command to
// be executed. For example, the `"|date"` argument in `IO.read("|date")`, which
// will execute a shell command and read its output rather than reading from the
// filesystem.
private predicate pathArgSpawnsSubprocess(Expr arg) {
  arg.(StringlikeLiteral).getValueText().charAt(0) = "|"
}

private DataFlow::Node fileInstanceInstantiation() {
  result = API::getTopLevelMember("File").getAnInstantiation()
  or
  result = API::getTopLevelMember("File").getAMethodCall("open")
  or
  // Calls to `Kernel.open` can yield `File` instances
  result.(KernelMethodCall).getMethodName() = "open" and
  // Assume that calls that don't invoke shell commands will instead open
  // a file.
  not pathArgSpawnsSubprocess(result.(KernelMethodCall).getArgument(0).asExpr().getExpr())
}

private DataFlow::Node fileInstance() {
  result = fileInstanceInstantiation()
  or
  exists(DataFlow::Node inst |
    inst = fileInstance() and
    inst.(DataFlow::LocalSourceNode).flowsTo(result)
  )
}

private string ioFileReaderClassMethodName() {
  result = ["binread", "foreach", "read", "readlines", "try_convert"]
}

private string ioFileReaderInstanceMethodName() {
  result =
    [
      "getbyte", "getc", "gets", "pread", "read", "read_nonblock", "readbyte", "readchar",
      "readline", "readlines", "readpartial", "sysread"
    ]
}

private string ioFileReaderMethodName(boolean classMethodCall) {
  classMethodCall = true and result = ioFileReaderClassMethodName()
  or
  classMethodCall = false and result = ioFileReaderInstanceMethodName()
}

/**
 * Classes and predicates for modeling the core `IO` module.
 */
module IO {
  /**
   * An instance of the `IO` class, for example in
   *
   * ```rb
   * rand = IO.new(IO.sysopen("/dev/random", "r"), "r")
   * rand_data = rand.read(32)
   * ```
   *
   * there are 3 `IOInstance`s - the call to `IO.new`, the assignment
   * `rand = ...`, and the read access to `rand` on the second line.
   */
  class IOInstance extends DataFlow::Node {
    IOInstance() {
      this = ioInstance() or
      this = fileInstance()
    }
  }

  // "Direct" `IO` instances, i.e. cases where there is no more specific
  // subtype such as `File`
  private class IOInstanceStrict extends IOInstance {
    IOInstanceStrict() { this = ioInstance() }
  }

  /**
   * A `DataFlow::CallNode` that reads data using the `IO` class. For example,
   * the `IO.read call in:
   *
   * ```rb
   * IO.read("|date")
   * ```
   *
   * returns the output of the `date` shell command, invoked as a subprocess.
   *
   * This class includes reads both from shell commands and reads from the
   * filesystem. For working with filesystem accesses specifically, see
   * `IOFileReader` or the `FileSystemReadAccess` concept.
   */
  class IOReader extends DataFlow::CallNode {
    private boolean classMethodCall;
    private string api;

    IOReader() {
      // Class methods
      api = ["File", "IO"] and
      classMethodCall = true and
      this = API::getTopLevelMember(api).getAMethodCall(ioFileReaderMethodName(classMethodCall))
      or
      // IO instance methods
      classMethodCall = false and
      api = "IO" and
      exists(IOInstanceStrict ii |
        this.getReceiver() = ii and
        this.getMethodName() = ioFileReaderMethodName(classMethodCall)
      )
      or
      // File instance methods
      classMethodCall = false and
      api = "File" and
      exists(File::FileInstance fi |
        this.getReceiver() = fi and
        this.getMethodName() = ioFileReaderMethodName(classMethodCall)
      )
      // TODO: enumeration style methods such as `each`, `foreach`, etc.
    }

    /**
     * Returns the most specific core class used for this read, `IO` or `File`
     */
    string getAPI() { result = api }

    predicate isClassMethodCall() { classMethodCall = true }
  }

  /**
   * A `DataFlow::CallNode` that reads data from the filesystem using the `IO`
   * class. For example, the `IO.read call in:
   *
   * ```rb
   * IO.read("foo.txt")
   * ```
   *
   * reads the file `foo.txt` and returns its contents as a string.
   */
  class IOFileReader extends IOReader, FileSystemReadAccess::Range {
    IOFileReader() {
      this.getAPI() = "File"
      or
      this.isClassMethodCall() and
      // Assume that calls that don't invoke shell commands will instead
      // read from a file.
      not pathArgSpawnsSubprocess(this.getArgument(0).asExpr().getExpr())
    }

    // TODO: can we infer a path argument for instance method calls?
    // e.g. by tracing back to the instantiation of that instance
    override DataFlow::Node getAPathArgument() {
      result = this.getArgument(0) and this.isClassMethodCall()
    }

    // This class represents calls that return data
    override DataFlow::Node getADataNode() { result = this }
  }
}

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
   * A read using the `File` module, e.g. the `f.read` call in
   *
   * ```rb
   *   f = File.new("foo.txt")
   *   puts f.read()
   * ```
   */
  class FileModuleReader extends IO::IOFileReader {
    FileModuleReader() { this.getAPI() = "File" }
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
      exists(FileInstance fi |
        this.getReceiver() = fi and
        this.getMethodName() = ["path", "to_path"]
      )
    }
  }

  private class FileModulePermissionModification extends FileSystemPermissionModification::Range,
    DataFlow::CallNode {
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

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
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

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[_]" and
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
    DataFlow::CallNode {
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
