/**
 * @name TODO comment
 * @description A comment that contains 'TODO' or similar keywords may indicate code that is incomplete or
 *              broken, or it may highlight an ambiguity in the software's specification.
 * @kind problem
 * @problem.severity recommendation
 * @id js/todo-comment
 * @tags maintainability
 *       external/cwe/cwe-546
 * @precision medium
 */

import javascript

from Comment c
where c.getText().regexpMatch("(?s).*FIXME.*|.*TODO.*|.*(?<!=)\\s*XXX.*")
select c, "TODO comments should be addressed."
