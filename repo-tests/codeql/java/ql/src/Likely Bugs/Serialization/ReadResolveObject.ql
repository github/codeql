/**
 * @name ReadResolve must have Object return type, not void
 * @description An implementation of 'readResolve' that does not have the signature that is expected
 *              by the Java serialization framework is not recognized by the serialization
 *              mechanism.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id java/wrong-readresolve-signature
 * @tags reliability
 *       maintainability
 *       language-features
 */

import java

from TypeSerializable serializable, Class c, Method m
where
  c.hasSupertype+(serializable) and
  m.getDeclaringType() = c and
  m.hasName("readResolve") and
  m.hasNoParameters() and
  not m.getReturnType() instanceof TypeObject
select m,
  "The method " + m.getName() + " must be declared with a return type of Object rather than " +
    m.getReturnType().getName() + "."
