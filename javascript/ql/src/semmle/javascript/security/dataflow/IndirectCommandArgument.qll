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
  exists(DataFlow::TypeBackTracker t2 | t = t2.smallstep(result, commandArgument(sys, t2)))
}

/**
 * Gets a data-flow node whose value ends up being interpreted as the command argument in `sys`.
 */
private DataFlow::Node commandArgument(SystemCommandExecution sys) {
  result = commandArgument(sys, DataFlow::TypeBackTracker::end())
}

/**
 * Gets a data-flow node whose value ends up being interpreted as the argument list in `sys`
 * after a flow summarized by `t`.
 */
private DataFlow::SourceNode argumentList(SystemCommandExecution sys, DataFlow::TypeBackTracker t) {
  t.start() and
  result = sys.getArgumentList().getALocalSource()
  or
  exists(DataFlow::TypeBackTracker t2, DataFlow::SourceNode pred | pred = argumentList(sys, t2) |
    result = pred.backtrack(t2, t)
    or
    t = t2.continue() and
    TaintTracking::arrayFunctionTaintStep(any(DataFlow::Node n | result.flowsTo(n)), pred, _)
  )
}

/**
 * Gets a data-flow node whose value ends up being interpreted as the argument list in `sys`.
 */
private DataFlow::SourceNode argumentList(SystemCommandExecution sys) {
  result = argumentList(sys, DataFlow::TypeBackTracker::end())
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
 * or
 * ```
 * let cmd = getCommand();
 * childProcess.spawn("cmd.exe", ["/c"].concat(cmd), cb);
 * ```
 */
predicate isIndirectCommandArgument(DataFlow::Node source, SystemCommandExecution sys) {
  exists(DataFlow::ArrayCreationNode args, DataFlow::Node shell, string dashC |
    shellCmd(shell.asExpr(), dashC) and
    shell = commandArgument(sys) and
    args.getAPropertyWrite().getRhs().mayHaveStringValue(dashC) and
    args = argumentList(sys) and
    (
      source = argumentList(sys)
      or
      source = argumentList(sys).getAPropertyWrite().getRhs()
    )
  )
}
