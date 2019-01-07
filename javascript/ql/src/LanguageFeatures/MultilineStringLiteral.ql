/**
 * @name Multi-line string literal
 * @description Multi-line string literals are non-standard and hard to read, and should be avoided.
 * @kind problem
 * @problem.severity recommendation
 * @id js/multi-line-string
 * @tags maintainability
 *       external/cwe/cwe-758
 * @precision low
 * @deprecated Multi-line string literals are now a standard language feature. Deprecated since 1.17.
 */

import javascript

from StringLiteral sl, Location l
where
  l = sl.getLocation() and
  l.getStartLine() != l.getEndLine()
select sl, "Avoid multi-line string literals."
