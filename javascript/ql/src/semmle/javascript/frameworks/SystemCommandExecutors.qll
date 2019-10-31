/**
 * Provides concrete classes for data-flow nodes that execute an
 * operating system command, for instance by spawning a new process.
 */

import javascript

private class SystemCommandExecutors extends SystemCommandExecution, DataFlow::InvokeNode {
  int cmdArg;

  boolean shell;

  SystemCommandExecutors() {
    exists(string mod, DataFlow::SourceNode callee |
      exists(string method |
        mod = "cross-spawn" and method = "sync" and cmdArg = 0 and shell = false
        or
        mod = "execa" and
        (
          shell = false and
          (
            method = "shell" or
            method = "shellSync" or
            method = "stdout" or
            method = "stderr" or
            method = "sync"
          )
          or
          shell = true and
          (method = "command" or method = "commandSync")
        ) and
        cmdArg = 0
      |
        callee = DataFlow::moduleMember(mod, method)
      )
      or
      (
        shell = false and
        (
          mod = "cross-spawn" and cmdArg = 0
          or
          mod = "cross-spawn-async" and cmdArg = 0
          or
          mod = "exec-async" and cmdArg = 0
          or
          mod = "execa" and cmdArg = 0
        )
        or
        shell = true and
        (
          mod = "exec" and
          cmdArg = 0
          or
          mod = "remote-exec" and cmdArg = 1
        )
      ) and
      callee = DataFlow::moduleImport(mod)
    |
      this = callee.getACall()
    )
  }

  override DataFlow::Node getACommandArgument() { result = getArgument(cmdArg) }

  override predicate isShellInterpreted(DataFlow::Node arg) {
    arg = getACommandArgument() and shell = true
  }
}
