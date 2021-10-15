/**
 * @name Serializable but no void constructor
 * @description A non-serializable, immediate superclass of a serializable class that does not
 *              itself declare an accessible, no-argument constructor causes deserialization to
 *              fail.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id java/missing-no-arg-constructor-on-serializable
 * @tags reliability
 *       maintainability
 *       language-features
 */

import java

from Class serial, Class nonserial, TypeSerializable serializable
where
  serial.hasSupertype(nonserial) and
  serial.hasSupertype+(serializable) and
  not nonserial.hasSupertype+(serializable) and
  not exists(Constructor c |
    c = nonserial.getSourceDeclaration().getAConstructor() and
    c.hasNoParameters() and
    not c.isPrivate()
  ) and
  serial.fromSource()
select serial,
  "This class is serializable, but its non-serializable " +
    "super-class $@ does not declare a no-argument constructor.", nonserial, nonserial.getName()
