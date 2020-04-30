/**
 * Provides concrete classes for data-flow nodes that execute an
 * operating system command, for instance by spawning a new process.
 */

import go

/**
 * An indirect system-command execution via an argument argument passed to a command interpreter
 * such as a shell, `sudo`, or a programming-language interpreter.
 */
private class ShellOrSudoExecution extends SystemCommandExecution::Range, DataFlow::CallNode {
  ShellOrSudoExecution() {
    this instanceof SystemCommandExecution and
    this.getAnArgument().getAPredecessor*() instanceof ShellLike
  }

  override DataFlow::Node getCommandName() { result = getAnArgument() }
}

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
      or
      // NOTE: syscall.ForkExec exists only on unix.
      // NOTE: syscall.CreateProcess and syscall.CreateProcessAsUser exist only on windows.
      pkg = "syscall" and
      (name = "Exec" or name = "ForkExec" or name = "StartProcess" or name = "CreateProcess") and
      cmdArg = 0
      or
      pkg = "syscall" and
      name = "CreateProcessAsUser" and
      cmdArg = 1
    )
  }

  override DataFlow::Node getCommandName() { result = this.getArgument(cmdArg) }
}

/**
 * A call to the `Command` function, or `Call` or `Command` methods on a `Session` object
 * from the [go-sh](https://github.com/codeskyblue/go-sh) package, viewed as a
 * system-command execution.
 */
private class GoShCommandExecution extends SystemCommandExecution::Range, DataFlow::CallNode {
  GoShCommandExecution() {
    exists(string packagePath | packagePath = "github.com/codeskyblue/go-sh" |
      // Catch method calls on the `Session` object:
      exists(Method method |
        method.hasQualifiedName(packagePath, "Session", "Call")
        or
        method.hasQualifiedName(packagePath, "Session", "Command")
        or
        method.hasQualifiedName(packagePath, "Session", "Exec")
      |
        this = method.getACall()
      )
      or
      // Catch calls to the `Command` function:
      getTarget().hasQualifiedName(packagePath, "Command")
    )
  }

  override DataFlow::Node getCommandName() { result = this.getArgument(0) }
}

/**
 * A call to a method on a `Session` object from the [ssh](golang.org/x/crypto/ssh)
 * package, viewed as a system-command execution.
 */
private class SshCommandExecution extends SystemCommandExecution::Range, DataFlow::CallNode {
  SshCommandExecution() {
    // Catch method calls on the `Session` object:
    exists(Method method, string methodName |
      methodName = "CombinedOutput"
      or
      methodName = "Output"
      or
      methodName = "Run"
      or
      methodName = "Start"
    |
      method.hasQualifiedName("golang.org/x/crypto/ssh", "Session", methodName) and
      this = method.getACall()
    )
  }

  override DataFlow::Node getCommandName() { result = this.getArgument(0) }
}

/**
 * A data-flow node whose string value might refer to a command that interprets (some of)
 * its arguments as commands.
 *
 * Examples include shells, `sudo`, programming-language interpreters, and SSH clients.
 */
private class ShellLike extends DataFlow::Node {
  ShellLike() {
    isSudoOrSimilar(this) or
    isShell(this) or
    isProgrammingLanguageCli(this) or
    isSsh(this)
  }
}

private string getASudoCommand() {
  result = "sudo" or
  result = "sudo_root" or
  result = "su" or
  result = "sudoedit" or
  result = "doas" or
  result = "access" or
  result = "vsys" or
  result = "userv" or
  result = "sus" or
  result = "super" or
  result = "priv" or
  result = "calife" or
  result = "ssu" or
  result = "su1" or
  result = "op" or
  result = "sudowin" or
  result = "sudown" or
  result = "chroot" or
  result = "fakeroot" or
  result = "fakeroot-sysv" or
  result = "fakeroot-tcp" or
  result = "fstab-decode" or
  result = "jrunscript" or
  result = "nohup" or
  result = "parallel" or
  result = "find" or
  result = "pkexec" or
  result = "sg" or
  result = "sem" or
  result = "runcon" or
  result = "runuser" or
  result = "stdbuf" or
  result = "system" or
  result = "timeout" or
  result = "xargs" or
  result = "time" or
  result = "awk" or
  result = "gawk" or
  result = "mawk" or
  result = "nawk"
}

/**
 * A data-flow node whose string value might refer to a command that interprets (some of)
 * its arguments as system commands in a similar manner to `sudo`.
 */
private predicate isSudoOrSimilar(DataFlow::Node node) {
  exists(string regex |
    regex = ".*(^|/)(" + concat(string cmd | cmd = getASudoCommand() | cmd, "|") + ")"
  |
    node.getStringValue().regexpMatch(regex)
  )
}

private string getAShellCommand() {
  result = "bash" or
  result = "sh" or
  result = "sh.distrib" or
  result = "rbash" or
  result = "dash" or
  result = "zsh" or
  result = "csh" or
  result = "tcsh" or
  result = "fish" or
  result = "pwsh" or
  result = "elvish" or
  result = "oh" or
  result = "ion" or
  result = "ksh" or
  result = "rksh" or
  result = "tksh" or
  result = "mksh" or
  result = "nu" or
  result = "oksh" or
  result = "osh" or
  result = "shpp" or
  result = "xiki" or
  result = "xonsh" or
  result = "yash" or
  result = "env"
}

/**
 * A data-flow node whose string value might refer to a shell.
 */
private predicate isShell(DataFlow::Node node) {
  exists(string regex |
    regex = ".*(^|/)(" + concat(string cmd | cmd = getAShellCommand() | cmd, "|") + ")"
  |
    node.getStringValue().regexpMatch(regex)
  )
}

private string getAnInterpreterName() {
  result = "python" or
  result = "php" or
  result = "ruby" or
  result = "perl" or
  result = "node" or
  result = "nodejs"
}

/**
 * A data-flow node whose string value might refer to a programming-language interpreter.
 */
private predicate isProgrammingLanguageCli(DataFlow::Node node) {
  // NOTE: we can encounter cases like /usr/bin/python3.1 or python3.7m
  exists(string regex |
    regex =
      ".*(^|/)(" + concat(string cmd | cmd = getAnInterpreterName() | cmd + "[\\d.\\-vm]*", "|") +
        ")"
  |
    node.getStringValue().regexpMatch(regex)
  )
}

private string getASshCommand() {
  result = "ssh" or result = "ssh-argv0" or result = "putty.exe" or result = "kitty.exe"
}

/**
 * A data-flow node whose string value might refer to an SSH client or similar, whose arguments can be
 * commands that will be executed on the remote host.
 */
private predicate isSsh(DataFlow::Node node) {
  exists(string regex |
    regex = ".*(^|/)(" + concat(string cmd | cmd = getASshCommand() | cmd, "|") + ")"
  |
    node.getStringValue().regexpMatch(regex)
  )
}
