/**
 * @name Empty character class
 * @description Empty character classes are not normally useful and may indicate a bug.
 * @kind problem
 * @problem.severity warning
 * @id js/regex/empty-character-class
 * @tags reliability
 *       correctness
 *       regular-expressions
 * @precision very-high
 */

import javascript

from RegExpCharacterClass recc
where
  not exists(recc.getAChild()) and
  not recc.isInverted() and
  recc.isPartOfRegExpLiteral()
select recc, "Empty character class."
