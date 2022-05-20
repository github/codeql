/**
 * @name String instead of regular expression
 * @description Calling 'String.prototype.replace' or 'String.prototype.split' with a string argument that looks like a regular expression is probably a mistake because the called function will not convert the string into a regular expression.
 * @kind problem
 * @problem.severity warning
 * @id js/string-instead-of-regex
 * @tags correctness
 * @precision high
 */

import javascript

/**
 * Gets a regular expression pattern that matches the syntax of likely regular expressions.
 */
private string getALikelyRegExpPattern() {
  result = "/.*/[gimuy]{1,5}" or // pattern with at least one flag: /foo/i
  result = "/\\^.*/[gimuy]{0,5}" or // pattern with anchor: /^foo/
  result = "/.*\\$/[gimuy]{0,5}" or // pattern with anchor: /foo$/
  result = "\\^.*\\$" or // pattern body with anchors: ^foo$
  result = ".*(?<!\\\\)\\\\[dDwWsSB].*" or // contains a builtin character class: \s
  result = ".*(?<!\\\\)\\\\[\\[\\]()*+?{}|^$.].*" or // contains an escaped meta-character: \(
  result = ".*\\[\\^?[\\p{Alnum}\\p{Blank}_-]+\\][*+].*" // contains a quantified custom character class: [^a-zA-Z123]+
}

/**
 * Holds if `mce` is a call to String.prototype.replace or String.prototype.split
 */
predicate isStringSplitOrReplace(MethodCallExpr mce) {
  exists(string name, int arity |
    mce.getMethodName() = name and
    mce.getNumArgument() = arity
  |
    name = ["replace", "replaceAll"] and arity = 2
    or
    name = "split" and
    (arity = 1 or arity = 2)
  )
}

/**
 * Holds if `nd` may evaluate to `s`.
 */
predicate mayReferToString(DataFlow::Node nd, StringLiteral s) {
  s = nd.asExpr() or mayReferToString(nd.getAPredecessor(), s)
}

from MethodCallExpr mce, StringLiteral arg, string raw, string s
where
  isStringSplitOrReplace(mce) and
  mayReferToString(mce.getArgument(0).flow(), arg) and
  raw = arg.getRawValue() and
  s = raw.substring(1, raw.length() - 1) and
  s.regexpMatch(getALikelyRegExpPattern())
select mce,
  "String argument '$@' looks like a regular expression, but it will be interpreted as a string.",
  arg, s
