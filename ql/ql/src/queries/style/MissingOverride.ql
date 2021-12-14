/**
 * @name Missing override annotation
 * @description Predicates that overide another predicate should have an `override` annotation.
 * @kind problem
 * @problem.severity warning
 * @precision very-high
 * @id ql/missing-override
 * @tags maintainability
 */

import ql

string getQualifiedName(ClassPredicate p) {
  result = p.getDeclaringType().getName() + "." + p.getName()
}

from ClassPredicate pred, ClassPredicate sup
where pred.overrides(sup) and not pred.isOverride()
select pred, getQualifiedName(pred) + " overrides $@ but does not have an override annotation.",
  sup, getQualifiedName(sup)
