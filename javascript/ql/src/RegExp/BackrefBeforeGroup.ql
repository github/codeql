/**
 * @name Back reference precedes capture group
 * @description If a back reference precedes the capture group it refers to, it matches the empty string,
 *              which is probably not what was expected.
 * @kind problem
 * @problem.severity error
 * @id js/regex/back-reference-before-group
 * @tags reliability
 *       correctness
 *       regular-expressions
 * @precision very-high
 */

import javascript

from RegExpBackRef rebr
where
  rebr.getLocation().getStartColumn() < rebr.getGroup().getLocation().getEndColumn() and
  not rebr.isInBackwardMatchingContext() and
  rebr.isPartOfRegExpLiteral()
select rebr, "This back reference precedes its capture group."
