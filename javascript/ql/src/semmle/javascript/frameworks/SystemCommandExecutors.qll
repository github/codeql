/**
 * Provides concrete classes for data-flow nodes that execute an
 * operating system command, for instance by spawning a new process.
 */

import javascript

private class SystemCommandExecutors extends SystemCommandExecution, DataFlow::InvokeNode {
  int cmdArg;

  boolean shell;
  boolean sync;

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
        callee = DataFlow::moduleMember(mod, method) and
        sync = getSync(method)
      )
      or
      sync = false and
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

  override predicate isSync() {
    sync = true
  }
}

/**
 * Gets a boolean reflecting if the name ends with "sync" or "Sync". 
 */ 
bindingset[name]
private boolean getSync(string name) {
  if name.suffix(name.length() - 4) = "Sync" or name.suffix(name.length() - 4) = "sync" then
    result = true
  else
    result = false
}