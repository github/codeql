/**
 * @name Unterminated variadic call
 * @description Calling a variadic function without a sentinel value
 *              may result in a buffer overflow if the function expects
 *              a specific value to terminate the argument list.
 * @kind problem
 * @problem.severity warning
 * @security-severity 8.8
 * @precision medium
 * @id cpp/unterminated-variadic-call
 * @tags reliability
 *       security
 *       external/cwe/cwe-121
 */

import cpp

/**
 * Gets a normalized textual representation of `e`'s value.
 * The result is the same as `Expr.getValue()`, except if there is a
 * trailing `".0"` then it is removed. This means that, for example,
 * the values of `-1` and `-1.0` would be considered the same.
 */
string normalisedExprValue(Expr e) { result = e.getValue().regexpReplaceAll("\\.0$", "") }

/**
 * A variadic function which is not a formatting function.
 */
class VarargsFunction extends Function {
  VarargsFunction() {
    this.isVarargs() and
    not this instanceof FormattingFunction
  }

  Expr trailingArgumentIn(FunctionCall fc) {
    fc = this.getACallToThisFunction() and
    result = fc.getArgument(fc.getNumberOfArguments() - 1)
  }

  string trailingArgValue(FunctionCall fc) {
    result = normalisedExprValue(this.trailingArgumentIn(fc))
  }

  private int trailingArgValueCount(string value) {
    result = strictcount(FunctionCall fc | this.trailingArgValue(fc) = value)
  }

  string nonTrailingVarArgValue(FunctionCall fc, int index) {
    fc = this.getACallToThisFunction() and
    index >= this.getNumberOfParameters() and
    index < fc.getNumberOfArguments() - 1 and
    result = normalisedExprValue(fc.getArgument(index))
  }

  private int totalCount() {
    result = strictcount(FunctionCall fc | fc = this.getACallToThisFunction())
  }

  string normalTerminator(int cnt, int totalCount) {
    // the terminator is 0 or -1
    result = ["0", "-1"] and
    // at least 80% of calls have the terminator
    cnt = this.trailingArgValueCount(result) and
    totalCount = this.totalCount() and
    100 * cnt / totalCount >= 80 and
    // terminator value is not used in a non-terminating position
    not this.nonTrailingVarArgValue(_, _) = result
  }

  predicate isWhitelisted() { this.hasGlobalName(["open", "fcntl", "ptrace", "mremap"]) }
}

from VarargsFunction f, FunctionCall fc, string terminator, int cnt, int totalCount
where
  terminator = f.normalTerminator(cnt, totalCount) and
  fc = f.getACallToThisFunction() and
  not normalisedExprValue(f.trailingArgumentIn(fc)) = terminator and
  not f.isWhitelisted()
select fc,
  "Calls to $@ should use the value " + terminator + " as a terminator (" + cnt + " of " +
    totalCount + " calls do).", f, f.getQualifiedName()
