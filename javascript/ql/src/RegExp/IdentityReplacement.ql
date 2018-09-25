/**
 * @name Replacement of a substring with itself
 * @description Replacing a substring with itself has no effect and may indicate a mistake.
 * @kind problem
 * @problem.severity warning
 * @id js/identity-replacement
 * @precision very-high
 * @tags correctness
 *       security
 *       external/cwe/cwe-116
 */

import javascript

/**
 * Holds if `e`, when used as the first argument of `String.prototype.replace`, matches
 * `s` and nothing else.
 */
predicate matchesString(Expr e, string s) {
  exists (RegExpLiteral rl |
    rl = e and
    not rl.isIgnoreCase() and
    regExpMatchesString(rl.getRoot(), s)
  )
  or
  s = e.getStringValue()
}

/**
 * Holds if `t` matches `c` and nothing else.
 */
predicate matchesConstant(RegExpTerm t, RegExpConstant c) {
  c = t
  or
  matchesConstant(t.(RegExpGroup).getAChild(), c)
  or
  exists (RegExpCharacterClass recc | recc = t and not recc.isInverted() |
    recc.getNumChild() = 1 and
    matchesConstant(recc.getChild(0), c)
  )
}

from MethodCallExpr repl, string s
where repl.getMethodName() = "replace" and
      matchesString(repl.getArgument(0), s) and
      repl.getArgument(1).getStringValue() = s
select repl.getArgument(0), "This replaces '" + s + "' with itself."
