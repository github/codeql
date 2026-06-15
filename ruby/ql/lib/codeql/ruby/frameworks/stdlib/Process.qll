/**
 * Provides modeling for the `Process` library.
 */

private import codeql.ruby.Concepts
private import codeql.ruby.DataFlow
private import codeql.ruby.controlflow.CfgNodes
private import codeql.ruby.frameworks.core.Kernel

/**
 * Provides modeling for the `Process` library.
 */
module Process {
  /**
   * A call to `Process.spawn`.
   * ```rb
   * Process.spawn("tar xf ruby-2.0.0-p195.tar.bz2")
   * Process.spawn({"ENV" => "VAR"}, "echo",  "hi")
   * ```
   */
  class SpawnCall extends SystemCommandExecution::Range instanceof DataFlow::CallNode {
    SpawnCall() { this = DataFlow::getConstant(["Process", "PTY"]).getAMethodCall("spawn") }

    // The command can be argument 0 or 1
    // Options can be specified after the command, and we want to exclude those.
    override DataFlow::Node getAnArgument() {
      result = super.getArgument([0, 1]) and not result.asExpr() instanceof ExprNodes::PairCfgNode
    }

    override predicate isShellInterpreted(DataFlow::Node arg) {
      // Process.spawn invokes a subshell if you provide a single string as argument
      super.getNumberOfArguments() = 1 and arg = this.getAnArgument()
    }
  }

  /**
   * A system command executed via the `Process.exec` method.
   */
  class ExecCall extends SystemCommandExecution::Range instanceof DataFlow::CallNode {
    ExecCall() { this = DataFlow::getConstant("Process").getAMethodCall("exec") }

    override DataFlow::Node getAnArgument() { result = super.getArgument(_) }

    override predicate isShellInterpreted(DataFlow::Node arg) {
      // Process.exec invokes a subshell if you provide a single string as argument
      super.getNumberOfArguments() = 1 and arg = this.getAnArgument()
    }
  }
}
