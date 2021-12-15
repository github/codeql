/**
 * Provides general-purpose utility predicates.
 */

import javascript

/**
 * Gets the capitalization of `s`.
 *
 * For example, the capitalization of `"function"` is `"Function"`.
 */
bindingset[s]
string capitalize(string s) { result = s.charAt(0).toUpperCase() + s.suffix(1) }

/**
 * Gets the pluralization for `n` occurrences of `noun`.
 *
 * For example, the pluralization of `"function"` for `n = 2` is `"functions"`.
 */
bindingset[noun, n]
string pluralize(string noun, int n) { if n = 1 then result = noun else result = noun + "s" }

/**
 * Gets `str` or a truncated version of `str` with `explanation` appended if its length exceeds `maxLength`.
 *
 * For example, the truncation of `"long_string"` for `maxLength = 5` and explanation `" ..."` is `"long_ ..."`.
 */
bindingset[str, maxLength, explanation]
string truncate(string str, int maxLength, string explanation) {
  if str.length() > maxLength then result = str.prefix(maxLength) + explanation else result = str
}

/**
 * Gets a string that describes `e`.
 */
string describeExpression(Expr e) {
  if e instanceof InvokeExpr
  then
    exists(string prefix, string suffix | result = prefix + suffix |
      (
        if e instanceof NewExpr
        then prefix = "constructor call"
        else
          if e instanceof MethodCallExpr
          then prefix = "method call"
          else prefix = "call"
      ) and
      (
        if exists(e.(InvokeExpr).getCalleeName())
        then suffix = " to " + e.(InvokeExpr).getCalleeName()
        else suffix = ""
      )
    )
  else
    if e instanceof Comparison
    then result = "comparison"
    else
      if e instanceof VarAccess
      then result = "use of variable '" + e.(VarAccess).getName() + "'"
      else
        if e instanceof PropAccess and exists(e.(PropAccess).getPropertyName())
        then result = "use of property '" + e.(PropAccess).getPropertyName() + "'"
        else
          if e instanceof LogNotExpr
          then result = "negation"
          else result = "expression"
}
