import java

from BinaryExpr be, string reason
where
  not exists(be.getLeftOperand()) and reason = "No left operand"
  or
  not exists(be.getRightOperand()) and reason = "No right operand"
  or
  exists(Expr e, int i |
    e.isNthChildOf(be, i) and i != 0 and i != 1 and reason = "Unexpected operand " + i.toString()
  )
  or
  be.getOp() = " ?? " and reason = "No operator name"
select be, reason
