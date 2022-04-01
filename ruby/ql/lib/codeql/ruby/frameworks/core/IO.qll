/**
 * Provides modeling for the `IO` module.
 */

private import codeql.ruby.ApiGraphs
private import codeql.ruby.Concepts
private import codeql.ruby.DataFlow
private import codeql.ruby.controlflow.CfgNodes

/** Provides modeling for the `IO` class. */
module IO {
  /**
   * A system command executed via the `IO.popen` method.
   * Signature:
   * ```
   * popen([env,] cmd, mode="r" [, opt]) -> io
   * popen([env,] cmd, mode="r" [, opt]) {|io| block } -> obj
   * ```
   * `IO.popen` does different things based on the the value of `cmd`:
   * ```
   * "-"                                      : fork
   * commandline                              : command line string which is passed to a shell
   * [env, cmdname, arg1, ..., opts]          : command name and zero or more arguments (no shell)
   * [env, [cmdname, argv0], arg1, ..., opts] : command name, argv[0] and zero or more arguments (no shell)
   * (env and opts are optional.)
   * ```
   * ```ruby
   * IO.popen("cat foo.txt | tail")
   * IO.popen({some_env_var: "123"}, "cat foo.txt | tail")
   * IO.popen(["cat", "foo.txt"])
   * IO.popen([{some_env_var: "123"}, "cat", "foo.txt"])
   * IO.popen([["cat", "argv0"], "foo.txt"])
   * IO.popen([{some_env_var: "123"}, ["cat", "argv0"], "foo.txt"])
   * ```
   * Ruby documentation: https://docs.ruby-lang.org/en/3.1.0/IO.html#method-c-popen
   */
  class POpenCall extends SystemCommandExecution::Range, DataFlow::CallNode {
    POpenCall() { this = API::getTopLevelMember("IO").getAMethodCall("popen") }

    override DataFlow::Node getAnArgument() { this.argument(result, _) }

    override predicate isShellInterpreted(DataFlow::Node arg) { this.argument(arg, true) }

    /**
     * A helper predicate that holds if `arg` is an argument to this call. `shell` is true if the argument is passed to a subshell.
     */
    private predicate argument(DataFlow::Node arg, boolean shell) {
      exists(ExprCfgNode n | n = arg.asExpr() |
        // Exclude any hash literal arguments, which are likely to be environment variables or options.
        not n instanceof ExprNodes::HashLiteralCfgNode and
        not n instanceof ExprNodes::ArrayLiteralCfgNode and
        (
          // IO.popen({var: "a"}, "cmd", {some: :opt})
          arg = this.getArgument([0, 1]) and
          // We over-approximate by assuming a subshell if the argument isn't an array or "-".
          // This increases the sensitivity of the CommandInjection query at the risk of some FPs.
          if n.getConstantValue().getString() = "-" then shell = false else shell = true
          or
          // IO.popen({var: "a"}, [{var: "b"}, "cmd", "arg1", "arg2", {some: :opt}])
          shell = false and
          exists(ExprNodes::ArrayLiteralCfgNode arr | this.getArgument([0, 1]).asExpr() = arr |
            n = arr.getAnArgument()
            or
            // IO.popen({var: "a"}, [{var: "b"}, ["cmd", "argv0"], "arg1", "arg2", {some: :opt}])
            n = arr.getArgument(0).(ExprNodes::ArrayLiteralCfgNode).getArgument(0)
          )
        )
      )
    }
  }
}
