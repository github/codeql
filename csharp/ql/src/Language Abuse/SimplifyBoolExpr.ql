/**
 * @name Unnecessarily complex Boolean expression
 * @description Boolean expressions that are unnecessarily complicated hinder readability.
 * @id cs/simplifiable-boolean-expression
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @tags quality
 *       maintainability
 *       readability
 */

import csharp

/**
 * Holds if the left operand of a binary operation is a Boolean literal with the specified value
 * and the right operand is not a Boolean literal.
 */
predicate binaryLiteralLeft(BinaryOperation op, boolean value) {
  value = op.getLeftOperand().(BoolLiteral).getBoolValue() and
  not op.getRightOperand() instanceof BoolLiteral
}

/**
 * Holds if the right operand of a binary operation is a Boolean literal with the specified value
 * and the left operand is not a Boolean literal.
 */
predicate binaryLiteralRight(BinaryOperation op, boolean value) {
  value = op.getRightOperand().(BoolLiteral).getBoolValue() and
  not op.getLeftOperand() instanceof BoolLiteral
}

/**
 * Holds if the 'then' branch of a conditional expression is a Boolean literal with the specified value
 * and the 'condition' or 'else' branch are not Boolean literals.
 */
predicate conditionalThenLiteral(ConditionalExpr cond, boolean value) {
  value = cond.getThen().(BoolLiteral).getBoolValue() and
  not cond.getCondition() instanceof BoolLiteral and
  not cond.getElse() instanceof BoolLiteral
}

/**
 * Holds if the 'else' branch of a conditional expression is a Boolean literal with the specified value
 * and the 'condition' or 'then' branch are not Boolean literals.
 */
predicate conditionalElseLiteral(ConditionalExpr cond, boolean value) {
  value = cond.getElse().(BoolLiteral).getBoolValue() and
  not cond.getCondition() instanceof BoolLiteral and
  not cond.getThen() instanceof BoolLiteral
}

/**
 * Holds if both the 'then' and 'else' branches of a conditional expression are Boolean literals with the specified values
 * and the 'condition' branch is not a Boolean literal.
 */
predicate conditionalThenAndElseLiteral(ConditionalExpr cond, boolean thenValue, boolean elseValue) {
  thenValue = cond.getThen().(BoolLiteral).getBoolValue() and
  elseValue = cond.getElse().(BoolLiteral).getBoolValue() and
  not cond.getCondition() instanceof BoolLiteral
}

predicate rewriteBinaryExpr(BinaryOperation op, boolean value, string oldPattern) {
  op.getLeftOperand().getType() instanceof BoolType and
  op.getRightOperand().getType() instanceof BoolType and
  (
    binaryLiteralLeft(op, value) and oldPattern = value + " " + op.getOperator() + " A"
    or
    binaryLiteralRight(op, value) and oldPattern = "A " + op.getOperator() + " " + value
  )
}

predicate rewriteConditionalExpr(ConditionalExpr cond, string oldPattern, string newPattern) {
  cond.getCondition().getType() instanceof BoolType and
  cond.getThen().getType() instanceof BoolType and
  cond.getElse().getType() instanceof BoolType and
  (
    conditionalThenLiteral(cond, false) and oldPattern = "A ? false : B" and newPattern = "!A && B"
    or
    conditionalThenLiteral(cond, true) and oldPattern = "A ? true : B" and newPattern = "A || B"
    or
    conditionalElseLiteral(cond, false) and oldPattern = "A ? B : false" and newPattern = "A && B"
    or
    conditionalElseLiteral(cond, true) and oldPattern = "A ? B : true" and newPattern = "!A || B"
    or
    exists(boolean b | conditionalThenAndElseLiteral(cond, b, b) |
      oldPattern = "A ? " + b + " : " + b and newPattern = b.toString()
    )
    or
    conditionalThenAndElseLiteral(cond, true, false) and
    oldPattern = "A ? true : false" and
    newPattern = "A"
    or
    conditionalThenAndElseLiteral(cond, false, true) and
    oldPattern = "A ? false : true" and
    newPattern = "!A"
  )
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

/** Holds if replacing `expr` with `operatorName` could call an enclosing operator. */
private predicate couldCallEnclosingOperator(LogicalNotExpr expr, string operatorName) {
  exists(BinaryOperation binary, Operator enclosingOperator |
    binary = expr.getOperand() and
    enclosingOperator = expr.getEnclosingCallable().getEnclosingCallable*() and
    enclosingOperator.getName() = operatorName and
    binary
        .getLeftOperand()
        .getType()
        .isImplicitlyConvertibleTo(enclosingOperator.getParameter(0).getType()) and
    binary
        .getRightOperand()
        .getType()
        .isImplicitlyConvertibleTo(enclosingOperator.getParameter(1).getType())
  )
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
    negatedOperators(oldOperator, newOperator) and
    not couldCallEnclosingOperator(expr, newOperator)
  |
    oldPattern = "!(A " + oldOperator + " B)" and
    newPattern = "A " + newOperator + " B"
  )
}

predicate rewriteBinaryOperation(BinaryOperation op, string oldPattern, string newPattern) {
  exists(string withFalseOperand, string withTrueOperand |
    simplifyBinaryExpr(op.getOperator(), withFalseOperand, withTrueOperand)
  |
    rewriteBinaryExpr(op, false, oldPattern) and
    newPattern = withFalseOperand
    or
    rewriteBinaryExpr(op, true, oldPattern) and
    newPattern = withTrueOperand
  )
}

predicate rewrite(Expr expr, string oldPattern, string newPattern) {
  rewriteBinaryOperation(expr, oldPattern, newPattern)
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
