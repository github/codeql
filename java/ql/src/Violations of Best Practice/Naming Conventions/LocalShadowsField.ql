/**
 * @name Local variable shadows field
 * @description If a local variable shadows a field of the same name, each use of
 *              the name is harder to read.
 * @kind problem
 * @problem.severity recommendation
 * @precision low
 * @id java/local-shadows-field-unused
 * @tags maintainability
 */

import java
import Shadowing

from LocalVariableDecl d, Class c, Field f, Callable callable, string callableType
where
  shadows(d, c, f, callable) and
  not assignmentToShadowingLocal(d, f) and
  not assignmentFromShadowingLocal(d, f) and
  not thisAccess(d, f) and
  not confusingAccess(d, f) and
  (if callable instanceof Constructor then callableType = "" else callableType = "method ")
select d, "This local variable shadows field $@, which is not used in " + callableType + "$@.", f,
  f.getName(), callable, callable.getName()
