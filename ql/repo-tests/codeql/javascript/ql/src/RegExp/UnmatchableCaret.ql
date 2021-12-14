/**
 * @name Unmatchable caret in regular expression
 * @description If a caret assertion '^' appears in a regular expression after another term that
 *              cannot match the empty string, then this assertion can never match, so the entire
 *              regular expression cannot match any string.
 * @kind problem
 * @problem.severity error
 * @id js/regex/unmatchable-caret
 * @tags reliability
 *       correctness
 *       regular-expressions
 *       external/cwe/cwe-561
 * @precision very-high
 */

import javascript

from RegExpCaret caret, RegExpTerm t
where
  caret.isPartOfRegExpLiteral() and
  t = caret.getPredecessor+() and
  not t.isNullable() and
  // conservative handling of multi-line regular expressions
  not caret.getLiteral().isMultiline()
select caret, "This assertion can never match."
