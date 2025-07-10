/**
 * @name Possible confusion of local and field
 * @description A method in which a variable is declared with the same name as a field is difficult
 *              to understand.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id java/local-shadows-field
 * @tags maintainability
 *       readability
 */

import java
import Shadowing

from LocalVariableDecl d, Class c, Field f, Callable callable, string callableType, string message
where
  shadows(d, c, f, callable) and
  not assignmentToShadowingLocal(d, f) and
  not assignmentFromShadowingLocal(d, f) and
  (if callable instanceof Constructor then callableType = "" else callableType = "method ") and
  (
    confusingAccess(d, f) and
    message =
      "Confusing name: " + callableType +
        "$@ also refers to field $@ (without qualifying it with 'this')."
    or
    thisAccess(d, f) and
    not confusingAccess(d, f) and
    message =
      "Potentially confusing name: " + callableType + "$@ also refers to field $@ (as this." +
        f.getName() + ")."
  )
select d, message, callable, callable.getName(), f, f.getName()
