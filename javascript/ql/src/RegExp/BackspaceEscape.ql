/**
 * @name Backspace escape in regular expression
 * @description Using '\b' to escape the backspace character in a regular expression is confusing
 *              since it could be mistaken for a word boundary assertion.
 * @kind problem
 * @problem.severity recommendation
 * @id js/regex/backspace-escape
 * @tags quality
 *       maintainability
 *       readability
 *       correctness
 * @precision medium
 */

import javascript

from RegExpCharEscape rece
where
  rece.toString() = "\\b" and
  rece.isPartOfRegExpLiteral()
select rece, "Backspace escape in regular expression."
