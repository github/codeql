import ruby

query predicate binaryOperations(
  BinaryOperation o, string operator, Expr left, Expr right, string pClass
) {
  operator = o.getOperator() and
  left = o.getLeftOperand() and
  right = o.getRightOperand() and
  pClass = o.getAPrimaryQlClass()
}

query predicate binaryArithmeticOperations(
  BinaryArithmeticOperation o, string operator, Expr left, Expr right, string pClass
) {
  operator = o.getOperator() and
  left = o.getLeftOperand() and
  right = o.getRightOperand() and
  pClass = o.getAPrimaryQlClass()
}

query predicate binaryLogicalOperations(
  BinaryLogicalOperation o, string operator, Expr left, Expr right, string pClass
) {
  operator = o.getOperator() and
  left = o.getLeftOperand() and
  right = o.getRightOperand() and
  pClass = o.getAPrimaryQlClass()
}

query predicate binaryBitwiseOperations(
  BinaryBitwiseOperation o, string operator, Expr left, Expr right, string pClass
) {
  operator = o.getOperator() and
  left = o.getLeftOperand() and
  right = o.getRightOperand() and
  pClass = o.getAPrimaryQlClass()
}

query predicate comparisonOperations(
  ComparisonOperation o, string operator, Expr left, Expr right, string pClass
) {
  operator = o.getOperator() and
  left = o.getLeftOperand() and
  right = o.getRightOperand() and
  pClass = o.getAPrimaryQlClass()
}

query predicate equalityOperations(
  EqualityOperation o, string operator, Expr left, Expr right, string pClass
) {
  operator = o.getOperator() and
  left = o.getLeftOperand() and
  right = o.getRightOperand() and
  pClass = o.getAPrimaryQlClass()
}

query predicate relationalOperations(
  RelationalOperation o, string operator, Expr left, Expr right, string pClass
) {
  operator = o.getOperator() and
  left = o.getLeftOperand() and
  right = o.getRightOperand() and
  pClass = o.getAPrimaryQlClass()
}

query predicate spaceshipExprs(
  SpaceshipExpr e, string operator, Expr left, Expr right, string pClass
) {
  operator = e.getOperator() and
  left = e.getLeftOperand() and
  right = e.getRightOperand() and
  pClass = e.getAPrimaryQlClass()
}

query predicate regexMatchExprs(
  RegexMatchExpr e, string operator, Expr left, Expr right, string pClass
) {
  operator = e.getOperator() and
  left = e.getLeftOperand() and
  right = e.getRightOperand() and
  pClass = e.getAPrimaryQlClass()
}

query predicate noRegexMatchExprs(
  NoRegexMatchExpr e, string operator, Expr left, Expr right, string pClass
) {
  operator = e.getOperator() and
  left = e.getLeftOperand() and
  right = e.getRightOperand() and
  pClass = e.getAPrimaryQlClass()
}
