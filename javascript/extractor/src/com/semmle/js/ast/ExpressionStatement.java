package com.semmle.js.ast;

/** An expression statement such as <code>alert("Hi!");</code>. */
public class ExpressionStatement extends Statement {
  private final Expression expression;

  public ExpressionStatement(SourceLocation loc, Expression expression) {
    super("ExpressionStatement", loc);
    this.expression = expression;
  }

  @Override
  public <Q, A> A accept(Visitor<Q, A> v, Q q) {
    return v.visit(this, q);
  }

  /** The expression wrapped by this expression statement. */
  public Expression getExpression() {
    return expression;
  }
}
