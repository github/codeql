/**
 * Provides predicates for reasoning about indirect command arguments.
 */

import javascript

/**
 * Holds if `shell arg <cmd>` runs `<cmd>` as a shell command, where `isUnix` indicates whether
 * `shell` is a POSIX-style shell (`sh` or `bash`) rather than Windows `cmd.exe`.
 */
private predicate shellCmd(Expr shell, string arg, boolean isUnix) {
  exists(string s | s = shell.getStringValue() |
    s = ["sh", "bash", "/bin/sh", "/bin/bash"] and
    arg = "-c" and
    isUnix = true
  )
  or
  exists(string s | s = shell.getStringValue().toLowerCase() |
    s = ["cmd", "cmd.exe"] and
    arg = ["/c", "/C"] and
    isUnix = false
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
 * Gets a data-flow node whose elements form a prefix of the argument list in `sys`
 * after a flow summarized by `t`.
 *
 * Unlike `argumentList`, this only steps through value-preserving flow and `.concat(...)`
 * receivers, preserving element indices from index 0 up to the array's length.
 */
private DataFlow::SourceNode argumentListPrefix(
  SystemCommandExecution sys, DataFlow::TypeBackTracker t
) {
  t.start() and
  result = sys.getArgumentList().getALocalSource()
  or
  exists(DataFlow::TypeBackTracker t2, DataFlow::SourceNode pred |
    pred = argumentListPrefix(sys, t2)
  |
    result = pred.backtrack(t2, t)
    or
    t = t2.continue() and
    pred.(DataFlow::MethodCallNode).getMethodName() = "concat" and
    result = pred.(DataFlow::MethodCallNode).getReceiver().getALocalSource()
  )
}

/**
 * Gets a data-flow node whose elements form a prefix of the argument list in `sys`.
 */
private DataFlow::SourceNode argumentListPrefix(SystemCommandExecution sys) {
  result = argumentListPrefix(sys, DataFlow::TypeBackTracker::end())
}

/**
 * Holds if `args` has no mutating operations that could shift or overwrite prefix indices
 * dynamically.
 */
private predicate hasUnmodifiedPrefix(DataFlow::ArrayCreationNode args) {
  not exists(
    args.getAMethodCall([
        "pop", "unshift", "shift", "splice", "reverse", "sort", "copyWithin", "fill"
      ])
  ) and
  not exists(args.getAPropertyWrite("length")) and
  not exists(DataFlow::PropWrite pw | pw = args.getAPropertyWrite() |
    exists(pw.getPropertyNameExpr()) and
    not exists(pw.getPropertyName())
  )
}

/**
 * Gets a data-flow node written to non-negative integer index `i` of `args`, provided no spread
 * element precedes or occupies index `i`.
 */
private DataFlow::Node arrayElementAt(DataFlow::ArrayCreationNode args, int i) {
  args = argumentListPrefix(_) and
  not exists(int j | j in [0 .. i] | args.getElement(j).asExpr() instanceof SpreadElement) and
  (
    result = args.getElement(i)
    or
    exists(string prop |
      result = args.getAPropertyWrite(prop).getRhs() and
      i = prop.toInt() and
      i >= 0 and
      prop = i.toString()
    )
  )
}

/**
 * Gets the unique string value that element `i` of `args` may have, if all writes to index `i`
 * resolve to that single string constant.
 */
private string uniqueElementString(DataFlow::ArrayCreationNode args, int i) {
  forex(DataFlow::Node elem | elem = arrayElementAt(args, i) |
    exists(string s | elem.mayHaveStringValue(s))
  ) and
  result = unique(string s | arrayElementAt(args, i).mayHaveStringValue(s))
}

/**
 * Gets the number of subsequent arguments consumed as option-arguments by Unix shell option
 * token `opt` (for example `1` for `-o`, `-euo`, `-oe`, or `--rcfile`).
 */
bindingset[opt]
private int shellOptionArgCount(string opt) {
  if opt = ["--rcfile", "--init-file"]
  then result = 1
  else
    if opt.regexpMatch("[-+][a-zA-Z]+")
    then result = count(int k | opt.charAt(k) = ["o", "O"])
    else result = 0
}

/**
 * Holds if `i` is the index of a shell option or the first non-option operand in `args`.
 */
private predicate unixOptionScanIndex(DataFlow::ArrayCreationNode args, int i) {
  args = argumentListPrefix(_) and
  hasUnmodifiedPrefix(args) and
  exists(arrayElementAt(args, 0)) and
  i = 0
  or
  exists(int prev, string opt, int argCount |
    unixOptionScanIndex(args, prev) and
    opt = uniqueElementString(args, prev) and
    opt.charAt(0) = ["-", "+"] and
    not opt = ["-", "--"] and
    argCount = shellOptionArgCount(opt) and
    forall(int k | k in [1 .. argCount] | exists(arrayElementAt(args, prev + k))) and
    i = prev + 1 + argCount
  ) and
  exists(arrayElementAt(args, i))
}

/**
 * Gets the index of the `command_string` operand for a Unix `sh -c` invocation using `args`,
 * if it can be determined unambiguously from `args`.
 */
private int unixCommandStringIndex(DataFlow::ArrayCreationNode args) {
  exists(int cIdx |
    unixOptionScanIndex(args, cIdx) and
    uniqueElementString(args, cIdx).regexpMatch("-[a-zA-Z]*c[a-zA-Z]*")
  ) and
  (
    exists(int endOpts |
      unixOptionScanIndex(args, endOpts) and
      uniqueElementString(args, endOpts) = ["-", "--"] and
      result = endOpts + 1 and
      exists(arrayElementAt(args, result))
    )
    or
    unixOptionScanIndex(args, result) and
    not any(string s | arrayElementAt(args, result).mayHaveStringValue(s)).charAt(0) = ["-", "+"]
  )
}

/**
 * Holds if every origin of the prefix of `sys`'s argument list is an array creation with a
 * known Unix `-c` command-string index.
 */
private predicate prefixFixesUnixCommand(SystemCommandExecution sys) {
  forex(DataFlow::SourceNode leaf |
    leaf = argumentListPrefix(sys) and
    not leaf.(DataFlow::MethodCallNode).getMethodName() = "concat" and
    not exists(DataFlow::TypeBackTracker t0 | t0.start() and exists(leaf.backtrack(t0, _)))
  |
    exists(unixCommandStringIndex(leaf))
  )
}

/**
 * Holds if `source` contributes to the command executed by an indirect command execution `sys`.
 *
 * An indirect command execution is a system execution command that starts with `sh -c`, `cmd.exe /c`, or similar.
 * For POSIX shells (`sh -c`, `bash -c`), only the `command_string` operand is interpreted as shell code when its
 * position can be determined; subsequent arguments (`$0`, `$1`, ...) are positional parameters rather than commands.
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
  exists(DataFlow::ArrayCreationNode args, DataFlow::Node shell, string dashC, boolean isUnix |
    shellCmd(shell.asExpr(), dashC, isUnix) and
    shell = commandArgument(sys) and
    args = argumentList(sys) and
    argumentListElement(args).mayHaveStringValue(dashC)
  |
    if isUnix = true and args = argumentListPrefix(sys) and exists(unixCommandStringIndex(args))
    then source = arrayElementAt(args, unixCommandStringIndex(args))
    else (
      not (isUnix = true and not args = argumentListPrefix(sys) and prefixFixesUnixCommand(sys)) and
      exists(DataFlow::SourceNode argsSource | argsSource = argumentList(sys) |
        if exists(argsSource.getAPropertyWrite())
        then source = argsSource.getAPropertyWrite().getRhs()
        else source = argsSource
      )
    )
  )
}
