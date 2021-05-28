/**
 * @name Swapped parameter names in overriding predicate.
 * @description Swapping the parameter names in an overriding method indicates an implementation mistake.
 * @kind problem
 * @problem.severity warning
 * @id ql/override-swapped-name
 * @tags correctness
 *       maintainability
 * @precision high
 */

import ql

pragma[noinline]
private predicate getAnOverridingParameter(
  ClassPredicate pred, ClassPredicate sup, VarDecl parameter, string parName, string superName,
  int index
) {
  pred.overrides(sup) and
  parameter = pred.getParameter(index) and
  parameter.getName() = parName and
  sup.getParameter(index).getName() = superName
}

from
  ClassPredicate pred, ClassPredicate sup, VarDecl parameter, string parName, string superName,
  int index
where
  getAnOverridingParameter(pred, sup, parameter, parName, superName, index) and
  superName != parName and
  exists(int other | other != index | sup.getParameter(other).getName() = parName)
select parameter, parName + " was $@ in the super class.", sup.getParameter(index),
  "named " + superName
