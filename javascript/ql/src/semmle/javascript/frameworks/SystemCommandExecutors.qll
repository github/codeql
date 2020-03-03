/**
 * Provides concrete classes for data-flow nodes that execute an
 * operating system command, for instance by spawning a new process.
 */

import javascript

private class SystemCommandExecutors extends SystemCommandExecution, DataFlow::InvokeNode {
  int cmdArg;
  int optionsArg; // either a positive number representing the n'th argument, or a negative number representing the n'th last argument (e.g. -2 is the second last argument).
  boolean shell;
  boolean sync;

  SystemCommandExecutors() {
    exists(string mod, DataFlow::SourceNode callee |
      exists(string method |
        mod = "cross-spawn" and method = "sync" and cmdArg = 0 and shell = false and optionsArg = -1
        or
        mod = "execa" and
        optionsArg = -1 and
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
          mod = "cross-spawn" and cmdArg = 0 and optionsArg = -1
          or
          mod = "cross-spawn-async" and cmdArg = 0 and optionsArg = -1
          or
          mod = "exec-async" and cmdArg = 0 and optionsArg = -1
          or
          mod = "execa" and cmdArg = 0 and optionsArg = -1
        )
        or
        shell = true and
        (
          mod = "exec" and
          optionsArg = -2 and
          cmdArg = 0
          or
          mod = "remote-exec" and cmdArg = 1 and optionsArg = -1
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

  override DataFlow::Node getArgumentList() { shell = false and result = getArgument(1) }

  override predicate isSync() { sync = true }

  override DataFlow::Node getOptionsArg() {
    (
      if optionsArg < 0
      then
        result = getArgument(getNumArgument() + optionsArg) and
        getNumArgument() + optionsArg > cmdArg
      else result = getArgument(optionsArg)
    ) and
    not result.getALocalSource() instanceof DataFlow::FunctionNode and // looks like callback
    not result.getALocalSource() instanceof DataFlow::ArrayCreationNode // looks like argumentlist
  }
}

/**
 * Gets a boolean reflecting if the name ends with "sync" or "Sync".
 */
bindingset[name]
private boolean getSync(string name) {
  if name.suffix(name.length() - 4) = "Sync" or name.suffix(name.length() - 4) = "sync"
  then result = true
  else result = false
}
