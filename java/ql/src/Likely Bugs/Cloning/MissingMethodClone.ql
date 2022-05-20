/**
 * @name No clone method
 * @description A class that implements 'Cloneable' but does not override the 'clone' method will
 *              have undesired behavior.
 * @kind problem
 * @problem.severity error
 * @precision medium
 * @id java/missing-clone-method
 * @tags reliability
 *       maintainability
 */

import java

from Class t, TypeCloneable cloneable
where
  t.hasSupertype+(cloneable) and
  not t.isAbstract() and
  not t.getAMethod() instanceof CloneMethod and
  exists(Field f | f.getDeclaringType() = t and not f.isStatic()) and
  t.fromSource()
select t, "No clone method, yet implements Cloneable."
