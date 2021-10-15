/**
 * @name TODO/FIXME comments
 * @description A comment that contains 'TODO' or 'FIXME' may indicate code that is incomplete or
 *              broken, or it may highlight an ambiguity in the software's specification.
 * @kind problem
 * @problem.severity recommendation
 * @precision low
 * @id java/todo-comment
 * @tags maintainability
 *       readability
 *       external/cwe/cwe-546
 */

import java

from JavadocText c
where
  c.getText().matches("%TODO%") or
  c.getText().matches("%FIXME%")
select c, "TODO/FIXME comment."
