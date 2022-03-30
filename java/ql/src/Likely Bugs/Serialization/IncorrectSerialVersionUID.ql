/**
 * @name Incorrect serialVersionUID field
 * @description A 'serialVersionUID' field that is declared in a serializable class but is of the
 *              wrong type cannot be used by the serialization framework.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id java/incorrect-serial-version-uid
 * @tags reliability
 *       maintainability
 *       language-features
 */

import java

from Field f
where
  f.hasName("serialVersionUID") and
  (
    not f.isFinal() or
    not f.isStatic() or
    not f.getType().hasName("long")
  ) and
  f.getDeclaringType().getAStrictAncestor() instanceof TypeSerializable
select f, "serialVersionUID should be final, static, and of type long."
