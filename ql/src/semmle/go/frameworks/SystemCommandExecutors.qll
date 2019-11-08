/**
 * Provides concrete classes for data-flow nodes that execute an
 * operating system command, for instance by spawning a new process.
 */

import go

private class SystemCommandExecutors extends SystemCommandExecution::Range, DataFlow::CallNode {
  int cmdArg;

  SystemCommandExecutors() {
    exists(string pkg, string name | this.getTarget().hasQualifiedName(pkg, name) |
      pkg = "os" and name = "StartProcess" and cmdArg = 0
      or
      // assume that if a `Cmd` is instantiated it will be run
      pkg = "os/exec" and name = "Command" and cmdArg = 0
      or
      pkg = "os/exec" and name = "CommandContext" and cmdArg = 1
    )
  }

  override DataFlow::Node getCommandName() { result = this.getArgument(cmdArg) }
}

/**
 * A call to the `Command` function from the [go-sh](https://github.com/codeskyblue/go-sh)
 * package, viewed as a system-command execution.
 */
private class GoShCommandExecution extends SystemCommandExecution::Range, DataFlow::CallNode {
  GoShCommandExecution() {
    getTarget().hasQualifiedName("github.com/codeskyblue/go-sh", "Command")
  }

  override DataFlow::Node getCommandName() { result = this.getArgument(0) }
}
