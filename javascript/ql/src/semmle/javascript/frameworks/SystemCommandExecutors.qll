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
        or
        mod = "execa" and
        method = "node" and
        cmdArg = 0 and
        optionsArg = 1 and
        shell = false
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
        mod = "exec" and
        optionsArg = -2 and
        cmdArg = 0
      ) and
      callee = DataFlow::moduleImport(mod)
    |
      this = callee.getACall()
    )
    or
    this = DataFlow::moduleImport("foreground-child").getACall() and
    cmdArg = 0 and
    optionsArg = 1 and
    shell = false and
    sync = true
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

private class RemoteCommandExecutor extends SystemCommandExecution, DataFlow::InvokeNode {
  int cmdArg;

  RemoteCommandExecutor() {
    this = DataFlow::moduleImport("remote-exec").getACall() and
    cmdArg = 1
    or
    exists(DataFlow::SourceNode ssh2, DataFlow::SourceNode client |
      ssh2 = DataFlow::moduleImport("ssh2") and
      (client = ssh2 or client = ssh2.getAPropertyRead("Client")) and
      this = client.getAnInstantiation().getAMethodCall("exec") and
      cmdArg = 0
    )
    or
    exists(DataFlow::SourceNode ssh2stream |
      ssh2stream = DataFlow::moduleMember("ssh2-streams", "SSH2Stream") and
      this = ssh2stream.getAnInstantiation().getAMethodCall("exec") and
      cmdArg = 1
    )
  }

  override DataFlow::Node getACommandArgument() { result = getArgument(cmdArg) }

  override predicate isShellInterpreted(DataFlow::Node arg) { arg = getACommandArgument() }

  override predicate isSync() { none() }

  override DataFlow::Node getOptionsArg() { none() }
}

private class Opener extends SystemCommandExecution, DataFlow::InvokeNode {
  Opener() { this = DataFlow::moduleImport("opener").getACall() }

  override DataFlow::Node getACommandArgument() { result = getOptionArgument(1, "command") }

  override predicate isShellInterpreted(DataFlow::Node arg) { none() }

  override predicate isSync() { none() }

  override DataFlow::Node getOptionsArg() { none() }
}
