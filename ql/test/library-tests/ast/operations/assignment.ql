import ruby

query predicate assignments(Assignment a, string operator, Expr left, Expr right, string pClass) {
  operator = a.getOperator() and
  left = a.getLeftOperand() and
  right = a.getRightOperand() and
  pClass = a.getAPrimaryQlClass()
}

query predicate assignOperations(
  AssignOperation o, string operator, Expr left, Expr right, string pClass
) {
  operator = o.getOperator() and
  left = o.getLeftOperand() and
  right = o.getRightOperand() and
  pClass = o.getAPrimaryQlClass()
}

query predicate assignArithmeticOperations(
  AssignArithmeticOperation o, string operator, Expr left, Expr right, string pClass
) {
  assignOperations(o, operator, left, right, pClass)
}

query predicate assignLogicalOperations(
  AssignLogicalOperation o, string operator, Expr left, Expr right, string pClass
) {
  assignOperations(o, operator, left, right, pClass)
}

query predicate assignBitwiseOperations(
  AssignBitwiseOperation o, string operator, Expr left, Expr right, string pClass
) {
  assignOperations(o, operator, left, right, pClass)
}
