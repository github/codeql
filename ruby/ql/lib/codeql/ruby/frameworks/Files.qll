/**
 * Provides classes for working with file system libraries.
 */

private import ruby
private import codeql.ruby.Concepts
private import codeql.ruby.ApiGraphs
private import codeql.ruby.DataFlow
private import codeql.ruby.frameworks.Core
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
  arg.getConstantValue().getStringlikeValue().charAt(0) = "|"
}

private DataFlow::Node fileInstanceInstantiation() {
  result = API::getTopLevelMember("File").getAnInstantiation()
  or
  result = API::getTopLevelMember("File").getAMethodCall(["open", "try_convert"])
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

abstract private class IOOrFileMethodCall extends DataFlow::CallNode {
  // TODO: Currently this only handles class method calls.
  // Can we infer a path argument for instance method calls?
  // e.g. by tracing back to the instantiation of that instance
  DataFlow::Node getAPathArgumentImpl() {
    result = this.getArgument(0) and this.getReceiverKind() = "class"
  }

  /**
   * Holds if this call appears to read/write from/to a spawned subprocess,
   * rather than to/from a file.
   */
  predicate spawnsSubprocess() {
    pathArgSpawnsSubprocess(this.getAPathArgumentImpl().asExpr().getExpr())
  }

  /** Gets the API used to perform this call, either "IO" or "File" */
  abstract string getApi();

  /** DEPRECATED: Alias for getApi */
  deprecated string getAPI() { result = this.getApi() }

  /** Gets a node representing the data read or written by this call */
  abstract DataFlow::Node getADataNodeImpl();

  /** Gets a string representation of the receiver kind, either "class" or "instance". */
  abstract string getReceiverKind();
}

/**
 * A method call that performs a read using either the `IO` or `File` classes.
 */
private class IOOrFileReadMethodCall extends IOOrFileMethodCall {
  private string api;
  private string receiverKind;

  IOOrFileReadMethodCall() {
    exists(string methodName | methodName = this.getMethodName() |
      // e.g. `{IO,File}.readlines("foo.txt")`
      receiverKind = "class" and
      methodName = ["binread", "foreach", "read", "readlines"] and
      api = ["IO", "File"] and
      this = API::getTopLevelMember(api).getAMethodCall(methodName)
      or
      // e.g. `{IO,File}.new("foo.txt", "r").getc`
      receiverKind = "interface" and
      (
        methodName =
          [
            "getbyte", "getc", "gets", "pread", "read", "read_nonblock", "readbyte", "readchar",
            "readline", "readlines", "readpartial", "sysread"
          ] and
        (
          this.getReceiver() = ioInstance() and api = "IO"
          or
          this.getReceiver() = fileInstance() and api = "File"
        )
      )
    )
  }

  override string getApi() { result = api }

  /** DEPRECATED: Alias for getApi */
  deprecated override string getAPI() { result = this.getApi() }

  override DataFlow::Node getADataNodeImpl() { result = this }

  override string getReceiverKind() { result = receiverKind }
}

/**
 * A method call that performs a write using either the `IO` or `File` classes.
 */
private class IOOrFileWriteMethodCall extends IOOrFileMethodCall {
  private string api;
  private string receiverKind;
  private DataFlow::Node dataNode;

  IOOrFileWriteMethodCall() {
    exists(string methodName | methodName = this.getMethodName() |
      // e.g. `{IO,File}.write("foo.txt", "hello\n")`
      receiverKind = "class" and
      api = ["IO", "File"] and
      this = API::getTopLevelMember(api).getAMethodCall(methodName) and
      methodName = ["binwrite", "write"] and
      dataNode = this.getArgument(1)
      or
      // e.g. `{IO,File}.new("foo.txt", "a+).puts("hello")`
      receiverKind = "interface" and
      (
        this.getReceiver() = ioInstance() and api = "IO"
        or
        this.getReceiver() = fileInstance() and api = "File"
      ) and
      (
        methodName = ["<<", "print", "putc", "puts", "syswrite", "pwrite", "write_nonblock"] and
        dataNode = this.getArgument(0)
        or
        // Any argument to these methods may be written as data
        methodName = ["printf", "write"] and dataNode = this.getArgument(_)
      )
    )
  }

  override string getApi() { result = api }

  /** DEPRECATED: Alias for getApi */
  deprecated override string getAPI() { result = this.getApi() }

  override DataFlow::Node getADataNodeImpl() { result = dataNode }

  override string getReceiverKind() { result = receiverKind }
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

  /**
   * A `DataFlow::CallNode` that reads data using the `IO` class. For example,
   * the `read` and `readline` calls in:
   *
   * ```rb
   * # invokes the `date` shell command as a subprocess, returning its output as a string
   * IO.read("|date")
   *
   * # reads from the file `foo.txt`, returning its first line as a string
   * IO.new(IO.sysopen("foo.txt")).readline
   * ```
   *
   * This class includes only reads that use the `IO` class directly, not those
   * that use a subclass of `IO` such as `File`.
   */
  class IOReader extends IOOrFileReadMethodCall {
    IOReader() { this.getApi() = "IO" }
  }

  /**
   * A `DataFlow::CallNode` that writes data using the `IO` class. For example,
   * the `write` and `puts` calls in:
   *
   * ```rb
   * # writes the string `hello world` to the file `foo.txt`
   * IO.write("foo.txt", "hello world")
   *
   * # appends the string `hello again\n` to the file `foo.txt`
   * IO.new(IO.sysopen("foo.txt", "a")).puts("hello again")
   * ```
   *
   * This class includes only writes that use the `IO` class directly, not those
   * that use a subclass of `IO` such as `File`.
   */
  class IOWriter extends IOOrFileWriteMethodCall {
    IOWriter() { this.getApi() = "IO" }
  }

  /**
   * A `DataFlow::CallNode` that reads data to the filesystem using the `IO`
   * or `File` classes. For example, the `IO.read` and `File#readline` calls in:
   *
   * ```rb
   * # reads the file `foo.txt` and returns its contents as a string.
   * IO.read("foo.txt")
   *
   * # reads from the file `foo.txt`, returning its first line as a string
   * File.new("foo.txt").readline
   * ```
   */
  class FileReader extends IOOrFileReadMethodCall, FileSystemReadAccess::Range {
    FileReader() { not this.spawnsSubprocess() }

    override DataFlow::Node getADataNode() { result = this.getADataNodeImpl() }

    override DataFlow::Node getAPathArgument() { result = this.getAPathArgumentImpl() }
  }

  /**
   * A `DataFlow::CallNode` that reads data from the filesystem using the `IO`
   * or `File` classes. For example, the `write` and `puts` calls in:
   *
   * ```rb
   * # writes the string `hello world` to the file `foo.txt`
   * IO.write("foo.txt", "hello world")
   *
   * # appends the string `hello again\n` to the file `foo.txt`
   * File.new("foo.txt", "a").puts("hello again")
   * ```
   */
  class FileWriter extends IOOrFileWriteMethodCall, FileSystemWriteAccess::Range {
    FileWriter() { not this.spawnsSubprocess() }

    override DataFlow::Node getADataNode() { result = this.getADataNodeImpl() }

    override DataFlow::Node getAPathArgument() { result = this.getAPathArgumentImpl() }
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
