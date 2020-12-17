import ruby

query predicate assignments(Assignment a, string operator, Expr left, Expr right, string pClass) {
  operator = a.getOperator() and
  left = a.getLhs() and
  right = a.getRhs() and
  pClass = a.getAPrimaryQlClass()
}

query predicate assignOperations(
  AssignOperation o, string operator, Expr left, Expr right, string pClass
) {
  operator = o.getOperator() and
  left = o.getLhs() and
  right = o.getRhs() and
  pClass = o.getAPrimaryQlClass()
}

query predicate assignArithmeticOperations(
  AssignArithmeticOperation o, string operator, Expr left, Expr right, string pClass
) {
  operator = o.getOperator() and
  left = o.getLhs() and
  right = o.getRhs() and
  pClass = o.getAPrimaryQlClass()
}

query predicate assignLogicalOperations(
  AssignLogicalOperation o, string operator, Expr left, Expr right, string pClass
) {
  operator = o.getOperator() and
  left = o.getLhs() and
  right = o.getRhs() and
  pClass = o.getAPrimaryQlClass()
}

query predicate assignBitwiseOperations(
  AssignBitwiseOperation o, string operator, Expr left, Expr right, string pClass
) {
  operator = o.getOperator() and
  left = o.getLhs() and
  right = o.getRhs() and
  pClass = o.getAPrimaryQlClass()
}
