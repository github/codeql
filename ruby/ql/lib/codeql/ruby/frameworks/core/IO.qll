/**
 * Provides modeling for the `IO` module.
 */

private import codeql.ruby.ApiGraphs
private import codeql.ruby.Concepts
private import codeql.ruby.DataFlow
private import codeql.ruby.controlflow.CfgNodes
private import codeql.ruby.frameworks.Files as Files
private import internal.IOOrFile

/** Provides modeling for the `IO` class. */
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
    IOInstance() { this = [ioInstance(), fileInstance()] }
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
  class IOReader = Readers::IOReader;

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
  class IOWriter = Writers::IOWriter;

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
  class FileReader = Readers::FileReader;

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
  class FileWriter = Writers::FileWriter;

  /**
   * A system command executed via the `IO.popen` method.
   * Signature:
   * ```
   * popen([env,] cmd, mode="r" [, opt]) -> io
   * popen([env,] cmd, mode="r" [, opt]) {|io| block } -> obj
   * ```
   * `IO.popen` does different things based on the value of `cmd`:
   * ```
   * "-"                                      : fork
   * commandline                              : command line string which is passed to a shell
   * [env, cmdname, arg1, ..., opts]          : command name and zero or more arguments (no shell)
   * [env, [cmdname, argv0], arg1, ..., opts] : command name, argv[0] and zero or more arguments (no shell)
   * (env and opts are optional.)
   * ```
   * Examples:
   * ```ruby
   * IO.popen("cat foo.txt | tail")
   * IO.popen({some_env_var: "123"}, "cat foo.txt | tail")
   * IO.popen(["cat", "foo.txt"])
   * IO.popen([{some_env_var: "123"}, "cat", "foo.txt"])
   * IO.popen([["cat", "argv0"], "foo.txt"])
   * IO.popen([{some_env_var: "123"}, ["cat", "argv0"], "foo.txt"])
   * ```
   * Ruby documentation: https://docs.ruby-lang.org/en/3.1/IO.html#method-c-popen
   */
  class POpenCall extends SystemCommandExecution::Range instanceof DataFlow::CallNode {
    POpenCall() { this = API::getTopLevelMember("IO").getAMethodCall("popen") }

    override DataFlow::Node getAnArgument() { this.argument(result, _) }

    override predicate isShellInterpreted(DataFlow::Node arg) { this.argument(arg, true) }

    /**
     * Holds if `arg` is an argument to this call. `shell` is true if the argument is passed to a subshell.
     */
    private predicate argument(DataFlow::Node arg, boolean shell) {
      exists(ExprCfgNode n | n = arg.asExpr() |
        // Exclude any hash literal arguments, which are likely to be environment variables or options.
        not n instanceof ExprNodes::HashLiteralCfgNode and
        not n instanceof ExprNodes::ArrayLiteralCfgNode and
        (
          // IO.popen({var: "a"}, "cmd", {some: :opt})
          arg = super.getArgument([0, 1]) and
          // We over-approximate by assuming a subshell if the argument isn't an array or "-".
          // This increases the sensitivity of the CommandInjection query at the risk of some FPs.
          if n.getConstantValue().getString() = "-" then shell = false else shell = true
          or
          // IO.popen([{var: "b"}, "cmd", "arg1", "arg2", {some: :opt}])
          // IO.popen({var: "a"}, ["cmd", "arg1", "arg2", {some: :opt}])
          shell = false and
          exists(ExprNodes::ArrayLiteralCfgNode arr | super.getArgument([0, 1]).asExpr() = arr |
            n = arr.getAnArgument()
            or
            // IO.popen([{var: "b"}, ["cmd", "argv0"], "arg1", "arg2", {some: :opt}])
            // IO.popen([["cmd", "argv0"], "arg1", "arg2", {some: :opt}])
            n = arr.getArgument([0, 1]).(ExprNodes::ArrayLiteralCfgNode).getArgument(0)
          )
        )
      )
    }
  }
}
