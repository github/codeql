/**
 * @name Back reference into negative lookahead assertion
 * @description If a back reference refers to a capture group inside a preceding negative lookahead assertion,
 *              then the back reference always matches the empty string, which probably indicates a mistake.
 * @kind problem
 * @problem.severity error
 * @id js/regex/back-reference-to-negative-lookahead
 * @tags reliability
 *       correctness
 *       regular-expressions
 * @precision very-high
 */

import javascript

from RegExpNegativeLookahead neg, RegExpGroup grp, RegExpBackRef back
where
  grp.getParent+() = neg and
  grp = back.getGroup() and
  not back.getParent+() = neg and
  neg.isPartOfRegExpLiteral()
select back,
  "This back reference always matches the empty string, since it refers to $@, which is contained in $@.",
  grp, "this capture group", neg, "a negative lookahead assertion"
