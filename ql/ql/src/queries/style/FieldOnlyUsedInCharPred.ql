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
  forex(FieldAccess access | access.getDeclaration() = f.getVarDecl() |
    access.getEnclosingPredicate() = c.getCharPred()
  ) and
  not f.getVarDecl().overrides(_)
select f, "Field is only used in CharPred"
