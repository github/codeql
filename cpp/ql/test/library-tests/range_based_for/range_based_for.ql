import cpp

query predicate bodies(RangeBasedForStmt rbf, Stmt body) { body = rbf.getStmt() }

query predicate variables(RangeBasedForStmt rbf, LocalVariable v, Type t) {
  v = rbf.getVariable() and
  t = v.getType()
}

query predicate ranges(RangeBasedForStmt rbf, Expr range, Type t) {
  range = rbf.getRange() and
  t = range.getType()
}

query predicate rangeVariables(RangeBasedForStmt rbf, LocalVariable rangeVar, Type t) {
  rangeVar = rbf.getRangeVariable() and
  t = rangeVar.getType()
}

query predicate conditions(RangeBasedForStmt rbf, Expr condition, Expr left, Expr right) {
  condition = rbf.getCondition() and
  (
    condition instanceof BinaryOperation and
    left = condition.(BinaryOperation).getLeftOperand() and
    right = condition.(BinaryOperation).getRightOperand()
    or
    condition instanceof FunctionCall and
    left = condition.(FunctionCall).getQualifier() and
    right = condition.(FunctionCall).getArgument(0)
  )
}

query predicate beginVariables(RangeBasedForStmt rbf, LocalVariable beginVar, Type t) {
  beginVar = rbf.getBeginVariable() and
  t = beginVar.getType()
}

query predicate endVariables(RangeBasedForStmt rbf, LocalVariable endVar, Type t) {
  endVar = rbf.getEndVariable() and
  t = endVar.getType()
}

query predicate updates(RangeBasedForStmt rbf, Expr update, Expr operand) {
  update = rbf.getUpdate() and
  (
    update instanceof UnaryOperation and
    operand = update.(UnaryOperation).getOperand()
    or
    update instanceof FunctionCall and
    operand = update.(FunctionCall).getQualifier()
  )
}
