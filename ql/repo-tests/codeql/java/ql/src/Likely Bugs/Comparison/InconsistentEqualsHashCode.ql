/**
 * @name Inconsistent equals and hashCode
 * @description If a class overrides only one of 'equals' and 'hashCode', it may mean that
 *              'equals' and 'hashCode' are inconsistent.
 * @kind problem
 * @problem.severity error
 * @precision very-high
 * @id java/inconsistent-equals-and-hashcode
 * @tags reliability
 *       correctness
 *       external/cwe/cwe-581
 */

import java
import Equality

from Class c, string message, Method existingMethod
where
  c.fromSource() and
  (
    not exists(EqualsMethod e | e.getDeclaringType() = c) and
    exists(HashCodeMethod h | h.getDeclaringType() = c and h = existingMethod) and
    message = "Class " + c.getName() + " overrides $@ but not equals."
    or
    not exists(HashCodeMethod h | h.getDeclaringType() = c) and
    // If the inherited `equals` is a refining `equals` then the superclass hash code is still valid.
    exists(EqualsMethod e |
      e.getDeclaringType() = c and e = existingMethod and not e instanceof RefiningEquals
    ) and
    message = "Class " + c.getName() + " overrides $@ but not hashCode."
  )
select c, message, existingMethod, existingMethod.getName()
