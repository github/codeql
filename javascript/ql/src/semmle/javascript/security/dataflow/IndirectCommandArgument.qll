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
private predicate shellCmd(Expr shell, string arg) {
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
 * Gets a data-flow node whose value ends up being interpreted as the command argument in `sys`
 * after a flow summarized by `t`.
 */
private DataFlow::Node commandArgument(SystemCommandExecution sys, DataFlow::TypeBackTracker t) {
  t.start() and
  result = sys.getACommandArgument()
  or
  exists(DataFlow::TypeBackTracker t2 |
    t = t2.smallstep(result, commandArgument(sys, t2))
  )
}

/**
 * Gets a data-flow node whose value ends up being interpreted as the argument list in `sys`
 * after a flow summarized by `t`.
 */
private DataFlow::SourceNode argumentList(SystemCommandExecution sys, DataFlow::TypeBackTracker t) {
  t.start() and
  result = sys.getArgumentList().getALocalSource()
  or
  exists(DataFlow::TypeBackTracker t2 |
    result = argumentList(sys, t2).backtrack(t2, t)
  )
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
    DataFlow::ArrayCreationNode args, DataFlow::Node shell, string dashC
  |
    shellCmd(shell.asExpr(), dashC) and
    shell = commandArgument(sys, DataFlow::TypeBackTracker::end()) and
    args = argumentList(sys, DataFlow::TypeBackTracker::end()) and
    args.getAPropertyWrite().getRhs().mayHaveStringValue(dashC) and
    source = args.getAPropertyWrite().getRhs()
  )
}
