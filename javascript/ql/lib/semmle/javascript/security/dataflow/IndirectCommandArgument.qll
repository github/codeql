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

/** Gets an argument list without following array transformations that can change positions. */
private DataFlow::SourceNode positionalArgumentList(
  SystemCommandExecution sys, DataFlow::TypeBackTracker t
) {
  t.start() and
  result = sys.getArgumentList().getALocalSource()
  or
  exists(DataFlow::TypeBackTracker t2 | result = positionalArgumentList(sys, t2).backtrack(t2, t))
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

/** Holds if the first `n` elements are recognized `env` options. */
private predicate envOptions(DataFlow::ArrayCreationNode args, int n) {
  n = 0
  or
  envOptions(args, n - 1) and
  args.getElement(n - 1).getALocalSource().getStringValue() = ["-i", "--ignore-environment", "-"]
  or
  envOptions(args, n - 1) and
  args.getElement(n - 1).getALocalSource().getStringValue().regexpMatch("--unset=.+")
  or
  envOptions(args, n - 2) and
  args.getElement(n - 2).getALocalSource().getStringValue() = ["-u", "--unset"] and
  exists(args.getElement(n - 1)) and
  not args.getElement(n - 1).asExpr() instanceof SpreadElement
}

/** Holds if the first `n` elements are recognized `env` options and assignments. */
private predicate envPrefix(DataFlow::ArrayCreationNode args, int n) {
  envOptions(args, n)
  or
  envOptions(args, n - 1) and args.getElement(n - 1).getStringValue() = "--"
  or
  envPrefix(args, n - 1) and
  args.getElement(n - 1).getALocalSource().getStringValue().regexpMatch("[^=]+=.*")
}

/** Holds if the first `n` elements are recognized `nice` options. */
private predicate nicePrefix(DataFlow::ArrayCreationNode args, int n) {
  n = 0
  or
  nicePrefix(args, n - 1) and
  args.getElement(n - 1)
      .getALocalSource()
      .getStringValue()
      .regexpMatch("(-[0-9]+|-n[+-]?[0-9]+|--adjustment=[+-]?[0-9]+)")
  or
  nicePrefix(args, n - 2) and
  args.getElement(n - 2).getALocalSource().getStringValue() = ["-n", "--adjustment"] and
  exists(args.getElement(n - 1)) and
  not args.getElement(n - 1).asExpr() instanceof SpreadElement
}

/** Holds if a launcher runs the shell at index `i` in its argument array. */
private predicate launcherShell(SystemCommandExecution sys, DataFlow::ArrayCreationNode args, int i) {
  exists(string launcher | launcher = commandArgument(sys).getStringValue() |
    launcher = ["env", "/usr/bin/env", "/bin/env"] and envPrefix(args, i)
    or
    launcher = ["nice", "/usr/bin/nice", "/bin/nice"] and
    (
      nicePrefix(args, i)
      or
      nicePrefix(args, i - 1) and args.getElement(i - 1).getStringValue() = "--"
    )
  )
}

/** Holds if the array can reach the call without its elements being modified. */
private predicate positionalArrayReaches(
  DataFlow::ArrayCreationNode args, ControlFlowNode node, ControlFlowNode use
) {
  node = use
  or
  not exists(DataFlow::PropWrite write |
    write = args.getAPropertyWrite() and
    write.getWriteNode() = node and
    (
      not exists(write.getPropertyName())
      or
      write.getPropertyName().regexpMatch("([0-9]+|length)")
    )
  ) and
  not exists(DataFlow::MethodCallNode call |
    call =
      args.getAMethodCall([
          "copyWithin", "fill", "pop", "push", "reverse", "shift", "sort", "splice", "unshift"
        ]) and
    node = call.asExpr()
  ) and
  positionalArrayReaches(args, node.getASuccessor(), use)
}

/**
 * Holds if `source` contributes to the arguments of an indirect command execution `sys`.
 *
 * An indirect command execution is a system execution command that starts with `sh -c`, `cmd.exe /c`, or similar,
 * optionally through an `env` or `nice` launcher.
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
  or
  exists(DataFlow::ArrayCreationNode args, int i, string dashC |
    args = positionalArgumentList(sys, DataFlow::TypeBackTracker::end()) and
    (
      args.asExpr().getContainer() != sys.asExpr().getContainer()
      or
      positionalArrayReaches(args, args.asExpr().getASuccessor(), sys.asExpr())
    ) and
    launcherShell(sys, args, i) and
    shellCmd(args.getElement(i).getALocalSource().asExpr(), dashC) and
    args.getElement(i + 1).mayHaveStringValue(dashC) and
    source = args.getElement(i + 2) and
    not source.asExpr() instanceof SpreadElement
  )
}
