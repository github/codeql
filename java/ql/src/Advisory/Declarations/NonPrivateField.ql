/**
 * @name Non-private field
 * @description A non-constant field that is not declared 'private',
 *              but is not accessed outside of its declaring type, may decrease code maintainability.
 * @kind problem
 * @problem.severity recommendation
 * @precision medium
 * @id java/non-private-field
 * @tags maintainability
 */

import java

class NonConstantSourceField extends Field {
  NonConstantSourceField() {
    this.fromSource() and
    not (this.isFinal() and this.isStatic())
  }
}

from NonConstantSourceField f
where
  not f.isPrivate() and
  not exists(VarAccess va | va.getVariable() = f |
    va.getEnclosingCallable().getDeclaringType() != f.getDeclaringType()
  ) and
  not f.getAnAnnotation() instanceof ReflectiveAccessAnnotation
select f, "This non-private field is not accessed outside of its declaring type."
