/**
 * @name Transient field in non-serializable class
 * @description Using the 'transient' field modifier in non-serializable classes has no effect.
 * @kind problem
 * @problem.severity recommendation
 * @precision low
 * @id java/transient-not-serializable
 * @tags reliability
 *       maintainability
 *       language-features
 */

import java

from TypeSerializable serializable, Class c, Field f
where
  not c.hasSupertype+(serializable) and
  f.getDeclaringType() = c and
  f.isTransient()
select f, "The field " + f.getName() + " is transient but " + c.getName() + " is not Serializable."
