/**
 * @name Typo in toString
 * @description A method named 'tostring' may be intended to be named 'toString'.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id java/tostring-typo
 * @tags maintainability
 *       readability
 *       naming
 */

import java

from Method m
where
  m.hasName("tostring") and
  m.hasNoParameters()
select m, "Should this method be called 'toString' rather than 'tostring'?"
