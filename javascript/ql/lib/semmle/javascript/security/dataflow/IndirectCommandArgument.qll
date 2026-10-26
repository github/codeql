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
    s = ["sh", "bash", "/bin/sh", "/bin/bash"] and
    arg = "-c"
  )
  or
  exists(string s | s = shell.getStringValue().toLowerCase() |
    s = ["cmd", "cmd.exe"] and
    arg = ["/c", "/C"]
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
  exists(DataFlow::TypeBackTracker t2 | t2 = t.smallstep(result, commandArgument(sys, t2)))
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
    TaintTracking::arrayStep(any(DataFlow::Node n | result.flowsTo(n)), pred)
  )
}

/**
 * Gets a data-flow node whose value ends up being interpreted as the argument list in `sys`.
 */
private DataFlow::SourceNode argumentList(SystemCommandExecution sys) {
  result = argumentList(sys, DataFlow::TypeBackTracker::end())
}

/**
 * Gets a data-flow node whose value ends up being interpreted as an element of the argument list
 * `args` after a flow summarised by `t`.
 */
private DataFlow::Node argumentListElement(DataFlow::SourceNode args, DataFlow::TypeBackTracker t) {
  t.start() and
  args = argumentList(_) and
  result = args.getAPropertyWrite().getRhs()
  or
  exists(DataFlow::TypeBackTracker t2 | t2 = t.smallstep(result, argumentListElement(args, t2)))
}

/**
 * Gets a data-flow node whose value ends up being interpreted as an element of the argument list
 * `args`.
 */
private DataFlow::Node argumentListElement(DataFlow::SourceNode args) {
  result = argumentListElement(args, DataFlow::TypeBackTracker::end())
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
    args = argumentList(sys) and
    argumentListElement(args).mayHaveStringValue(dashC) and
    exists(DataFlow::SourceNode argsSource | argsSource = argumentList(sys) |
      if exists(argsSource.getAPropertyWrite())
      then source = argsSource.getAPropertyWrite().getRhs()
      else source = argsSource
    )
  )
}
