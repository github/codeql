/**
 * @name Self-assignment
 * @description Assigning a variable to itself is useless and very likely indicates an error in the code.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id cs/self-assignment
 * @tags reliability
 *       correctness
 *       logic
 */

import csharp
import semmle.code.csharp.commons.StructuralComparison

private predicate candidate(AssignExpr ae) {
  // Member initializers are never self-assignments, in particular
  // not initializers such as `new C { F = F };`
  not ae instanceof MemberInitializer and
  // Enum field initializers are never self assignments. `enum E { A = 42 }`
  not ae.getParent().(Field).getDeclaringType() instanceof Enum and
  forall(Expr e | e = ae.getLValue().getAChildExpr*() |
    // Non-trivial property accesses may have side-effects,
    // so these are not considered
    e instanceof PropertyAccess implies e instanceof TrivialPropertyAccess
  )
}

private predicate selfAssignExpr(AssignExpr ae) {
  candidate(ae) and
  sameGvn(ae.getLValue(), ae.getRValue())
}

private Declaration getDeclaration(Expr e) {
  result = e.(VariableAccess).getTarget()
  or
  result = e.(MemberAccess).getTarget()
  or
  result = getDeclaration(e.(ArrayAccess).getQualifier())
}

from AssignExpr ae, Declaration target
where selfAssignExpr(ae) and target = getDeclaration(ae.getLValue())
select ae, "This assignment assigns $@ to itself.", target, target.getName()
