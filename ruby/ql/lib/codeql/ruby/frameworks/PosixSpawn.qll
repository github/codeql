/**
 * Provides modeling for the `posix-spawn` gem.
 * Version: 0.3.15
 */

private import codeql.ruby.Concepts
private import codeql.ruby.ApiGraphs
private import codeql.ruby.DataFlow
private import codeql.ruby.controlflow.CfgNodes

/**
 * Provides modeling for the `posix-spawn` gem.
 * Version: 0.3.15
 */
module PosixSpawn {
  private API::Node posixSpawnModule() {
    result = API::getTopLevelMember("POSIX").getMember("Spawn")
  }

  /**
   * A call to `POSIX::Spawn::Child.new` or `POSIX::Spawn::Child.build`.
   */
  class ChildCall extends SystemCommandExecution::Range instanceof DataFlow::CallNode {
    ChildCall() {
      this =
        [
          posixSpawnModule().getMember("Child").getAMethodCall("build"),
          posixSpawnModule().getMember("Child").getAnInstantiation()
        ]
    }

    override DataFlow::Node getAnArgument() {
      result = super.getArgument(_) and not result.asExpr() instanceof ExprNodes::PairCfgNode
    }

    override predicate isShellInterpreted(DataFlow::Node arg) { none() }
  }

  /**
   * A call to `POSIX::Spawn.spawn` or a related method.
   */
  class SystemCall extends SystemCommandExecution::Range instanceof DataFlow::CallNode {
    SystemCall() {
      this =
        posixSpawnModule()
            .getAMethodCall(["spawn", "fspawn", "popen4", "pspawn", "system", "_pspawn", "`"])
    }

    override DataFlow::Node getAnArgument() { this.argument(result) }

    // From the docs:
    // When only command is given and includes a space character, the command
    // text is executed by the system shell interpreter.
    // This means the following signatures are shell interpreted:
    //
    // spawn(cmd)
    // spawn(cmd, opts)
    // spawn(env, cmd)
    // spawn(env, cmd, opts)
    //
    // env and opts will be hashes. We over-approximate by assuming the argument
    // is shell interpreted unless there is another argument with a string
    // constant value.
    override predicate isShellInterpreted(DataFlow::Node arg) {
      this.argument(arg) and
      not exists(DataFlow::Node otherArg |
        otherArg != arg and
        this.argument(otherArg) and
        otherArg.asExpr().getConstantValue().isString(_)
      )
    }

    private predicate argument(DataFlow::Node arg) {
      arg = super.getArgument(_) and
      not arg.asExpr() instanceof ExprNodes::HashLiteralCfgNode and
      not arg.asExpr() instanceof ExprNodes::ArrayLiteralCfgNode and
      not arg.asExpr() instanceof ExprNodes::PairCfgNode
    }
  }
}
