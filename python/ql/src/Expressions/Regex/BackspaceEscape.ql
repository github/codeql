/**
 * @name Backspace escape in regular expression
 * @description Using '\b' to escape the backspace character in a regular expression is confusing
 *              since it could be mistaken for a word boundary assertion.
 * @kind problem
 * @tags maintainability
 * @problem.severity recommendation
 * @sub-severity high
 * @precision very-high
 * @id py/regex/backspace-escape
 */

import python
import semmle.python.regex

from RegExp r, int offset
where
  r.escapingChar(offset) and
  r.getChar(offset + 1) = "b" and
  exists(int start, int end | start < offset and end > offset | r.charSet(start, end))
select r, "Backspace escape in regular expression at offset " + offset + "."
