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
  binaryOperations(o, operator, left, right, pClass)
}

query predicate binaryLogicalOperations(
  BinaryLogicalOperation o, string operator, Expr left, Expr right, string pClass
) {
  binaryOperations(o, operator, left, right, pClass)
}

query predicate binaryBitwiseOperations(
  BinaryBitwiseOperation o, string operator, Expr left, Expr right, string pClass
) {
  binaryOperations(o, operator, left, right, pClass)
}

query predicate comparisonOperations(
  ComparisonOperation o, string operator, Expr left, Expr right, string pClass
) {
  binaryOperations(o, operator, left, right, pClass)
}

query predicate equalityOperations(
  EqualityOperation o, string operator, Expr left, Expr right, string pClass
) {
  binaryOperations(o, operator, left, right, pClass)
}

query predicate relationalOperations(
  RelationalOperation o, string operator, Expr lesser, Expr greater, string pClass
) {
  operator = o.getOperator() and
  lesser = o.getLesserOperand() and
  greater = o.getGreaterOperand() and
  pClass = o.getAPrimaryQlClass()
}

query predicate spaceshipExprs(
  SpaceshipExpr e, string operator, Expr left, Expr right, string pClass
) {
  binaryOperations(e, operator, left, right, pClass)
}

query predicate regExpMatchExprs(
  RegExpMatchExpr e, string operator, Expr left, Expr right, string pClass
) {
  binaryOperations(e, operator, left, right, pClass)
}

query predicate noRegExpMatchExprs(
  NoRegExpMatchExpr e, string operator, Expr left, Expr right, string pClass
) {
  binaryOperations(e, operator, left, right, pClass)
}
