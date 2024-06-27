/**
 * @name Replacement of a substring with itself
 * @description Replacing a substring with itself has no effect and may indicate a mistake.
 * @kind problem
 * @problem.severity warning
 * @security-severity 5.0
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
  exists(RegExpLiteral rl |
    rl.flow().(DataFlow::SourceNode).flowsToExpr(e) and
    not rl.isIgnoreCase() and
    regExpMatchesString(rl.getRoot(), s)
  )
  or
  s = e.getStringValue()
}

/**
 * Holds if `t` matches `s` and nothing else.
 */
language[monotonicAggregates]
predicate regExpMatchesString(RegExpTerm t, string s) {
  t.isPartOfRegExpLiteral() and
  (
    // constants match themselves
    s = t.(RegExpConstant).getValue()
    or
    // assertions match the empty string
    (
      t instanceof RegExpCaret or
      t instanceof RegExpDollar or
      t instanceof RegExpWordBoundary or
      t instanceof RegExpNonWordBoundary or
      t instanceof RegExpLookahead or
      t instanceof RegExpLookbehind
    ) and
    s = ""
    or
    // groups match their content
    regExpMatchesString(t.(RegExpGroup).getAChild(), s)
    or
    // single-character classes match that character
    exists(RegExpCharacterClass recc | recc = t and not recc.isInverted() |
      recc.getNumChild() = 1 and
      regExpMatchesString(recc.getChild(0), s)
    )
    or
    // sequences match the concatenation of their elements
    exists(RegExpSequence seq | seq = t |
      s =
        concat(int i, RegExpTerm child |
          child = seq.getChild(i)
        |
          any(string subs | regExpMatchesString(child, subs)) order by i
        )
    )
  )
}

from MethodCallExpr repl, string s, string friendly
where
  repl.getMethodName() = ["replace", "replaceAll"] and
  matchesString(repl.getArgument(0), s) and
  repl.getArgument(1).getStringValue() = s and
  (if s = "" then friendly = "the empty string" else friendly = "'" + s + "'")
select repl.getArgument(0), "This replaces " + friendly + " with itself."
