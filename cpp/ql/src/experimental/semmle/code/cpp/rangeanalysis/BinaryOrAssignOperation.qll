private import cpp

Expr getLOp(Operation o) {
  result = o.(BinaryOperation).getLeftOperand() or
  result = o.(Assignment).getLValue()
}

Expr getROp(Operation o) {
  result = o.(BinaryOperation).getRightOperand() or
  result = o.(Assignment).getRValue()
}

private newtype TBinaryOrAssignOperation =
  BinaryOp(BinaryOperation op) or
  AssignOp(AssignOperation op)

class BinaryOrAssignOperation extends TBinaryOrAssignOperation {
  BinaryOperation asBinaryOp() { this = BinaryOp(result) }

  AssignOperation asAssignOp() { this = AssignOp(result) }

  Expr getLeftOperand() { result = getLOp(asBinaryOp()) or result = getLOp(asAssignOp()) }

  Expr getRightOperand() { result = getROp(asBinaryOp()) or result = getROp(asAssignOp()) }

  Expr getAnOperand() { result = getLeftOperand() or result = getRightOperand() }

  Operation getOperation() { result = asBinaryOp() or result = asAssignOp() }

  string toString() { result = asBinaryOp().toString() or result = asAssignOp().toString() }
}
