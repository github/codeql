/**
 * @name Swapped parameter names in overriding predicate.
 * @description Swapping the parameter names in an overriding method indicates an implementation mistake.
 * @kind problem
 * @problem.severity error
 * @id ql/override-swapped-name
 * @tags correctness
 *       maintainability
 * @precision high
 */

import ql

pragma[noinline]
private predicate getAnOverridingParameter(
  ClassPredicate pred, ClassPredicate sup, VarDecl parameter, int index
) {
  pred.overrides(sup) and
  parameter = pred.getParameter(index)
}

pragma[noinline]
private predicate getAnOverridingParameterWithDifferentNames(
  ClassPredicate pred, ClassPredicate sup, VarDecl parameter, int index
) {
  getAnOverridingParameter(pred, sup, parameter, index) and
  exists(int other | other != index |
    sup.getParameter(other).getName() = pred.getParameter(index).getName()
  )
}

pragma[noinline]
private predicate getAnOverridingParameterWithDifferentNames2(
  ClassPredicate pred, ClassPredicate sup, VarDecl parameter, int index, string supName,
  string predName
) {
  getAnOverridingParameterWithDifferentNames(pred, sup, parameter, index) and
  supName = pragma[only_bind_out](pragma[only_bind_out](sup).getParameter(index)).getName() and
  predName = pragma[only_bind_out](pragma[only_bind_out](pred).getParameter(index)).getName()
}

from
  ClassPredicate pred, ClassPredicate sup, VarDecl parameter, int index, string supName,
  string predName
where
  getAnOverridingParameterWithDifferentNames2(pred, sup, parameter, index, supName, predName) and
  supName != predName
select parameter, predName + " was $@ in the super class.", sup.getParameter(index),
  "named " + supName
