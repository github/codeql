/**
 * Provides modeling for concepts shared across `File` and `IO`.
 */

private import codeql.ruby.AST
private import codeql.ruby.DataFlow
private import codeql.ruby.ApiGraphs
private import codeql.ruby.frameworks.Files
private import codeql.ruby.frameworks.core.Kernel::Kernel
private import codeql.ruby.Concepts

DataFlow::Node ioInstanceInstantiation() {
  result = API::getTopLevelMember("IO").getAnInstantiation() or
  result = API::getTopLevelMember("IO").getAMethodCall(["for_fd", "open", "try_convert"])
}

DataFlow::Node ioInstance() {
  result = ioInstanceInstantiation()
  or
  exists(DataFlow::Node inst |
    inst = ioInstance() and
    inst.(DataFlow::LocalSourceNode).flowsTo(result)
  )
}

DataFlow::Node fileInstanceInstantiation() {
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

DataFlow::Node fileInstance() {
  result = fileInstanceInstantiation()
  or
  exists(DataFlow::Node inst |
    inst = fileInstance() and
    inst.(DataFlow::LocalSourceNode).flowsTo(result)
  )
}

abstract class IOOrFileMethodCall extends DataFlow::CallNode {
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

  /** Gets a node representing the data read or written by this call */
  abstract DataFlow::Node getADataNodeImpl();

  /** Gets a string representation of the receiver kind, either "class" or "instance". */
  abstract string getReceiverKind();
}

// Match some simple cases where a path argument specifies a shell command to
// be executed. For example, the `"|date"` argument in `IO.read("|date")`, which
// will execute a shell command and read its output rather than reading from the
// filesystem.
predicate pathArgSpawnsSubprocess(Expr arg) {
  arg.getConstantValue().getStringlikeValue().charAt(0) = "|"
}

/**
 * A method call that performs a read using either the `IO` or `File` classes.
 */
class IOOrFileReadMethodCall extends IOOrFileMethodCall {
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
          this.getReceiver() = fileInstance() and api = "File"
          or
          this.getReceiver() = ioInstance() and api = "IO"
        )
      )
    )
  }

  override string getApi() { result = api }

  override DataFlow::Node getADataNodeImpl() { result = this }

  override string getReceiverKind() { result = receiverKind }
}

/**
 * A method call that performs a write using either the `IO` or `File` classes.
 */
class IOOrFileWriteMethodCall extends IOOrFileMethodCall {
  private string api;
  private string receiverKind;
  private DataFlow::Node dataNode;

  IOOrFileWriteMethodCall() {
    exists(string methodName | methodName = this.getMethodName() |
      // e.g. `{IO,File}.write("foo.txt", "hello\n")`
      receiverKind = "class" and
      api = ["IO", "File"] and
      this = API::getTopLevelMember(api).getAMethodCall(methodName) and
      methodName = ["binwrite", "write", "atomic_write"] and
      dataNode = this.getArgument(1)
      or
      // e.g. `{IO,File}.new("foo.txt", "a+).puts("hello")`
      receiverKind = "interface" and
      (
        this.getReceiver() = fileInstance() and api = "File"
        or
        this.getReceiver() = ioInstance() and api = "IO"
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

  override DataFlow::Node getADataNodeImpl() { result = dataNode }

  override string getReceiverKind() { result = receiverKind }
}

module Readers {
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
}

module Writers {
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
