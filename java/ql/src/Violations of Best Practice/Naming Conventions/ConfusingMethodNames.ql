/**
 * @name Confusing method names because of capitalization
 * @description Methods in the same class whose names differ only in capitalization are
 *              confusing.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id java/confusing-method-name
 * @tags maintainability
 *       readability
 *       naming
 */

import java

predicate methodTypeAndLowerCaseName(Method m, RefType t, string name) {
  t = m.getDeclaringType() and
  name = m.getName().toLowerCase()
}

from Method m, Method n
where
  exists(RefType t, string name |
    methodTypeAndLowerCaseName(m, t, name) and
    methodTypeAndLowerCaseName(n, t, name)
  ) and
  not m.getAnAnnotation() instanceof DeprecatedAnnotation and
  not n.getAnAnnotation() instanceof DeprecatedAnnotation and
  m.getName() < n.getName()
select m, "The method '" + m.getName() + "' may be confused with $@.", n, n.getName()
