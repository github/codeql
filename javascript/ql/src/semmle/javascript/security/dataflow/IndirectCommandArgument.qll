/**
 * Provides predicates for reasoning about indirect command arguments.
 */

import javascript

/**
 * Holds if `shell arg <cmd>` runs `<cmd>` as a shell command.
 *
 * That is, either `shell` is a Unix shell (`sh` or similar) and
 * `arg` is `"-c"`, or `shell` is `cmd.exe` and `arg` is `"/c"`.
 */
private predicate shellCmd(ConstantString shell, string arg) {
  exists(string s | s = shell.getStringValue() |
    (s = "sh" or s = "bash" or s = "/bin/sh" or s = "/bin/bash") and
    arg = "-c"
  )
  or
  exists(string s | s = shell.getStringValue().toLowerCase() |
    (s = "cmd" or s = "cmd.exe") and
    (arg = "/c" or arg = "/C")
  )
}

/**
 * Data flow configuration for tracking string literals that look like they
 * may refer to an operating-system shell, and array literals that may end up being
 * interpreted as argument lists for system commands.
 */
private class ArgumentListTracking extends DataFlow::Configuration {
  ArgumentListTracking() { this = "ArgumentListTracking" }

  override predicate isSource(DataFlow::Node nd) {
    nd instanceof DataFlow::ArrayCreationNode
    or
    exists(ConstantString shell | shellCmd(shell, _) | nd = DataFlow::valueNode(shell))
  }

  override predicate isSink(DataFlow::Node nd) {
    exists(SystemCommandExecution sys |
      nd = sys.getACommandArgument() or
      nd = sys.getArgumentList()
    )
  }
}

/**
 * Holds if `source` contributes to the arguments of an indirect command execution `sys`.
 *
 * An indirect command execution is a system execution command that starts with `sh -c`, `cmd.exe /c`, or similar.
 *
 * For example, `getCommand()` is `source`, and the call to `childProcess.spawn` is `sys` in the following example:
 *
 * ```
 * let cmd = getCommand();
 * let sh = "sh";
 * let args = ["-c", cmd];
 * childProcess.spawn(sh, args, cb);
 * ```
 */
predicate isIndirectCommandArgument(DataFlow::Node source, SystemCommandExecution sys) {
  exists(
    ArgumentListTracking cfg, DataFlow::ArrayCreationNode args, ConstantString shell, string dashC
  |
    shellCmd(shell, dashC) and
    cfg.hasFlow(DataFlow::valueNode(shell), sys.getACommandArgument()) and
    cfg.hasFlow(args, sys.getArgumentList()) and
    args.getAPropertyWrite().getRhs().mayHaveStringValue(dashC) and
    source = args.getAPropertyWrite().getRhs()
  )
}
