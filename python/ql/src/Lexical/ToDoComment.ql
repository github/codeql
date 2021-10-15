/**
 * @name 'To Do' comment
 * @description Writing comments that include 'TODO' tends to lead to a build up of partially
 *              implemented features.
 * @kind problem
 * @tags maintainability
 *       readability
 *       documentation
 *       external/cwe/cwe-546
 * @problem.severity recommendation
 * @sub-severity low
 * @deprecated
 * @precision medium
 * @id py/todo-comment
 */

import python

from Comment c
where c.getText().matches("%TODO%") or c.getText().matches("%TO DO%")
select c, c.getText()
