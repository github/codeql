/**
 * Provides concrete classes for data-flow nodes that execute an
 * operating system command, for instance by spawning a new process.
 */

import javascript

private predicate execApi(string mod, string fn, int cmdArg, int optionsArg, boolean shell) {
  mod = "cross-spawn" and
  fn = "sync" and
  cmdArg = 0 and
  shell = false and
  optionsArg = -1
  or
  mod = "execa" and
  optionsArg = -1 and
  (
    shell = false and
    (
      fn = "node" or
      fn = "shell" or
      fn = "shellSync" or
      fn = "stdout" or
      fn = "stderr" or
      fn = "sync"
    )
    or
    shell = true and
    (fn = "command" or fn = "commandSync")
  ) and
  cmdArg = 0
}

private predicate execApi(string mod, int cmdArg, int optionsArg, boolean shell) {
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
}

private class SystemCommandExecutors extends SystemCommandExecution, DataFlow::InvokeNode {
  int cmdArg;
  int optionsArg; // either a positive number representing the n'th argument, or a negative number representing the n'th last argument (e.g. -2 is the second last argument).
  boolean shell;
  boolean sync;

  SystemCommandExecutors() {
    exists(string mod |
      exists(string fn |
        execApi(mod, fn, cmdArg, optionsArg, shell) and
        sync = getSync(fn) and
        this = API::moduleImport(mod).getMember(fn).getReturn().getAUse()
      )
      or
      execApi(mod, cmdArg, optionsArg, shell) and
      sync = false and
      this = API::moduleImport(mod).getReturn().getAUse()
    )
    or
    this = API::moduleImport("foreground-child").getReturn().getAUse() and
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
    this = API::moduleImport("remote-exec").getReturn().getAUse() and
    cmdArg = 1
    or
    exists(API::Node ssh2, API::Node client |
      ssh2 = API::moduleImport("ssh2") and
      client in [ssh2, ssh2.getMember("Client")] and
      this = client.getInstance().getMember("exec").getReturn().getAUse() and
      cmdArg = 0
    )
    or
    exists(API::Node ssh2stream |
      ssh2stream = API::moduleImport("ssh2-streams").getMember("SSH2Stream") and
      this = ssh2stream.getInstance().getMember("exec").getReturn().getAUse() and
      cmdArg = 1
    )
  }

  override DataFlow::Node getACommandArgument() { result = getArgument(cmdArg) }

  override predicate isShellInterpreted(DataFlow::Node arg) { arg = getACommandArgument() }

  override predicate isSync() { none() }

  override DataFlow::Node getOptionsArg() { none() }
}

private class Opener extends SystemCommandExecution, DataFlow::InvokeNode {
  Opener() { this = API::moduleImport("opener").getReturn().getAUse() }

  override DataFlow::Node getACommandArgument() { result = getOptionArgument(1, "command") }

  override predicate isShellInterpreted(DataFlow::Node arg) { none() }

  override predicate isSync() { none() }

  override DataFlow::Node getOptionsArg() { none() }
}
