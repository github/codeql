/**
 * @name Unnecessarily complex Boolean expression
 * @description Boolean expressions that are unnecessarily complicated hinder readability.
 * @id cs/simplifiable-boolean-expression
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @tags readability
 *       maintainability
 */

import csharp

/**
 * Holds if expression `expr` has Boolean `value` at child `child`.
 * No other child nodes are boolean literals.
 */
predicate literalChild(Expr expr, int child, boolean value) {
  value = expr.getChild(child).(BoolLiteral).getBoolValue() and
  forall(int c | c != child | not expr.getChild(c) instanceof BoolLiteral)
}

/**
 * Expression `expr` has Boolean `value1` at child `child1`, and boolean `value2` at `child2`.
 * No other child nodes are boolean literals.
 */
predicate literalChildren(Expr expr, int child1, boolean value1, int child2, boolean value2) {
  value1 = expr.getChild(child1).(BoolLiteral).getBoolValue() and
  value2 = expr.getChild(child2).(BoolLiteral).getBoolValue() and
  forall(int c | c != child1 and c != child2 | not expr.getChild(c) instanceof BoolLiteral)
}

predicate rewriteBinaryExpr(BinaryOperation op, boolean value, string oldPattern) {
  literalChild(op, 0, value) and oldPattern = value + " " + op.getOperator() + " A"
  or
  literalChild(op, 1, value) and oldPattern = "A " + op.getOperator() + " " + value
}

bindingset[withFalseOperand, withTrueOperand]
predicate rewriteBinaryExpr(
  BinaryOperation op, string oldPattern, string withFalseOperand, string withTrueOperand,
  string newPattern
) {
  rewriteBinaryExpr(op, false, oldPattern) and newPattern = withFalseOperand
  or
  rewriteBinaryExpr(op, true, oldPattern) and newPattern = withTrueOperand
}

predicate rewriteConditionalExpr(ConditionalExpr cond, string oldPattern, string newPattern) {
  literalChild(cond, 1, false) and oldPattern = "A ? false : B" and newPattern = "!A && B"
  or
  literalChild(cond, 1, true) and oldPattern = "A ? true : B" and newPattern = "A || B"
  or
  literalChild(cond, 2, false) and oldPattern = "A ? B : false" and newPattern = "A && B"
  or
  literalChild(cond, 2, true) and oldPattern = "A ? B : true" and newPattern = "!A || B"
  or
  exists(boolean b | literalChildren(cond, 1, b, 2, b) |
    oldPattern = "A ? " + b + " : " + b and newPattern = b.toString()
  )
  or
  literalChildren(cond, 1, true, 2, false) and oldPattern = "A ? true : false" and newPattern = "A"
  or
  literalChildren(cond, 1, false, 2, true) and oldPattern = "A ? false : true" and newPattern = "!A"
}

predicate negatedOperators(string op, string negated) {
  op = "==" and negated = "!="
  or
  op = "<" and negated = ">="
  or
  op = ">" and negated = "<="
  or
  negatedOperators(negated, op)
}

predicate simplifyBinaryExpr(string op, string withFalseOperand, string withTrueOperand) {
  op = "==" and withTrueOperand = "A" and withFalseOperand = "!A"
  or
  op = "!=" and withTrueOperand = "!A" and withFalseOperand = "A"
  or
  op = "&&" and withTrueOperand = "A" and withFalseOperand = "false"
  or
  op = "||" and withTrueOperand = "true" and withFalseOperand = "A"
}

predicate pushNegation(LogicalNotExpr expr, string oldPattern, string newPattern) {
  expr.getOperand() instanceof LogicalNotExpr and oldPattern = "!!A" and newPattern = "A"
  or
  exists(string oldOperator, string newOperator |
    oldOperator = expr.getOperand().(BinaryOperation).getOperator() and
    negatedOperators(oldOperator, newOperator)
  |
    oldPattern = "!(A " + oldOperator + " B)" and
    newPattern = "A " + newOperator + " B"
  )
}

predicate rewrite(Expr expr, string oldPattern, string newPattern) {
  exists(string withFalseOperand, string withTrueOperand |
    simplifyBinaryExpr(expr.(BinaryOperation).getOperator(), withFalseOperand, withTrueOperand)
  |
    rewriteBinaryExpr(expr, oldPattern, withFalseOperand, withTrueOperand, newPattern)
  )
  or
  rewriteConditionalExpr(expr, oldPattern, newPattern)
  or
  pushNegation(expr, oldPattern, newPattern)
}

from Expr expr, string oldPattern, string newPattern, string action
where
  rewrite(expr, oldPattern, newPattern) and
  if newPattern = "true" or newPattern = "false"
  then action = "is always"
  else action = "can be simplified to"
select expr, "The expression '" + oldPattern + "' " + action + " '" + newPattern + "'."
