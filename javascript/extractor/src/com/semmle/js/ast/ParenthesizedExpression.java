package com.semmle.js.ast;

/** A parenthesized expression. */
public class ParenthesizedExpression extends Expression {
  private final Expression expression;

  public ParenthesizedExpression(SourceLocation loc, Expression expression) {
    super("ParenthesizedExpression", loc);
    this.expression = expression;
  }

  @Override
  public <Q, A> A accept(Visitor<Q, A> v, Q q) {
    return v.visit(this, q);
  }

  /** The expression between parentheses. */
  public Expression getExpression() {
    return expression;
  }

  @Override
  public Expression stripParens() {
    return expression.stripParens();
  }
}
