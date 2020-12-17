import ruby

query predicate unaryOperations(UnaryOperation o, string operator, Expr operand, string pClass) {
  operator = o.getOperator() and
  operand = o.getOperand() and
  pClass = o.getAPrimaryQlClass()
}

query predicate unaryLogicalOperations(
  UnaryLogicalOperation o, string operator, Expr operand, string pClass
) {
  operator = o.getOperator() and
  operand = o.getOperand() and
  pClass = o.getAPrimaryQlClass()
}

query predicate unaryArithmeticOperations(
  UnaryArithmeticOperation o, string operator, Expr operand, string pClass
) {
  operator = o.getOperator() and
  operand = o.getOperand() and
  pClass = o.getAPrimaryQlClass()
}

query predicate unaryBitwiseOperations(
  UnaryBitwiseOperation o, string operator, Expr operand, string pClass
) {
  operator = o.getOperator() and
  operand = o.getOperand() and
  pClass = o.getAPrimaryQlClass()
}
