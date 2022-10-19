/**
 * @name UnusedField
 * @description A field that is not used in the characteristic predicate will contain every value
 *              of its type when accessed in other predicates, which is probably not intended.
 * @kind problem
 * @problem.severity warning
 * @id ql/unused-field
 * @precision high
 */

import ql

from ClassType clz, ClassType implClz, FieldDecl field, string extraMsg
where
  clz.getDeclaration().getAField() = field and
  implClz.getASuperType*() = clz and
  // The field is not accessed in the charpred (of any of the classes)
  not exists(FieldAccess access |
    access.getEnclosingPredicate() = [clz, implClz].getDeclaration().getCharPred()
  ) and
  // The implementation class is not abstract, and the field is not an override
  not implClz.getDeclaration().isAbstract() and
  not field.isOverride() and
  // There doesn't exist a class in between `clz` and `implClz` that binds `field`.
  not exists(ClassType c, CharPred p |
    c.getASuperType*() = clz and
    implClz.getASuperType*() = c and
    p = c.getDeclaration().getCharPred() and
    exists(FieldAccess access | access.getName() = field.getName() |
      access.getEnclosingPredicate() = p
    )
  ) and
  (if clz = implClz then extraMsg = "." else extraMsg = " of any class between it and $@.")
select clz,
  "This class declares the $@ but does not bind it in the characteristic predicate" + extraMsg,
  field, "field " + field.getName(), implClz, implClz.getName()
