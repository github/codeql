/**
 * @name Unmatchable dollar in regular expression
 * @description If a dollar assertion '$' appears in a regular expression before another term that
 *              cannot match the empty string, then this assertion can never match, so the entire
 *              regular expression cannot match any string.
 * @kind problem
 * @problem.severity error
 * @id js/regex/unmatchable-dollar
 * @tags reliability
 *       correctness
 *       regular-expressions
 *       external/cwe/cwe-561
 * @precision very-high
 */

import javascript

from RegExpDollar dollar, RegExpTerm t
where
  dollar.isPartOfRegExpLiteral() and
  t = dollar.getSuccessor+() and
  not t.isNullable() and
  // conservative handling of multi-line regular expressions
  not dollar.getLiteral().isMultiline()
select dollar, "This assertion can never match."
