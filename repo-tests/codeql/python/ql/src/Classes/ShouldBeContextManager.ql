/**
 * @name Class should be a context manager
 * @description Making a class a context manager allows instances to be used in a 'with' statement.
 *              This improves resource handling and code readability.
 * @kind problem
 * @tags maintainability
 *       readability
 *       convention
 * @problem.severity recommendation
 * @sub-severity high
 * @precision medium
 * @id py/should-be-context-manager
 */

import python

from ClassValue c
where not c.isBuiltin() and not c.isContextManager() and exists(c.declaredAttribute("__del__"))
select c,
  "Class " + c.getName() +
    " implements __del__ (presumably to release some resource). Consider making it a context manager."
