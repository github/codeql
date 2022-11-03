/**
 * @name Self assignment
 * @description Assigning a variable to itself has no effect.
 * @kind problem
 * @problem.severity error
 * @precision very-high
 * @id java/redundant-assignment
 * @tags reliability
 *       correctness
 *       logic
 */

import java

predicate toCompare(VarAccess left, VarAccess right) {
  exists(AssignExpr assign | assign.getDest() = left and assign.getSource() = right)
  or
  exists(VarAccess outerleft, VarAccess outerright |
    toCompare(outerleft, outerright) and
    left = outerleft.getQualifier() and
    right = outerright.getQualifier()
  )
}

predicate local(RefType enclosingType, VarAccess v) {
  enclosingType = v.getQualifier().(ThisAccess).getType()
  or
  not exists(v.getQualifier()) and enclosingType = v.getEnclosingCallable().getDeclaringType()
}

predicate sameVariable(VarAccess left, VarAccess right) {
  toCompare(left, right) and
  left.getVariable() = right.getVariable() and
  (
    exists(Expr q1, Expr q2 |
      q1 = left.getQualifier() and
      sameVariable(q1, q2) and
      q2 = right.getQualifier()
    )
    or
    exists(RefType enclosingType | local(enclosingType, left) and local(enclosingType, right))
  )
}

from AssignExpr assign
where sameVariable(assign.getDest(), assign.getSource())
select assign,
  "This assigns the variable " + assign.getDest().(VarAccess).getVariable().getName() +
    " to itself and has no effect."
