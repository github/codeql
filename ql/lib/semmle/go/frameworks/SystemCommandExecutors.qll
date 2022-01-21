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
  ShellLike shellCommand;

  ShellOrSudoExecution() {
    this instanceof SystemCommandExecution and
    shellCommand = this.getAnArgument().getAPredecessor*() and
    not hasSafeSubcommand(shellCommand.getStringValue(), this.getAnArgument().getStringValue())
  }

  override DataFlow::Node getCommandName() { result = this.getAnArgument() }

  override predicate doubleDashIsSanitizing() { shellCommand.getStringValue().matches("%git") }
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
      name = ["Exec", "ForkExec", "StartProcess", "CreateProcess"] and
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
    exists(string packagePath | packagePath = package("github.com/codeskyblue/go-sh", "") |
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
      this.getTarget().hasQualifiedName(packagePath, "Command")
    )
  }

  override DataFlow::Node getCommandName() { result = this.getArgument(0) }
}

/**
 * Provides classes for working with the
 * [golang.org/x/crypto/ssh](https://pkg.go.dev/golang.org/x/crypto/ssh) package.
 */
module CryptoSsh {
  /** Gets the package path `golang.org/x/crypto/ssh`. */
  string packagePath() { result = package("golang.org/x/crypto", "ssh") }

  /**
   * A call to a method on a `Session` object from the [ssh](golang.org/x/crypto/ssh)
   * package, viewed as a system-command execution.
   */
  private class SshCommandExecution extends SystemCommandExecution::Range, DataFlow::CallNode {
    SshCommandExecution() {
      // Catch method calls on the `Session` object:
      exists(Method method, string methodName |
        methodName = ["CombinedOutput", "Output", "Run", "Start"]
      |
        method.hasQualifiedName(packagePath(), "Session", methodName) and
        this = method.getACall()
      )
    }

    override DataFlow::Node getCommandName() { result = this.getArgument(0) }
  }
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
  result =
    [
      "sudo", "sudo_root", "priv", "calife", "ssu", "su1", "op", "sudowin", "sudown", "chroot",
      "fakeroot", "fakeroot-sysv", "su", "fakeroot-tcp", "fstab-decode", "jrunscript", "nohup",
      "parallel", "find", "pkexec", "sg", "sem", "runcon", "sudoedit", "runuser", "stdbuf",
      "system", "timeout", "xargs", "time", "awk", "gawk", "mawk", "nawk", "doas", "git", "access",
      "vsys", "userv", "sus", "super"
    ]
}

/**
 * Excuse git commands other than those that interact with remotes, as only those currently
 * take arbitrary commands to run on the remote host as arguments.
 */
bindingset[command, subcommand]
private predicate hasSafeSubcommand(string command, string subcommand) {
  command.matches("%git") and
  // All git subcommands except for clone, fetch, ls-remote, pull and fetch-pack
  subcommand in [
      "add", "am", "archive", "bisect", "branch", "bundle", "checkout", "cherry-pick", "citool",
      "clean", "commit", "describe", "diff", "format-patch", "gc", "gitk", "grep", "gui", "init",
      "log", "merge", "mv", "notes", "push", "range-diff", "rebase", "reset", "restore", "revert",
      "rm", "shortlog", "show", "sparse-checkout", "stash", "status", "submodule", "switch", "tag",
      "worktree", "fast-export", "fast-import", "filter-branch", "mergetool", "pack-refs", "prune",
      "reflog", "remote", "repack", "replace", "annotate", "blame", "bugreport", "count-objects",
      "difftool", "fsck", "gitweb", "help", "instaweb", "merge-tree", "rerere", "show-branch",
      "verify-commit", "verify-tag", "whatchanged", "archimport", "cvsexportcommit", "cvsimport",
      "cvsserver", "imap-send", "p4", "quiltimport", "request-pull", "send-email", "apply",
      "checkout-index", "commit-graph", "commit-tree", "hash-object", "index-pack", "merge-file",
      "merge-index", "mktag", "mktree", "multi-pack-index", "pack-objects", "prune-packed",
      "read-tree", "symbolic-ref", "unpack-objects", "update-index", "update-ref", "write-tree",
      "cat-file", "cherry", "diff-files", "diff-index", "diff-tree", "for-each-ref",
      "get-tar-commit-id", "ls-files", "ls-tree", "merge-base", "name-rev", "pack-redundant",
      "rev-list", "rev-parse", "show-index", "show-ref", "unpack-file", "var", "verify-pack",
      "http-backend", "send-pack", "update-server-info", "check-attr", "check-ignore",
      "check-mailmap", "check-ref-format", "column", "credential", "credential-cache",
      "credential-store", "fmt-merge-msg", "interpret-trailers", "mailinfo", "mailsplit",
      "merge-one-file", "patch-id"
    ]
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
  result =
    [
      "bash", "sh", "elvish", "oh", "ion", "ksh", "rksh", "tksh", "mksh", "nu", "oksh", "osh",
      "sh.distrib", "shpp", "xiki", "xonsh", "yash", "env", "rbash", "dash", "zsh", "csh", "tcsh",
      "fish", "pwsh"
    ]
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
  result = ["python", "php", "ruby", "perl", "node", "nodejs"]
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

private string getASshCommand() { result = ["ssh", "ssh-argv0", "putty.exe", "kitty.exe"] }

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
