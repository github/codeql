import csharp

predicate getExpandedOperatorArgs(Expr e, Expr left, Expr right) {
  e =
    any(BinaryArithmeticOperation bo |
      bo.getLeftOperand() = left and
      bo.getRightOperand() = right
    )
  or
  e =
    any(OperatorCall oc |
      oc.getArgument(0) = left and
      oc.getArgument(1) = right
    )
}

from AssignOperation ao, AssignExpr ae, Expr op, Expr left, Expr right
where
  ae = ao.getExpandedAssignment() and
  op = ae.getRValue() and
  getExpandedOperatorArgs(op, left, right)
select ao, ae, ae.getLValue(), op, left, right
