/**
 * Provides concrete classes for data-flow nodes that execute an
 * operating system command, for instance by spawning a new process.
 */

import javascript

pragma[noinline]
private predicate execApi(
  string mod, string fn, int cmdArg, int optionsArg, boolean shell, boolean sync
) {
  sync = getSync(fn) and
  (
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
      fn = ["node", "stdout", "stderr", "sync"]
      or
      shell = true and
      fn = ["command", "commandSync", "shell", "shellSync"]
    ) and
    cmdArg = 0
  )
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
  (
    mod = "exec" and
    optionsArg = -2 and
    cmdArg = 0
    or
    mod = "async-execute" and
    optionsArg = 1 and
    cmdArg = 0
  )
}

private class SystemCommandExecutors extends SystemCommandExecution, DataFlow::InvokeNode {
  int cmdArg;
  int optionsArg; // either a positive number representing the n'th argument, or a negative number representing the n'th last argument (e.g. -2 is the second last argument).
  boolean shell;
  boolean sync;

  SystemCommandExecutors() {
    exists(string mod |
      exists(string fn |
        execApi(mod, fn, cmdArg, optionsArg, shell, sync) and
        this = API::moduleImport(mod).getMember(fn).getAnInvocation()
      )
      or
      execApi(mod, cmdArg, optionsArg, shell) and
      sync = false and
      this = API::moduleImport(mod).getAnInvocation()
    )
    or
    this = API::moduleImport("foreground-child").getACall() and
    cmdArg = 0 and
    optionsArg = 1 and
    shell = false and
    sync = true
  }

  override DataFlow::Node getACommandArgument() { result = this.getArgument(cmdArg) }

  override predicate isShellInterpreted(DataFlow::Node arg) {
    arg = this.getACommandArgument() and shell = true
  }

  override DataFlow::Node getArgumentList() { shell = false and result = this.getArgument(1) }

  override predicate isSync() { sync = true }

  override DataFlow::Node getOptionsArg() {
    (
      if optionsArg < 0
      then
        result = this.getArgument(this.getNumArgument() + optionsArg) and
        this.getNumArgument() + optionsArg > cmdArg
      else result = this.getArgument(optionsArg)
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
  if name.matches("%Sync") or name.matches("%sync") then result = true else result = false
}

private class RemoteCommandExecutor extends SystemCommandExecution, DataFlow::InvokeNode {
  int cmdArg;

  RemoteCommandExecutor() {
    this = API::moduleImport("remote-exec").getACall() and
    cmdArg = 1
    or
    exists(API::Node ssh2, API::Node client |
      ssh2 = API::moduleImport("ssh2") and
      client in [ssh2, ssh2.getMember("Client")] and
      this = client.getInstance().getMember("exec").getACall() and
      cmdArg = 0
    )
    or
    exists(API::Node ssh2stream |
      ssh2stream = API::moduleImport("ssh2-streams").getMember("SSH2Stream") and
      this = ssh2stream.getInstance().getMember("exec").getACall() and
      cmdArg = 1
    )
  }

  override DataFlow::Node getACommandArgument() { result = this.getArgument(cmdArg) }

  override predicate isShellInterpreted(DataFlow::Node arg) { arg = this.getACommandArgument() }

  override predicate isSync() { none() }

  override DataFlow::Node getOptionsArg() { none() }
}

private class Opener extends SystemCommandExecution, DataFlow::InvokeNode {
  Opener() { this = API::moduleImport("opener").getACall() }

  override DataFlow::Node getACommandArgument() { result = this.getOptionArgument(1, "command") }

  override predicate isShellInterpreted(DataFlow::Node arg) { none() }

  override predicate isSync() { none() }

  override DataFlow::Node getOptionsArg() { none() }
}
