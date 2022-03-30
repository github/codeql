/**
 * @name Field masks field in super class
 * @description Finds fields that hide the definition of a field in a superclass,
 *              where additionally there are no references of the form 'base.f'
 *              in the subclass. This might be unintentional.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id cs/field-masks-base-field
 * @tags reliability
 *       readability
 *       naming
 */

import csharp

class VisibleInstanceField extends Field {
  VisibleInstanceField() {
    not this.isPrivate() and
    not this.isStatic()
  }
}

from RefType type, RefType supertype, VisibleInstanceField masked, VisibleInstanceField masking
where
  type.getABaseType+() = supertype and
  masking.getDeclaringType() = type and
  masked.getDeclaringType() = supertype and
  masked.getName() = masking.getName() and
  // exclude intentional masking
  not exists(FieldAccess va |
    va.getTarget() = masked and
    va.getQualifier() instanceof BaseAccess
  ) and
  type.fromSource()
select masking, "This field shadows another field in a superclass."
