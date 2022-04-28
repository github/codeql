/**
 * @name Field only used in CharPred
 * @description A field only being used in the charpred suggests that the field should be inlined into the charpred.
 * @kind problem
 * @problem.severity recommendation
 * @id ql/field-only-used-in-charpred
 * @tags maintainability
 * @precision very-high
 */

import ql

from Class c, FieldDecl f
where
  c.getAField() = f and
  forex(FieldAccess access | access.getDeclaration() = f |
    access.getEnclosingPredicate() = c.getCharPred()
  ) and
  // excluding fields that are uniquely used in call to an IPA constructor
  not unique(FieldAccess access | access.getDeclaration() = f | access) =
    any(PredicateCall call |
      call.getEnclosingPredicate() = c.getCharPred() and call.getTarget() instanceof NewTypeBranch
    ).getAnArgument() and
  not f.getVarDecl().overrides(_)
select f, "Field is only used in CharPred"
