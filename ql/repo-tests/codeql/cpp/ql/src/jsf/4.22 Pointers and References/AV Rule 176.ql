/**
 * @name AV Rule 176
 * @description A typedef will be used to simplify program syntax when declaring function pointers.
 * @kind problem
 * @id cpp/jsf/av-rule-176
 * @problem.severity warning
 * @tags maintainability
 *       readability
 *       external/jsf
 */

import cpp

predicate allowed(TypeDeclarationEntry tde, FunctionPointerType t) {
  tde.getDeclaration().(TypedefType).getBaseType() = t
}

from FunctionPointerType t, Locatable l
where
  t.getATypeNameUse() = l and
  not allowed(l, t)
select l, "AV Rule 176: A typedef will be used when declaring function pointers."
