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

class StructuralComparisonConfig extends StructuralComparisonConfiguration {
  StructuralComparisonConfig() { this = "SelfAssignment" }

  override predicate candidate(ControlFlowElement x, ControlFlowElement y) {
    exists(AssignExpr ae |
      // Member initializers are never self-assignments, in particular
      // not initializers such as `new C { F = F };`
      not ae instanceof MemberInitializer and
      // Enum field initializers are never self assignments. `enum E { A = 42 }`
      not ae.getParent().(Field).getDeclaringType() instanceof Enum
    |
      ae.getLValue() = x and
      ae.getRValue() = y
    ) and
    forall(Expr e | e = x.(Expr).getAChildExpr*() |
      // Non-trivial property accesses may have side-effects,
      // so these are not considered
      e instanceof PropertyAccess implies e instanceof TrivialPropertyAccess
    )
  }

  AssignExpr getSelfAssignExpr() {
    exists(Expr x, Expr y |
      same(x, y) and
      result.getLValue() = x and
      result.getRValue() = y
    )
  }
}

Declaration getDeclaration(Expr e) {
  result = e.(VariableAccess).getTarget()
  or
  result = e.(MemberAccess).getTarget()
  or
  result = getDeclaration(e.(ArrayAccess).getQualifier())
}

from StructuralComparisonConfig c, AssignExpr ae, Declaration target
where ae = c.getSelfAssignExpr() and target = getDeclaration(ae.getLValue())
select ae, "This assignment assigns $@ to itself.", target, target.getName()
