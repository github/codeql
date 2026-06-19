/**
 * @name Restrictive transitive closure
 * @description The transitive closure operation might restrict the type even when taking zero steps.
 * @kind problem
 * @problem.severity warning
 * @id ql/restrictive-transitive-closure
 * @tags correctness
 *       maintainability
 * @precision high
 */

import ql

Class base(Call c) {
  result = c.(MemberCall).getBase().getType().getDeclaration()
  or
  not c instanceof MemberCall and
  result = c.getTarget().(ClassPredicate).getParent()
}

Call closureCall() { result.isClosure("*") }

Class return(Call c) { result = c.getTarget().getReturnType().getDeclaration() }

Class superClass(Class c) { result = c.getASuperType().getResolvedType().getDeclaration() }

from Call c, Class return, Class base
where
  c = closureCall() and
  return = return(c) and
  base = base(c) and
  // We aren't restricted anyway from the surrounding code.
  not superClass*(base) = return and
  not exists(InstanceOf inst |
    inst.getExpr() = c and
    superClass*(inst.getType().getResolvedType().getDeclaration()) = return
  ) and
  not exists(ComparisonFormula comp, Expr operand | comp.getOperator() = "=" |
    comp.getAnOperand() = c and
    operand != c and
    operand = comp.getAnOperand() and
    superClass*(operand.getType().getDeclaration()) = return
  ) and
  // If the result is used in a call, then we only flag if the "closure in the middle" could be removed.
  forall(MemberCall memberCall | memberCall.getBase() = c |
    exists(ClassPredicate pred |
      pred = superClass*(base).getClassPredicate(memberCall.getMemberName()) and
      memberCall.getNumberOfArguments() = pred.getArity()
    )
  )
select c, "Closure restricts type from $@ to $@, even when taking zero steps", base, base.getName(),
  return, return.getName()
