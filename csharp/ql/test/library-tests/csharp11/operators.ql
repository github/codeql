import csharp

query predicate binarybitwise(
  BinaryBitwiseOperation op, Expr left, Expr right, string name, string qlclass
) {
  op.getFile().getStem() = "Operators" and
  left = op.getLeftOperand() and
  right = op.getRightOperand() and
  name = op.getOperator() and
  qlclass = op.getAPrimaryQlClass()
}

query predicate assignbitwise(
  AssignBitwiseOperation op, Expr left, Expr right, string name, string qlclass
) {
  op.getFile().getStem() = "Operators" and
  left = op.getLValue() and
  right = op.getRValue() and
  name = op.getOperator() and
  qlclass = op.getAPrimaryQlClass()
}

query predicate userdefined(Operator op, string fname, string qlclass) {
  op.getFile().getStem() = "Operators" and
  fname = op.getFunctionName() and
  qlclass = op.getAPrimaryQlClass()
}
