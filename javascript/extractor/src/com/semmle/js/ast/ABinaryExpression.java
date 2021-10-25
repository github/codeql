package com.semmle.js.ast;

/**
 * An expression involving an operator and two operands; may be an {@link AssignmentExpression}, a
 * {@link BinaryExpression} or a {@link LogicalExpression}.
 */
public abstract class ABinaryExpression extends Expression {
  private final String operator;
  private final Expression left, right;

  public ABinaryExpression(
      SourceLocation loc, String type, String operator, Expression left, Expression right) {
    super(type, loc);
    this.operator = operator;
    this.left = left;
    this.right = right;
  }

  public String getOperator() {
    return operator;
  }

  public Expression getLeft() {
    return left;
  }

  public Expression getRight() {
    return right;
  }
}
