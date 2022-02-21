/**
 * Provides modeling for the `Open3` library.
 */

private import codeql.ruby.AST
private import codeql.ruby.DataFlow
private import codeql.ruby.ApiGraphs
private import codeql.ruby.frameworks.Stdlib
private import codeql.ruby.Concepts

/**
 * Provides modeling for the `Open3` library.
 */
module Open3 {
  /**
   * A system command executed via one of the `Open3` methods.
   * These methods take the same argument forms as `Kernel.system`.
   * See `KernelSystemCall` for details.
   */
  class Open3Call extends SystemCommandExecution::Range {
    MethodCall methodCall;

    Open3Call() {
      this.asExpr().getExpr() = methodCall and
      this =
        API::getTopLevelMember("Open3")
            .getAMethodCall(["popen3", "popen2", "popen2e", "capture3", "capture2", "capture2e"])
    }

    override DataFlow::Node getAnArgument() {
      result.asExpr().getExpr() = methodCall.getAnArgument()
    }

    override predicate isShellInterpreted(DataFlow::Node arg) {
      // These Open3 methods invoke a subshell if you provide a single string as argument
      methodCall.getNumberOfArguments() = 1 and arg.asExpr().getExpr() = methodCall.getAnArgument()
    }
  }

  /**
   * A pipeline of system commands constructed via one of the `Open3` methods.
   * These methods accept a variable argument list of commands.
   * Commands can be in any form supported by `Kernel.system`. See `KernelSystemCall` for details.
   * ```ruby
   * Open3.pipeline("cat foo.txt", "tail")
   * Open3.pipeline(["cat", "foo.txt"], "tail")
   * Open3.pipeline([{}, "cat", "foo.txt"], "tail")
   * Open3.pipeline([["cat", "cat"], "foo.txt"], "tail")
   */
  class Open3PipelineCall extends SystemCommandExecution::Range {
    MethodCall methodCall;

    Open3PipelineCall() {
      this.asExpr().getExpr() = methodCall and
      this =
        API::getTopLevelMember("Open3")
            .getAMethodCall([
                "pipeline_rw", "pipeline_r", "pipeline_w", "pipeline_start", "pipeline"
              ])
    }

    override DataFlow::Node getAnArgument() {
      result.asExpr().getExpr() = methodCall.getAnArgument()
    }

    override predicate isShellInterpreted(DataFlow::Node arg) {
      // A command in the pipeline is executed in a subshell if it is given as a single string argument.
      arg.asExpr().getExpr() instanceof StringlikeLiteral and
      arg.asExpr().getExpr() = methodCall.getAnArgument()
    }
  }
}
