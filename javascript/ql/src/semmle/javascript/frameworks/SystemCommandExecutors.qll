/**
 * Provides concrete classes for data-flow nodes that execute an
 * operating system command, for instance by spawning a new process.
 */

import javascript

private class SystemCommandExecutors extends SystemCommandExecution, DataFlow::InvokeNode {
  int cmdArg;

  SystemCommandExecutors() {
    exists(string mod, DataFlow::SourceNode callee |
      exists(string method |
        mod = "cross-spawn" and method = "sync" and cmdArg = 0
        or
        mod = "execa" and
        (
          method = "shell" or
          method = "shellSync" or
          method = "stdout" or
          method = "stderr" or
          method = "sync"
        ) and
        cmdArg = 0
      |
        callee = DataFlow::moduleMember(mod, method)
      )
      or
      (
        mod = "cross-spawn" and cmdArg = 0
        or
        mod = "cross-spawn-async" and cmdArg = 0
        or
        mod = "exec" and cmdArg = 0
        or
        mod = "exec-async" and cmdArg = 0
        or
        mod = "execa" and cmdArg = 0
        or
        mod = "remote-exec" and cmdArg = 1
      ) and
      callee = DataFlow::moduleImport(mod)
    |
      this = callee.getACall()
    )
  }

  override DataFlow::Node getACommandArgument() { result = getArgument(cmdArg) }
}
